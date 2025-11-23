import 'package:complaint_app/features/complaints/data/models/comlaints_list_model.dart';
import 'package:complaint_app/features/complaints/data/models/complaints_model.dart';
import 'package:complaint_app/features/complaints/domain/entities/complaints_pageination_entity.dart';

class ComplaintsPageModel extends ComplaintsPageEntity {
  const ComplaintsPageModel({
    required super.content,
    required super.page,
    required super.size,
    required super.totalElements,
    required super.totalPages,
    required super.hasNext,
    required super.hasPrevious,
  });

  factory ComplaintsPageModel.fromJson(Map<String, dynamic> json) {
    final complaints = (json['content'] as List)
        .map((e) => ComplaintListModel.fromJson(e))
        .toList();

    return ComplaintsPageModel(
      content: complaints,
      page: json['page'],
      size: json['size'],
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
      hasNext: json['hasNext'],
      hasPrevious: json['hasPrevious'],
    );
  }
}
