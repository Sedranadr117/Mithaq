import 'dart:convert';
import 'package:complaint_app/features/complaints/presentation/pages/complaints_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:complaint_app/config/extensions/navigator.dart';
import 'package:complaint_app/features/complaints/presentation/pages/respond_to_info_request_page.dart';
import 'package:complaint_app/features/notification/domain/entities/notification_entity.dart';
import 'package:complaint_app/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:complaint_app/features/notification/presentation/bloc/notification_event.dart';
import 'package:complaint_app/features/notification/presentation/bloc/notification_state.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    // Fetch notifications when page is first opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<NotificationBloc>().add(FetchNotificationsEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          onPressed: () {
            context.popPage(HomePage());
          },
        ),
        title: Text(
          'الإشعارات',
          style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          // Debug: Log state changes
          if (state is NotificationSuccess) {
            debugPrint(
              '📬 Notification state updated: ${state.notifications.length} notifications',
            );
          } else if (state is NotificationError) {
            debugPrint('❌ Notification error: ${state.message}');
            // Show error snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          // Use notifications from state if available, otherwise from bloc
          final bloc = context.read<NotificationBloc>();
          final notifications = state is NotificationSuccess
              ? state.notifications
              : bloc.notifications;

          if (state is NotificationLoading && notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationError && notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48.sp,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  SizedBox(height: 2.h),
                  Text('خطأ', style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 1.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      (state).message,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton(
                    onPressed: () => context.read<NotificationBloc>().add(
                      FetchNotificationsEvent(),
                    ),
                    child: const Text('اعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64.sp,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.5),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'لا يوجد إشعارات',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'ليس لديك اشعارات بعد',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          final hasNext = state is NotificationSuccess ? state.hasNext : false;
          final isLoadingMore = state is NotificationSuccess
              ? state.isLoadingMore
              : false;
          final totalElements = state is NotificationSuccess
              ? state.totalElements
              : notifications.length;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<NotificationBloc>().add(
                FetchNotificationsEvent(refresh: true),
              );
            },
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              itemCount:
                  notifications.length +
                  (hasNext ? 1 : 0), // +1 for load more button
              itemBuilder: (context, index) {
                // Show load more button at the end
                if (index == notifications.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: Center(
                      child: isLoadingMore
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                context.read<NotificationBloc>().add(
                                  LoadMoreNotificationsEvent(),
                                );
                              },
                              child: Text(
                                'تحميل المزيد (${notifications.length} / $totalElements)',
                              ),
                            ),
                    ),
                  );
                }

                final notification = notifications[index];
                return _buildNotificationCard(context, notification);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationEntity notification,
  ) {
    final theme = Theme.of(context);
    final isUnread =
        notification.status == 'unread' || notification.readAt == null;

    return InkWell(
      onTap: () {
        // Mark notification as read when clicked
        if (isUnread) {
          context.read<NotificationBloc>().add(
            MarkNotificationAsReadEvent(notificationId: notification.id),
          );
        }

        // Navigate to info request page if notification type is info_requested
        if (notification.notificationType == 'info_requested' &&
            notification.data != null) {
          try {
            final dataMap =
                json.decode(notification.data!) as Map<String, dynamic>;
            final requestId = dataMap['requestId'] as String?;
            final complaintId = dataMap['complaintId'] as String?;
            if (requestId != null) {
              final infoRequestId = int.tryParse(requestId);
              final complaintIdInt = complaintId != null
                  ? int.tryParse(complaintId)
                  : null;
              if (infoRequestId != null) {
                context.pushPage(
                  RespondToInfoRequestPage(
                    infoRequestId: infoRequestId,
                    complaintId: complaintIdInt,
                  ),
                );
              }
            }
          } catch (e) {
            debugPrint('❌ Error parsing notification data: $e');
          }
        }
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 2.h),
        elevation: isUnread ? 2 : 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: isUnread
                      ? theme.colorScheme.primary.withOpacity(0.1)
                      : theme.colorScheme.onSurface.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getNotificationIcon(notification.notificationType),
                  color: isUnread
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.5),
                  size: 6.w,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: isUnread
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isUnread
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onSurface.withOpacity(
                                      0.8,
                                    ),
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 2.w,
                            height: 2.w,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      notification.body,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (notification.sentAt != null) ...[
                      SizedBox(height: 1.h),
                      Text(
                        _formatDate(notification.sentAt!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          if (difference.inMinutes == 0) {
            return 'الآن';
          }
          return 'منذ ${difference.inMinutes} ${difference.inMinutes == 1 ? 'دقيقة' : 'دقائق'}';
        }
        return 'منذ ${difference.inHours} ${difference.inHours == 1 ? 'ساعة' : 'ساعات'}';
      } else if (difference.inDays == 1) {
        return 'أمس';
      } else if (difference.inDays < 7) {
        return 'منذ ${difference.inDays} ${difference.inDays == 1 ? 'يوم' : 'أيام'}';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'complaint_created':
        return Icons.notification_add;
      case 'info_requested':
        return Icons.question_answer;
      default:
        return Icons.notifications;
    }
  }
}
