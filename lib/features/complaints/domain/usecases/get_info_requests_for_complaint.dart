import 'package:complaint_app/core/errors/failure.dart';
import 'package:complaint_app/features/complaints/domain/entities/info_request_entity.dart';
import 'package:complaint_app/features/complaints/domain/repositories/complaints_repository.dart';
import 'package:dartz/dartz.dart';

class GetInfoRequestsForComplaint {
  final ComplaintRepository repository;

  GetInfoRequestsForComplaint({required this.repository});

  Future<Either<Failure, InfoRequestPageEntity>> call({
    required int complaintId,
    int page = 0,
    int size = 10,
  }) {
    return repository.getInfoRequestsForComplaint(
      complaintId: complaintId,
      page: page,
      size: size,
    );
  }
}
