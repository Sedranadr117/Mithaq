import 'package:complaint_app/features/complaints/domain/entities/complaints_entity.dart';

class AttachmentModel extends AttachmentEntity {
  AttachmentModel({
    required super.id,
    required super.originalFilename,
    required super.size,
    required super.contentType,
    required super.downloadUrl,
    required super.uploadedAt,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'],
      originalFilename: json['originalFilename'],
      size: json['size'],
      contentType: json['contentType'],
      downloadUrl: json['downloadUrl'],
      uploadedAt: List<int>.from(json['uploadedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originalFilename': originalFilename,
      'size': size,
      'contentType': contentType,
      'downloadUrl': downloadUrl,
      'uploadedAt': uploadedAt,
    };
  }
}

class ComplaintModel extends ComplaintEntity {
  ComplaintModel({
    required super.id,
    required super.complaintType,
    required super.governorate,
    required super.governmentAgency,
    required super.location,
    required super.description,
    required super.solutionSuggestion,
    required super.status,
    super.response,
    super.respondedAt,
    super.respondedById,
    super.respondedByName,
    required super.attachments,
    required super.citizenId,
    required super.citizenName,
    required super.createdAt,
    required super.updatedAt,
    required super.trackingNumber,
    required super.version,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'],
      complaintType: json['complaintType'],
      governorate: json['governorate'],
      governmentAgency: json['governmentAgency'],
      location: json['location'],
      description: json['description'],
      solutionSuggestion: json['solutionSuggestion'],
      status: json['status'],
      response: json['response'],
      respondedAt: json['respondedAt'],
      respondedById: json['respondedById'],
      respondedByName: json['respondedByName'],
      attachments: (json['attachments'] as List)
          .map((e) => AttachmentModel.fromJson(e))
          .toList(),
      citizenId: json['citizenId'],
      citizenName: json['citizenName'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      trackingNumber: json['trackingNumber'],
      version: json['version'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'complaintType': complaintType,
      'governorate': governorate,
      'governmentAgency': governmentAgency,
      'location': location,
      'description': description,
      'solutionSuggestion': solutionSuggestion,
      'status': status,
      'response': response,
      'respondedAt': respondedAt,
      'respondedById': respondedById,
      'respondedByName': respondedByName,
      'attachments': attachments
          .map((e) => (e as AttachmentModel).toJson())
          .toList(),
      'citizenId': citizenId,
      'citizenName': citizenName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'trackingNumber': trackingNumber,
      'version': version,
    };
  }
}
