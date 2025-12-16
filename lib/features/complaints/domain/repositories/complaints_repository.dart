import 'package:complaint_app/features/complaints/domain/entities/complaints_pageination_entity.dart';
import 'package:complaint_app/features/complaints/domain/entities/info_request_entity.dart';
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
  Future<Either<Failure, ComplaintsPageEntity>> getAllComplaints({
    int page = 0,
    int size = 10,
  });
  Future<Either<Failure, ComplaintsPageEntity>> filterComplaints({
    int page = 0,
    int size = 10,
    String? status,
    String? type,
    String? governorate,
    String? governmentAgency,
    int? citizenId,
  });
  Future<Either<Failure, ComplaintEntity>> respondToInfoRequest({
    required RespondToInfoRequestParams params,
  });
  Future<Either<Failure, InfoRequestPageEntity>> getInfoRequestsForComplaint({
    required int complaintId,
    int page = 0,
    int size = 10,
  });
}
