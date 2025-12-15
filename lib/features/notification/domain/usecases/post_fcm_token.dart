import 'package:dartz/dartz.dart';
import 'package:complaint_app/core/errors/failure.dart';
import 'package:complaint_app/core/params/params.dart';
import 'package:complaint_app/features/notification/domain/repositories/notification_repository.dart';

class PostFcmToken {
  final NotificationRepository repository;

  PostFcmToken({required this.repository});

  Future<Either<Failure, Unit>> call({required FcmTokenParams params}) {
    return repository.postFcmToken(params: params);
  }
}
