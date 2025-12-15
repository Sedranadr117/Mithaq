import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../repositories/notification_repository.dart';

class MarkNotificationRead {
  final NotificationRepository repository;

  MarkNotificationRead({required this.repository});

  Future<Either<Failure, Unit>> call({required int notificationId}) {
    return repository.markNotificationAsRead(notificationId: notificationId);
  }
}

