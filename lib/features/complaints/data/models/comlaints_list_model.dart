import 'package:complaint_app/features/complaints/domain/entities/comlaints_list_entity.dart';

class ComplaintListModel extends ComplaintListEntity {
  ComplaintListModel({
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
    super.createdAt,
    super.updatedAt,
    super.trackingNumber,
    super.version,
  });

  factory ComplaintListModel.fromJson(Map<String, dynamic> json) {
    try {
      // Safely parse attachments
      List<String> parseAttachments(dynamic attachmentsData) {
        if (attachmentsData == null) return [];
        if (attachmentsData is! List) return [];

        final List<String> result = [];
        for (var item in attachmentsData) {
          try {
            if (item is String) {
              result.add(item);
            } else if (item is Map) {
              final mapItem = Map<String, dynamic>.from(item);
              final url =
                  mapItem['downloadUrl'] as String? ??
                  mapItem['url'] as String?;
              if (url != null && url.isNotEmpty) {
                result.add(url);
              }
            }
          } catch (e) {
            // Skip invalid attachment items
            continue;
          }
        }
        return result;
      }

      return ComplaintListModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        complaintType: json['complaintType'] as String? ?? '',
        governorate: json['governorate'] as String? ?? '',
        governmentAgency: json['governmentAgency'] as String? ?? '',
        location: json['location'] as String? ?? '',
        description: json['description'] as String? ?? '',
        solutionSuggestion: json['solutionSuggestion'] as String? ?? '',
        status: json['status'] as String? ?? 'PENDING',
        response: json['response'] as String?,
        respondedAt: json['respondedAt'] as String?,
        respondedById: (json['respondedById'] as num?)?.toInt(),
        respondedByName: json['respondedByName'] as String?,
        attachments: parseAttachments(json['attachments']),
        citizenId: (json['citizenId'] as num?)?.toInt() ?? 0,
        citizenName: json['citizenName'] as String? ?? '',
        createdAt: json['createdAt'] as String?,
        updatedAt: json['updatedAt'] as String?,
        trackingNumber: json['trackingNumber'] as String?,
        version: (json['version'] as num?)?.toInt(),
      );
    } catch (e) {
      // Return a default model with safe values if parsing fails
      return ComplaintListModel(
        id: 0,
        complaintType: '',
        governorate: '',
        governmentAgency: '',
        location: '',
        description: '',
        solutionSuggestion: '',
        status: 'PENDING',
        response: null,
        respondedAt: null,
        respondedById: null,
        respondedByName: null,
        attachments: [],
        citizenId: 0,
        citizenName: '',
        createdAt: null,
        updatedAt: null,
        trackingNumber: null,
        version: null,
      );
    }
  }
}
