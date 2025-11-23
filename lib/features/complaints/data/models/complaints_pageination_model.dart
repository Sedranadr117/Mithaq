import 'package:complaint_app/features/complaints/data/models/comlaints_list_model.dart';
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
    final complaints =
        (json['content'] as List?)
            ?.map((e) => ComplaintListModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return ComplaintsPageModel(
      content: complaints,
      page: json['page'] ?? 0,
      size: json['size'] ?? 10,
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNext: json['hasNext'] ?? false,
      hasPrevious: json['hasPrevious'] ?? false,
    );
  }
}
