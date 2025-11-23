import 'dart:convert';

import 'package:complaint_app/features/complaints/data/models/complaints_model.dart';
import 'package:complaint_app/features/complaints/data/models/complaints_pageination_model.dart';
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
    final response = await api.get("${EndPoints.template}/${params.id}");
    return ComplaintModel.fromJson(response);
  }

  Future<ComplaintModel> addComplaint(AddComplaintParams complaint) async {
    final formData = FormData();

    // Send data as multipart part with application/json content type (required by @RequestPart)
    final jsonData = jsonEncode({
      'complaintType': complaint.complaintType,
      'governorate': complaint.governorate,
      'governmentAgency': complaint.governmentAgency,
      'location': complaint.location,
      'description': complaint.description,
      'solutionSuggestion': complaint.solutionSuggestion,
    });

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

    if (complaint.attachments.isNotEmpty) {
      for (var file in complaint.attachments) {
        if (file.path != null) {
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
        }
      }
    }

    final response = await api.post(
      EndPoints.complaints,
      data: formData,
      isFormData: true,
    );

    return ComplaintModel.fromJson(response);
  }

  Future<ComplaintsPageModel> getAllComplaints({
    int page = 0,
    int size = 10,
  }) async {
    final response = await api.get(
      EndPoints.complaints,
      queryParameters: {'page': page, 'size': size},
    );

    return ComplaintsPageModel.fromJson(response);
  }
}
