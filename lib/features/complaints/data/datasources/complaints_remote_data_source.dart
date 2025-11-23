import 'dart:convert';

import 'package:complaint_app/features/complaints/data/models/complaints_model.dart';
import 'package:complaint_app/features/complaints/data/models/complaints_pageination_model.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
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

    formData.fields.add(
      MapEntry(
        'data',
        jsonEncode({
          'complaintType': complaint.complaintType,
          'governorate': complaint.governorate,
          'governmentAgency': complaint.governmentAgency,
          'location': complaint.location,
          'description': complaint.description,
          'solutionSuggestion': complaint.solutionSuggestion,
        }),
      ),
    );

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
