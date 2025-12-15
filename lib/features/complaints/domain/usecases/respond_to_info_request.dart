import 'package:complaint_app/core/errors/failure.dart';
import 'package:complaint_app/core/params/params.dart';
import 'package:complaint_app/features/complaints/domain/entities/complaints_entity.dart';
import 'package:complaint_app/features/complaints/domain/repositories/complaints_repository.dart';
import 'package:dartz/dartz.dart';

class RespondToInfoRequest {
  final ComplaintRepository repository;

  RespondToInfoRequest({required this.repository});

  Future<Either<Failure, ComplaintEntity>> call({
    required RespondToInfoRequestParams params,
  }) {
    return repository.respondToInfoRequest(params: params);
  }
}
