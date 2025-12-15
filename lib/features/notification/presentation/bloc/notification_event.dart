import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchNotificationsEvent extends NotificationEvent {
  final int page;
  final int size;
  final bool refresh; // If true, reset the list; if false, append to existing

  FetchNotificationsEvent({this.page = 0, this.size = 20, this.refresh = true});

  @override
  List<Object?> get props => [page, size, refresh];
}

class LoadMoreNotificationsEvent extends NotificationEvent {
  LoadMoreNotificationsEvent();

  @override
  List<Object?> get props => [];
}

class NotificationReceivedEvent extends NotificationEvent {
  final RemoteMessage message;

  NotificationReceivedEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

class NotificationClickedEvent extends NotificationEvent {
  final RemoteMessage message;

  NotificationClickedEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

class SendFcmTokenEvent extends NotificationEvent {}

class RemoveFcmTokenEvent extends NotificationEvent {}

class MarkNotificationAsReadEvent extends NotificationEvent {
  final int notificationId;

  MarkNotificationAsReadEvent({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}
