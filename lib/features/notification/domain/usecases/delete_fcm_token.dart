import 'package:dartz/dartz.dart';
import 'package:complaint_app/core/errors/failure.dart';
import 'package:complaint_app/core/params/params.dart';
import 'package:complaint_app/features/notification/domain/repositories/notification_repository.dart';

class DeleteFcmToken {
  final NotificationRepository repository;

  DeleteFcmToken({required this.repository});

  Future<Either<Failure, Unit>> call({required DeleteFcmTokenParams params}) {
    return repository.deleteFcmToken(params: params);
  }
}
