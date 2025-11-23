class AttachmentEntity {
  final int id;
  final String originalFilename;
  final int size;
  final String contentType;
  final String downloadUrl;
  final List<int> uploadedAt;

  AttachmentEntity({
    required this.id,
    required this.originalFilename,
    required this.size,
    required this.contentType,
    required this.downloadUrl,
    required this.uploadedAt,
  });
}

class ComplaintEntity {
  final int id;
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
  final String citizenName;
  final String createdAt;
  final String updatedAt;
  final String trackingNumber;
  final int version;

  ComplaintEntity({
    required this.id,
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
    required this.citizenName,
    required this.createdAt,
    required this.updatedAt,
    required this.trackingNumber,
    required this.version,
  });
}
