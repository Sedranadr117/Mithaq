import 'dart:convert';

import 'package:complaint_app/core/errors/error_model.dart';
import 'package:complaint_app/core/errors/exceptions.dart';
import 'package:complaint_app/features/complaints/data/models/complaints_model.dart';
import 'package:complaint_app/features/complaints/data/models/complaints_pageination_model.dart';
import 'package:complaint_app/features/complaints/data/models/info_request_model.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../../../../../core/databases/api/api_consumer.dart';
import '../../../../../../core/databases/api/end_points.dart';
import '../../../../../../core/params/params.dart';
import 'package:mime/mime.dart';

class ComplaintsRemoteDataSource {
  final ApiConsumer api;

  ComplaintsRemoteDataSource({required this.api});
  Future<ComplaintModel> getTemplate(TemplateParams params) async {
    try {
      final response = await api.get("${EndPoints.template}/${params.id}");

      if (response == null) {
        throw ServerException(
          ErrorModel(
            status: 500,
            errorMessage: 'Failed to get template: response is null',
          ),
        );
      }

      try {
        return ComplaintModel.fromJson(response as Map<String, dynamic>);
      } catch (e) {
        throw ServerException(
          ErrorModel(
            status: 500,
            errorMessage: 'Failed to parse template response: ${e.toString()}',
          ),
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        ErrorModel(
          status: 500,
          errorMessage: 'Unexpected error getting template: ${e.toString()}',
        ),
      );
    }
  }

  Future<ComplaintModel> addComplaint(AddComplaintParams complaint) async {
    try {
      final formData = FormData();

      // Send data as multipart part with application/json content type (required by @RequestPart)
      String jsonData;
      try {
        jsonData = jsonEncode({
          'complaintType': complaint.complaintType,
          'governorate': complaint.governorate,
          'governmentAgency': complaint.governmentAgency,
          'location': complaint.location,
          'description': complaint.description,
          'solutionSuggestion': complaint.solutionSuggestion,
        });
      } catch (e) {
        throw ServerException(
          ErrorModel(
            status: 400,
            errorMessage: 'Failed to encode complaint data: ${e.toString()}',
          ),
        );
      }

      try {
        formData.files.add(
          MapEntry(
            'data',
            MultipartFile.fromString(
              jsonData,
              filename: 'data.json',
              contentType: MediaType('application', 'json'),
            ),
          ),
        );
      } catch (e) {
        throw ServerException(
          ErrorModel(
            status: 400,
            errorMessage: 'Failed to create form data: ${e.toString()}',
          ),
        );
      }

      if (complaint.attachments.isNotEmpty) {
        for (var file in complaint.attachments) {
          if (file.path != null) {
            try {
              // Detect MIME type from file extension
              final mimeType = lookupMimeType(file.path!);
              MediaType? contentType;
              if (mimeType != null) {
                final parts = mimeType.split('/');
                if (parts.length == 2) {
                  contentType = MediaType(parts[0], parts[1]);
                }
              }
              // Default to image/png if MIME type cannot be determined
              contentType ??= MediaType('image', 'png');

              try {
                formData.files.add(
                  MapEntry(
                    'files',
                    await MultipartFile.fromFile(
                      file.path!,
                      filename: file.path!.split('/').last.split('\\').last,
                      contentType: contentType,
                    ),
                  ),
                );
              } catch (e) {
                throw ServerException(
                  ErrorModel(
                    status: 400,
                    errorMessage:
                        'Failed to read file ${file.name}: ${e.toString()}',
                  ),
                );
              }
            } catch (e) {
              if (e is ServerException) rethrow;
              throw ServerException(
                ErrorModel(
                  status: 400,
                  errorMessage:
                      'Failed to process file ${file.name}: ${e.toString()}',
                ),
              );
            }
          }
        }
      }

      final response = await api.post(
        EndPoints.complaints,
        data: formData,
        isFormData: true,
      );

      if (response == null) {
        throw ServerException(
          ErrorModel(
            status: 500,
            errorMessage: 'Failed to add complaint: response is null',
          ),
        );
      }

      try {
        return ComplaintModel.fromJson(response as Map<String, dynamic>);
      } catch (e) {
        throw ServerException(
          ErrorModel(
            status: 500,
            errorMessage: 'Failed to parse complaint response: ${e.toString()}',
          ),
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        ErrorModel(
          status: 500,
          errorMessage: 'Unexpected error adding complaint: ${e.toString()}',
        ),
      );
    }
  }

  Future<ComplaintsPageModel> getAllComplaints({
    int page = 0,
    int size = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'size': size};

      final response = await api.get(
        EndPoints.complaints,
        queryParameters: queryParams,
      );

      if (response == null) {
        throw ServerException(
          ErrorModel(
            status: 500,
            errorMessage: 'Failed to get complaints: response is null',
          ),
        );
      }

      try {
        return ComplaintsPageModel.fromJson(response as Map<String, dynamic>);
      } catch (e) {
        throw ServerException(
          ErrorModel(
            status: 500,
            errorMessage:
                'Failed to parse complaints response: ${e.toString()}',
          ),
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        ErrorModel(
          status: 500,
          errorMessage: 'Unexpected error getting complaints: ${e.toString()}',
        ),
      );
    }
  }

  Future<ComplaintsPageModel> filterComplaints({
    int page = 0,
    int size = 10,
    String? status,
    String? type,
    String? governorate,
    String? governmentAgency,
    int? citizenId,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'size': size};

      // Add optional filters
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (type != null && type.isNotEmpty) {
        queryParams['type'] = type;
      }
      if (governorate != null && governorate.isNotEmpty) {
        queryParams['governorate'] = governorate;
      }
      if (governmentAgency != null && governmentAgency.isNotEmpty) {
        queryParams['governmentAgency'] = governmentAgency;
      }
      if (citizenId != null) {
        queryParams['citizenId'] = citizenId;
      }

      final response = await api.get(
        EndPoints.complaintsFilter,
        queryParameters: queryParams,
      );

      if (response == null) {
        throw ServerException(
          ErrorModel(
            status: 500,
            errorMessage: 'Failed to filter complaints: response is null',
          ),
        );
      }

      try {
        return ComplaintsPageModel.fromJson(response as Map<String, dynamic>);
      } catch (e) {
        throw ServerException(
          ErrorModel(
            status: 500,
            errorMessage:
                'Failed to parse filtered complaints response: ${e.toString()}',
          ),
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        ErrorModel(
          status: 500,
          errorMessage:
              'Unexpected error filtering complaints: ${e.toString()}',
        ),
      );
    }
  }

  Future<ComplaintModel> respondToInfoRequest(
    RespondToInfoRequestParams params,
  ) async {
    try {
      final formData = FormData();

      // Send data as multipart part with application/json content type
      String jsonData;
      try {
        jsonData = jsonEncode({'responseMessage': params.responseMessage});
      } catch (e) {
        throw ServerException(
          ErrorModel(
            status: 400,
            errorMessage: 'Failed to encode response data: ${e.toString()}',
          ),
        );
      }

      try {
        formData.files.add(
          MapEntry(
            'data',
            MultipartFile.fromString(
              jsonData,
              filename: 'data.json',
              contentType: MediaType('application', 'json'),
            ),
          ),
        );
      } catch (e) {
        throw ServerException(
          ErrorModel(
            status: 400,
            errorMessage: 'Failed to create form data: ${e.toString()}',
          ),
        );
      }

      if (params.files.isNotEmpty) {
        for (var file in params.files) {
          if (file.path != null) {
            try {
              // Detect MIME type from file extension
              final mimeType = lookupMimeType(file.path!);
              MediaType? contentType;
              if (mimeType != null) {
                final parts = mimeType.split('/');
                if (parts.length == 2) {
                  contentType = MediaType(parts[0], parts[1]);
                }
              }
              // Default to image/png if MIME type cannot be determined
              contentType ??= MediaType('image', 'png');

              try {
                formData.files.add(
                  MapEntry(
                    'files',
                    await MultipartFile.fromFile(
                      file.path!,
                      filename: file.path!.split('/').last.split('\\').last,
                      contentType: contentType,
                    ),
                  ),
                );
              } catch (e) {
                throw ServerException(
                  ErrorModel(
                    status: 400,
                    errorMessage:
                        'Failed to read file ${file.name}: ${e.toString()}',
                  ),
                );
              }
            } catch (e) {
              if (e is ServerException) rethrow;
              throw ServerException(
                ErrorModel(
                  status: 400,
                  errorMessage:
                      'Failed to process file ${file.name}: ${e.toString()}',
                ),
              );
            }
          }
        }
      }

      final response = await api.put(
        '${EndPoints.infoRequests}/${params.infoRequestId}/respond',
        data: formData,
        isFormData: true,
      );

      if (response == null) {
        throw ServerException(
          ErrorModel(
            status: 500,
            errorMessage: 'Failed to respond to info request: response is null',
          ),
        );
      }

      try {
        return ComplaintModel.fromJson(response as Map<String, dynamic>);
      } catch (e) {
        throw ServerException(
          ErrorModel(
            status: 500,
            errorMessage:
                'Failed to parse info request response: ${e.toString()}',
          ),
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        ErrorModel(
          status: 500,
          errorMessage:
              'Unexpected error responding to info request: ${e.toString()}',
        ),
      );
    }
  }

  /// Fetch info requests for a specific complaint
  /// GET /api/v1/complaints/{complaintId}/info-requests?page=0&size=10
  Future<InfoRequestPageModel> getInfoRequestsForComplaint({
    required int complaintId,
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await api.get(
        '${EndPoints.complaints}/$complaintId/info-requests',
        queryParameters: {'page': page, 'size': size},
      );

      if (response == null) {
        throw ServerException(
          ErrorModel(
            status: 500,
            errorMessage: 'Failed to get info requests: response is null',
          ),
        );
      }

      try {
        return InfoRequestPageModel.fromJson(response as Map<String, dynamic>);
      } catch (e) {
        throw ServerException(
          ErrorModel(
            status: 500,
            errorMessage:
                'Failed to parse info requests response: ${e.toString()}',
          ),
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        ErrorModel(
          status: 500,
          errorMessage:
              'Unexpected error getting info requests: ${e.toString()}',
        ),
      );
    }
  }
}
