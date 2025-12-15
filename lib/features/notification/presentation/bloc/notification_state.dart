import 'package:complaint_app/features/notification/domain/entities/notification_entity.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final List<NotificationEntity> notifications;
  final bool hasNext;
  final int currentPage;
  final int totalElements;
  final bool isLoadingMore;

  NotificationSuccess({
    required this.notifications,
    this.hasNext = false,
    this.currentPage = 0,
    this.totalElements = 0,
    this.isLoadingMore = false,
  });

  NotificationSuccess copyWith({
    List<NotificationEntity>? notifications,
    bool? hasNext,
    int? currentPage,
    int? totalElements,
    bool? isLoadingMore,
  }) {
    return NotificationSuccess(
      notifications: notifications ?? this.notifications,
      hasNext: hasNext ?? this.hasNext,
      currentPage: currentPage ?? this.currentPage,
      totalElements: totalElements ?? this.totalElements,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [notifications, hasNext, currentPage, totalElements, isLoadingMore];
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError({required this.message});

  @override
  List<Object?> get props => [message];
}

class FcmTokenSent extends NotificationState {}

class FcmTokenRemoved extends NotificationState {}
