import 'package:complaint_app/features/complaints/domain/entities/info_request_entity.dart';

class ComplaintEntity {
  final int? id;
  final String complaintType;
  final String governorate;
  final String governmentAgency;
  final String location;
  final String description;
  final String solutionSuggestion;
  final String status;
  final String? response;
  final String? respondedAt;
  final int? respondedById;
  final String? respondedByName;
  final List<AttachmentEntity> attachments;
  final int citizenId;
  final String? citizenName;
  final String? createdAt;
  final String? updatedAt;
  final String? trackingNumber;
  final int? version;

  const ComplaintEntity({
    this.id,
    required this.complaintType,
    required this.governorate,
    required this.governmentAgency,
    required this.location,
    required this.description,
    required this.solutionSuggestion,
    required this.status,
    this.response,
    this.respondedAt,
    this.respondedById,
    this.respondedByName,
    required this.attachments,
    required this.citizenId,
    this.citizenName,
    this.createdAt,
    this.updatedAt,
    this.trackingNumber,
    this.version,
  });
}
