import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:complaint_app/core/params/params.dart';
import 'package:complaint_app/core/services/notification_service.dart';
import 'package:complaint_app/features/notification/data/models/notification_model.dart';
import 'package:complaint_app/features/notification/domain/entities/notification_entity.dart';
import 'package:complaint_app/features/notification/domain/usecases/delete_fcm_token.dart';
import 'package:complaint_app/features/notification/domain/usecases/get_notification.dart';
import 'package:complaint_app/features/notification/domain/usecases/mark_notification_read.dart';
import 'package:complaint_app/features/notification/domain/usecases/post_fcm_token.dart';
import 'package:complaint_app/features/notification/presentation/bloc/notification_event.dart';
import 'package:complaint_app/features/notification/presentation/bloc/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotification getNotification;
  final PostFcmToken postFcmToken;
  final DeleteFcmToken deleteFcmToken;
  final MarkNotificationRead markNotificationRead;

  List<NotificationEntity> notifications = [];
  int _currentPage = 0;
  bool _hasNext = false;
  int _totalElements = 0;
  bool _isLoadingMore = false;

  NotificationBloc({
    required this.getNotification,
    required this.postFcmToken,
    required this.deleteFcmToken,
    required this.markNotificationRead,
  }) : super(NotificationInitial()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<LoadMoreNotificationsEvent>(_onLoadMoreNotifications);
    on<NotificationReceivedEvent>(_onNotificationReceived);
    on<NotificationClickedEvent>(_onNotificationClicked);
    on<SendFcmTokenEvent>(_onSendFcmToken);
    on<RemoveFcmTokenEvent>(_onRemoveFcmToken);
    on<MarkNotificationAsReadEvent>(_onMarkNotificationAsRead);

    // Note: Global notification listeners are set up in main.dart
    // to ensure they work from anywhere in the app
  }

  void _onFetchNotifications(
    FetchNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    // If refreshing, show loading; if loading more, keep current state
    if (event.refresh) {
      emit(NotificationLoading());
    } else {
      // Keep current state but mark as loading more
      _isLoadingMore = true;
      if (state is NotificationSuccess) {
        emit((state as NotificationSuccess).copyWith(isLoadingMore: true));
      }
    }

    try {
      final params = NotificationParams(page: event.page, size: event.size);
      final result = await getNotification(params: params);

      result.fold(
        (failure) {
          _isLoadingMore = false;
          emit(NotificationError(message: failure.errMessage));
          debugPrint('❌ Failed to fetch notifications: ${failure.errMessage}');
        },
        (paginatedEntity) {
          // Show all notifications regardless of status (SENT, FAILED, etc.)
          final newNotifications = paginatedEntity.content;

          // If refreshing, replace the list; otherwise, append
          if (event.refresh) {
            notifications = newNotifications;
            _currentPage = paginatedEntity.page;
          } else {
            // Append new notifications, avoiding duplicates
            final existingIds = notifications.map((n) => n.id).toSet();
            final uniqueNewNotifications = newNotifications
                .where((n) => !existingIds.contains(n.id))
                .toList();
            notifications.addAll(uniqueNewNotifications);
            _currentPage = paginatedEntity.page;
          }

          _hasNext = paginatedEntity.hasNext;
          _totalElements = paginatedEntity.totalElements;
          _isLoadingMore = false;

          emit(
            NotificationSuccess(
              notifications: List.from(notifications),
              hasNext: _hasNext,
              currentPage: _currentPage,
              totalElements: _totalElements,
              isLoadingMore: false,
            ),
          );
          debugPrint(
            '✅ Successfully fetched ${paginatedEntity.content.length} notifications (page ${paginatedEntity.page}, total: ${paginatedEntity.totalElements}, hasNext: ${paginatedEntity.hasNext})',
          );
        },
      );
    } catch (e) {
      _isLoadingMore = false;
      emit(
        NotificationError(
          message: 'An unexpected error occurred. Please try again.',
        ),
      );
      debugPrint('💥 Exception occurred while fetching notifications: $e');
    }
  }

  void _onLoadMoreNotifications(
    LoadMoreNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    // Don't load more if already loading or no more pages
    if (_isLoadingMore || !_hasNext) {
      debugPrint(
        '⚠️ Cannot load more: isLoadingMore=$_isLoadingMore, hasNext=$_hasNext',
      );
      return;
    }

    // Load next page
    final nextPage = _currentPage + 1;
    debugPrint('📄 Loading more notifications: page $nextPage');
    add(FetchNotificationsEvent(page: nextPage, size: 20, refresh: false));
  }

  void _onNotificationReceived(
    NotificationReceivedEvent event,
    Emitter<NotificationState> emit,
  ) {
    // Convert RemoteMessage to NotificationEntity and add to list
    final notification = NotificationEntity(
      id: int.tryParse(event.message.data['id'] ?? '0') ?? 0,
      title: event.message.notification?.title ?? '',
      body: event.message.notification?.body ?? '',
      notificationType: event.message.data['type'] ?? 'general',
      sentAt: event.message.sentTime?.toIso8601String(),
      readAt: null,
      status: 'unread',
      data: event.message.data['data'],
    );

    // Add to the beginning of the list
    notifications.insert(0, notification);

    // Emit current state (preserve existing state type if available)
    final currentState = state;
    if (currentState is NotificationSuccess) {
      emit(currentState.copyWith(notifications: List.from(notifications)));
    } else {
      // If no previous success state, emit new one
      emit(
        NotificationSuccess(
          notifications: List.from(notifications),
          hasNext: _hasNext,
          currentPage: _currentPage,
          totalElements: _totalElements,
        ),
      );
    }
  }

  void _onNotificationClicked(
    NotificationClickedEvent event,
    Emitter<NotificationState> emit,
  ) {
    debugPrint("📬 Notification clicked: ${event.message.messageId}");

    // Add notification to list first
    add(NotificationReceivedEvent(message: event.message));

    // Note: Navigation should be handled in the UI layer using BlocListener
    // The current state is maintained, navigation will be triggered from UI
  }

  void _onSendFcmToken(
    SendFcmTokenEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final token = await NotificationService.instance.getSavedToken();
      if (token == null || token.isEmpty) {
        debugPrint('⚠️ FCM token not available');
        return;
      }

      final deviceType = Platform.isAndroid ? 'ANDROID' : 'IOS';

      // Get device information (optional)
      String? deviceInfo;
      try {
        final deviceInfoPlugin = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          final androidInfo = await deviceInfoPlugin.androidInfo;
          deviceInfo =
              '${androidInfo.manufacturer} ${androidInfo.model} (Android ${androidInfo.version.release})';
        } else if (Platform.isIOS) {
          final iosInfo = await deviceInfoPlugin.iosInfo;
          deviceInfo =
              '${iosInfo.name} ${iosInfo.model} (iOS ${iosInfo.systemVersion})';
        }
        debugPrint('📱 Device Info: $deviceInfo');
      } catch (e) {
        debugPrint('⚠️ Failed to get device info: $e');
        // deviceInfo remains null (optional field)
      }

      final params = FcmTokenParams(
        deviceToken: token,
        deviceType: deviceType,
        deviceInfo: deviceInfo, // Optional
      );

      final result = await postFcmToken(params: params);

      result.fold(
        (failure) {
          debugPrint('❌ Failed to send FCM token: ${failure.errMessage}');
        },
        (_) {
          emit(FcmTokenSent());
          debugPrint('✅ FCM token sent successfully');
        },
      );
    } catch (e) {
      debugPrint('💥 Exception occurred while sending FCM token: $e');
    }
  }

  void _onRemoveFcmToken(
    RemoveFcmTokenEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final token = await NotificationService.instance.getSavedToken();
      if (token == null || token.isEmpty) {
        debugPrint('⚠️ FCM token not available for removal');
        return;
      }

      final params = DeleteFcmTokenParams(deviceToken: token);
      final result = await deleteFcmToken(params: params);

      result.fold(
        (failure) {
          debugPrint('❌ Failed to remove FCM token: ${failure.errMessage}');
        },
        (_) {
          emit(FcmTokenRemoved());
          debugPrint('✅ FCM token removed successfully');
        },
      );
    } catch (e) {
      debugPrint('💥 Exception occurred while removing FCM token: $e');
    }
  }

  void _onMarkNotificationAsRead(
    MarkNotificationAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final result = await markNotificationRead(
        notificationId: event.notificationId,
      );

      result.fold(
        (failure) {
          emit(NotificationError(message: failure.errMessage));
          debugPrint(
            '❌ Failed to mark notification as read: ${failure.errMessage}',
          );
        },
        (_) {
          // Update the notification in the list to mark it as read
          final index = notifications.indexWhere(
            (n) => n.id == event.notificationId,
          );
          if (index != -1) {
            final notification = notifications[index];
            // Create updated notification with readAt set to now
            // Use NotificationModel to match the type in the list
            final updatedNotification = NotificationModel(
              id: notification.id,
              title: notification.title,
              body: notification.body,
              notificationType: notification.notificationType,
              sentAt: notification.sentAt,
              readAt: DateTime.now().toIso8601String(),
              status: notification.status,
              data: notification.data,
            );
            // Create a new list to ensure reactivity
            final updatedNotifications = List<NotificationEntity>.from(
              notifications,
            );
            updatedNotifications[index] = updatedNotification;
            notifications = updatedNotifications;
            // Emit new state to trigger UI rebuild
            final currentState = state;
            if (currentState is NotificationSuccess) {
              emit(
                currentState.copyWith(
                  notifications: List.from(updatedNotifications),
                ),
              );
            } else {
              emit(
                NotificationSuccess(
                  notifications: List.from(updatedNotifications),
                  hasNext: _hasNext,
                  currentPage: _currentPage,
                  totalElements: _totalElements,
                ),
              );
            }
            debugPrint('✅ Notification ${event.notificationId} marked as read');
          }
        },
      );
    } catch (e) {
      debugPrint(
        '💥 Exception occurred while marking notification as read: $e',
      );
    }
  }

  @override
  Future<void> close() {
    // Don't clear callbacks here - they should persist for the app lifetime
    // The callbacks are set in main.dart and should remain active
    return super.close();
  }
}
