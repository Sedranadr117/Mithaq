import 'package:complaint_app/features/complaints/domain/entities/comlaints_list_entity.dart';

class ComplaintsPageEntity {
  final List<ComplaintListEntity> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const ComplaintsPageEntity({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });
}
