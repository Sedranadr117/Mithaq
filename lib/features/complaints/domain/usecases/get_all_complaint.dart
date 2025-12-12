import 'package:complaint_app/core/errors/failure.dart';
import 'package:complaint_app/features/complaints/domain/entities/complaints_pageination_entity.dart';
import 'package:complaint_app/features/complaints/domain/repositories/complaints_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllComplaint {
  final ComplaintRepository repository;

  GetAllComplaint({required this.repository});

  Future<Either<Failure, ComplaintsPageEntity>> call({
    int page = 0,
    int size = 10,
    String? status,
  }) async {
    return await repository.getAllComplaints(
      page: page,
      size: size,
      status: status,
    );
  }
}
