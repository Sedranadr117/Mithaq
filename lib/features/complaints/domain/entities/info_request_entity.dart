class InfoRequestEntity {
  final int id;
  final int complaintId;
  final RequestedByEntity requestedBy;
  final String requestMessage;
  final String status;
  final String requestedAt;
  final String? respondedAt;
  final String? responseMessage;
  final List<AttachmentEntity> attachments;

  const InfoRequestEntity({
    required this.id,
    required this.complaintId,
    required this.requestedBy,
    required this.requestMessage,
    required this.status,
    required this.requestedAt,
    this.respondedAt,
    this.responseMessage,
    required this.attachments,
  });
}

class RequestedByEntity {
  final int id;
  final String name;
  final String email;

  const RequestedByEntity({
    required this.id,
    required this.name,
    required this.email,
  });
}

class AttachmentEntity {
  final int id;
  final String originalFilename;
  final int size;
  final String contentType;
  final String downloadUrl;
  final String uploadedAt;

  const AttachmentEntity({
    required this.id,
    required this.originalFilename,
    required this.size,
    required this.contentType,
    required this.downloadUrl,
    required this.uploadedAt,
  });
}

class InfoRequestPageEntity {
  final List<InfoRequestEntity> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const InfoRequestPageEntity({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });
}
