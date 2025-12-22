import 'package:complaint_app/features/complaints/data/datasources/complaints_remote_data_source.dart';
import 'package:complaint_app/features/complaints/domain/entities/complaints_entity.dart';
import 'package:complaint_app/features/complaints/domain/entities/complaints_pageination_entity.dart';
import 'package:complaint_app/features/complaints/domain/entities/info_request_entity.dart';
import 'package:complaint_app/features/complaints/domain/repositories/complaints_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../../core/errors/failure.dart';
import '../../../../../../core/params/params.dart';

class ComplaintRepositoryImpl extends ComplaintRepository {
  final NetworkInfo networkInfo;
  final ComplaintsRemoteDataSource remoteDataSource;
  ComplaintRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, ComplaintEntity>> getTemplate({
    required TemplateParams params,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTemplate = await remoteDataSource.getTemplate(params);
        return Right(remoteTemplate);
      } on ServerException catch (e) {
        return Left(
          Failure(
            errMessage: e.errorModel.errorMessage,
            statusCode: e.errorModel.status,
          ),
        );
      } catch (e) {
        return Left(
          Failure(
            errMessage: 'Unexpected error: ${e.toString()}',
            statusCode: 500,
          ),
        );
      }
    } else {
      return Left(
        Failure(
          errMessage:
              'لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك والمحاولة مرة أخرى.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ComplaintEntity>> addComplaint({
    required AddComplaintParams complaint,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteComplaint = await remoteDataSource.addComplaint(complaint);
        return Right(remoteComplaint);
      } on ServerException catch (e) {
        return Left(
          Failure(
            errMessage: e.errorModel.errorMessage,
            statusCode: e.errorModel.status,
          ),
        );
      } catch (e) {
        return Left(
          Failure(
            errMessage: 'Unexpected error: ${e.toString()}',
            statusCode: 500,
          ),
        );
      }
    } else {
      return Left(
        Failure(
          errMessage:
              'لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك والمحاولة مرة أخرى.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ComplaintsPageEntity>> getAllComplaints({
    int page = 0,
    int size = 10,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteComplaints = await remoteDataSource.getAllComplaints(
          page: page,
          size: size,
        );
        return Right(remoteComplaints);
      } on ServerException catch (e) {
        return Left(
          Failure(
            errMessage: e.errorModel.errorMessage,
            statusCode: e.errorModel.status,
          ),
        );
      } catch (e) {
        return Left(
          Failure(
            errMessage: 'Unexpected error: ${e.toString()}',
            statusCode: 500,
          ),
        );
      }
    } else {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت..'));
    }
  }

  @override
  Future<Either<Failure, ComplaintsPageEntity>> filterComplaints({
    int page = 0,
    int size = 10,
    String? status,
    String? type,
    String? governorate,
    String? governmentAgency,
    int? citizenId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteComplaints = await remoteDataSource.filterComplaints(
          page: page,
          size: size,
          status: status,
          type: type,
          governorate: governorate,
          governmentAgency: governmentAgency,
          citizenId: citizenId,
        );
        return Right(remoteComplaints);
      } on ServerException catch (e) {
        return Left(
          Failure(
            errMessage: e.errorModel.errorMessage,
            statusCode: e.errorModel.status,
          ),
        );
      } catch (e) {
        return Left(
          Failure(
            errMessage: 'Unexpected error: ${e.toString()}',
            statusCode: 500,
          ),
        );
      }
    } else {
      return Left(
        Failure(
          errMessage:
              'لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك والمحاولة مرة أخرى.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ComplaintEntity>> respondToInfoRequest({
    required RespondToInfoRequestParams params,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await remoteDataSource.respondToInfoRequest(
          params,
        );
        return Right(remoteResponse);
      } on ServerException catch (e) {
        return Left(
          Failure(
            errMessage: e.errorModel.errorMessage,
            statusCode: e.errorModel.status,
          ),
        );
      } catch (e) {
        return Left(
          Failure(
            errMessage: 'Unexpected error: ${e.toString()}',
            statusCode: 500,
          ),
        );
      }
    } else {
      return Left(
        Failure(
          errMessage:
              'لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك والمحاولة مرة أخرى.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, InfoRequestPageEntity>> getInfoRequestsForComplaint({
    required int complaintId,
    int page = 0,
    int size = 10,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteInfoRequests = await remoteDataSource
            .getInfoRequestsForComplaint(
              complaintId: complaintId,
              page: page,
              size: size,
            );
        return Right(remoteInfoRequests);
      } on ServerException catch (e) {
        return Left(
          Failure(
            errMessage: e.errorModel.errorMessage,
            statusCode: e.errorModel.status,
          ),
        );
      } catch (e) {
        return Left(
          Failure(
            errMessage: 'Unexpected error: ${e.toString()}',
            statusCode: 500,
          ),
        );
      }
    } else {
      return Left(
        Failure(
          errMessage:
              'لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك والمحاولة مرة أخرى.',
        ),
      );
    }
  }
}
