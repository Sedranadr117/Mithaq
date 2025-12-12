<<<<<<< HEAD
=======
import 'package:complaint_app/features/complaints/domain/entities/complaints_pageination_entity.dart';
>>>>>>> auth
import 'package:dartz/dartz.dart';
import '../../../../../../core/errors/failure.dart';
import '../../../../../../core/params/params.dart';
import '../entities/complaints_entity.dart';

abstract class ComplaintRepository {
  Future<Either<Failure, ComplaintEntity>> getTemplate({
    required TemplateParams params,
  });
  Future<Either<Failure, ComplaintEntity>> addComplaint({
    required AddComplaintParams complaint,
  });
<<<<<<< HEAD
=======
  Future<Either<Failure, ComplaintsPageEntity>> getAllComplaints({
    int page = 0,
    int size = 10,
    String? status,
  });
>>>>>>> auth
}
