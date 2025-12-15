import 'package:complaint_app/features/complaints/data/models/info_request_model.dart';
import 'package:complaint_app/features/complaints/domain/entities/complaints_entity.dart';
import 'package:complaint_app/features/complaints/domain/entities/info_request_entity.dart';

class ComplaintModel extends ComplaintEntity {
  const ComplaintModel({
    super.id,
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
    required super.citizenId,
    super.citizenName,
    required super.attachments,
    super.createdAt,
    super.updatedAt,
    super.trackingNumber,
    super.version,
  });

  /// fromJson
  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    // Handle different attachment formats from the API
    List<AttachmentEntity> parseAttachments(dynamic attachmentsData) {
      if (attachmentsData == null) return [];

      try {
        // If it's a List (could be List<dynamic>, List<Map>, etc.)
        if (attachmentsData is List) {
          final List<AttachmentEntity> result = [];
          for (var item in attachmentsData) {
            try {
              if (item is Map) {
                result.add(
                  AttachmentModel.fromJson(Map<String, dynamic>.from(item)),
                );
              } else if (item is String && item.isNotEmpty) {
                result.add(
                  AttachmentModel(
                    id: 0,
                    originalFilename: item.split('/').last,
                    size: 0,
                    contentType: '',
                    downloadUrl: item,
                    uploadedAt: '',
                  ),
                );
              }
            } catch (_) {
              // Skip invalid attachment items
              continue;
            }
          }
          return result;
        }

        // If it's a Map (single attachment or different structure)
        if (attachmentsData is Map) {
          final Map<String, dynamic> mapData = Map<String, dynamic>.from(
            attachmentsData,
          );
          return [AttachmentModel.fromJson(mapData)];
        }
      } catch (e) {
        // If parsing fails, return empty list
        return [];
      }

      return [];
    }

    return ComplaintModel(
      id: (json['id'] as num?)?.toInt(),
      complaintType: json['complaintType'] as String? ?? '',
      governorate: json['governorate'] as String? ?? '',
      governmentAgency: json['governmentAgency'] as String? ?? '',
      location: json['location'] as String? ?? '',
      description: json['description'] as String? ?? '',
      solutionSuggestion: json['solutionSuggestion'] as String? ?? '',
      status: json['status'] as String? ?? 'PENDING',
      response: json['response'] as String?,
      respondedAt: json['respondedAt']?.toString(),
      respondedById: (json['respondedById'] as num?)?.toInt(),
      respondedByName: json['respondedByName'] as String?,
      citizenId: json['citizenId'] as int? ?? 0,
      citizenName: json['citizenName'] as String?,
      attachments: parseAttachments(json['attachments']),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      trackingNumber: json['trackingNumber'] as String?,
      version: (json['version'] as num?)?.toInt(),
    );
  }

  /// toJson
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "complaintType": complaintType,
      "governorate": governorate,
      "governmentAgency": governmentAgency,
      "location": location,
      "description": description,
      "solutionSuggestion": solutionSuggestion,
      "status": status,
      "response": response,
      "respondedAt": respondedAt,
      "respondedById": respondedById,
      "respondedByName": respondedByName,
      "citizenId": citizenId,
      "citizenName": citizenName,
      "attachments": attachments
          .map(
            (attachment) => {
              "id": attachment.id,
              "originalFilename": attachment.originalFilename,
              "size": attachment.size,
              "contentType": attachment.contentType,
              "downloadUrl": attachment.downloadUrl,
              "uploadedAt": attachment.uploadedAt,
            },
          )
          .toList(),
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "trackingNumber": trackingNumber,
      "version": version,
    };
  }
}
