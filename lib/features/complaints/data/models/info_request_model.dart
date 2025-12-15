import 'package:complaint_app/features/complaints/domain/entities/info_request_entity.dart';

class InfoRequestModel extends InfoRequestEntity {
  const InfoRequestModel({
    required super.id,
    required super.complaintId,
    required super.requestedBy,
    required super.requestMessage,
    required super.status,
    required super.requestedAt,
    super.respondedAt,
    super.responseMessage,
    required super.attachments,
  });

  factory InfoRequestModel.fromJson(Map<String, dynamic> json) {
    // Parse requestedAt - can be String or List (array format)
    String requestedAtString = '';
    final requestedAtValue = json['requestedAt'];
    if (requestedAtValue != null) {
      if (requestedAtValue is String) {
        requestedAtString = requestedAtValue;
      } else if (requestedAtValue is List) {
        // Handle requestedAt as array [2025, 12, 14, 11, 3, 0, 0]
        try {
          final requestedAtList = requestedAtValue;
          if (requestedAtList.length >= 6) {
            final nanoseconds = requestedAtList.length > 6
                ? requestedAtList[6] as int? ?? 0
                : 0;
            final milliseconds = nanoseconds ~/ 1000000;
            final date = DateTime(
              requestedAtList[0] as int,
              requestedAtList[1] as int,
              requestedAtList[2] as int,
              requestedAtList[3] as int,
              requestedAtList[4] as int,
              requestedAtList[5] as int,
              milliseconds,
            );
            requestedAtString = date.toIso8601String();
          }
        } catch (e) {
          requestedAtString = '';
        }
      }
    }

    // Parse respondedAt - can be String, List, or null
    String? respondedAtString;
    final respondedAtValue = json['respondedAt'];
    if (respondedAtValue != null) {
      if (respondedAtValue is String) {
        respondedAtString = respondedAtValue;
      } else if (respondedAtValue is List) {
        // Handle respondedAt as array
        try {
          final respondedAtList = respondedAtValue;
          if (respondedAtList.length >= 6) {
            final nanoseconds = respondedAtList.length > 6
                ? respondedAtList[6] as int? ?? 0
                : 0;
            final milliseconds = nanoseconds ~/ 1000000;
            final date = DateTime(
              respondedAtList[0] as int,
              respondedAtList[1] as int,
              respondedAtList[2] as int,
              respondedAtList[3] as int,
              respondedAtList[4] as int,
              respondedAtList[5] as int,
              milliseconds,
            );
            respondedAtString = date.toIso8601String();
          }
        } catch (e) {
          respondedAtString = null;
        }
      }
    }

    return InfoRequestModel(
      id: json['id'] as int,
      complaintId: json['complaintId'] as int,
      requestedBy: RequestedByModel.fromJson(
        json['requestedBy'] as Map<String, dynamic>,
      ),
      requestMessage: json['requestMessage'] as String? ?? '',
      status: json['status'] as String? ?? 'PENDING',
      requestedAt: requestedAtString,
      respondedAt: respondedAtString,
      responseMessage: json['responseMessage'] as String?,
      attachments: (json['attachments'] as List<dynamic>? ?? [])
          .map((item) => AttachmentModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RequestedByModel extends RequestedByEntity {
  const RequestedByModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory RequestedByModel.fromJson(Map<String, dynamic> json) {
    return RequestedByModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }
}

class AttachmentModel extends AttachmentEntity {
  const AttachmentModel({
    required super.id,
    required super.originalFilename,
    required super.size,
    required super.contentType,
    required super.downloadUrl,
    required super.uploadedAt,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    // Parse uploadedAt - can be String or List (array format)
    String uploadedAtString = '';
    final uploadedAtValue = json['uploadedAt'];
    if (uploadedAtValue != null) {
      if (uploadedAtValue is String) {
        uploadedAtString = uploadedAtValue;
      } else if (uploadedAtValue is List) {
        // Handle uploadedAt as array [2025, 12, 14, 11, 14, 1, 460355000]
        try {
          final uploadedAtList = uploadedAtValue;
          if (uploadedAtList.length >= 6) {
            final nanoseconds = uploadedAtList.length > 6
                ? uploadedAtList[6] as int? ?? 0
                : 0;
            final milliseconds = nanoseconds ~/ 1000000;
            final date = DateTime(
              uploadedAtList[0] as int,
              uploadedAtList[1] as int,
              uploadedAtList[2] as int,
              uploadedAtList[3] as int,
              uploadedAtList[4] as int,
              uploadedAtList[5] as int,
              milliseconds,
            );
            uploadedAtString = date.toIso8601String();
          }
        } catch (e) {
          uploadedAtString = '';
        }
      }
    }

    return AttachmentModel(
      id: json['id'] as int,
      originalFilename: json['originalFilename'] as String? ?? '',
      size: json['size'] as int? ?? 0,
      contentType: json['contentType'] as String? ?? '',
      downloadUrl: json['downloadUrl'] as String? ?? '',
      uploadedAt: uploadedAtString,
    );
  }
}

class InfoRequestPageModel extends InfoRequestPageEntity {
  const InfoRequestPageModel({
    required super.content,
    required super.page,
    required super.size,
    required super.totalElements,
    required super.totalPages,
    required super.hasNext,
    required super.hasPrevious,
  });

  factory InfoRequestPageModel.fromJson(Map<String, dynamic> json) {
    final contentList = json['content'] as List<dynamic>? ?? [];

    return InfoRequestPageModel(
      content: contentList
          .map(
            (item) => InfoRequestModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      page: json['page'] as int? ?? 0,
      size: json['size'] as int? ?? 10,
      totalElements: json['totalElements'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
      hasPrevious: json['hasPrevious'] as bool? ?? false,
    );
  }
}
