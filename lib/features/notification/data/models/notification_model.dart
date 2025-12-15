import 'package:complaint_app/core/databases/api/end_points.dart';
import 'package:complaint_app/features/notification/domain/entities/notification_entity.dart';

class NotificationPaginatedModel extends NotificationPaginatedEntity {
  NotificationPaginatedModel({
    required super.size,
    required super.page,
    required super.content,
    required super.totalElements,
    required super.totalPages,
    required super.hasNext,
    required super.hasPrevious,
  });

  factory NotificationPaginatedModel.fromJson(Map<String, dynamic> json) {
    final notificationsList =
        json['body'] as List<dynamic>? ??
        json[ApiKeys.content] as List<dynamic>? ??
        [];

    // API returns "pageable" object instead of flat pagination fields
    final pageable = json['pageable'] as Map<String, dynamic>?;
    final page = pageable?['page'] as int? ?? json[ApiKeys.page] as int? ?? 0;
    final size =
        pageable?['perPage'] as int? ?? json[ApiKeys.size] as int? ?? 10;
    final total =
        pageable?['total'] as int? ?? json[ApiKeys.totalElements] as int? ?? 0;

    // Calculate totalPages and hasNext
    final totalPages = size > 0 ? (total / size).ceil() : 0;
    final hasNext = page < totalPages - 1;
    final hasPrevious = page > 0;

    return NotificationPaginatedModel(
      content: notificationsList
          .map(
            (item) => NotificationModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      page: page,
      size: size,
      totalElements: total,
      totalPages: totalPages,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }
}

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.notificationType,
    required super.sentAt,
    required super.readAt,
    required super.status,
    super.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // Parse createdAt array to ISO string - use createdAt as the time for sending
    String? sentAtString;

    // First try sentAt if available (could be String or List)
    final sentAtValue = json[ApiKeys.sentAt];
    if (sentAtValue != null) {
      if (sentAtValue is String) {
        sentAtString = sentAtValue;
      } else if (sentAtValue is List) {
        // Handle sentAt as array (similar to createdAt)
        try {
          final sentAtList = sentAtValue;
          if (sentAtList.length >= 6) {
            final nanoseconds = sentAtList.length > 6
                ? sentAtList[6] as int? ?? 0
                : 0;
            final milliseconds = nanoseconds ~/ 1000000;
            final date = DateTime(
              sentAtList[0] as int,
              sentAtList[1] as int,
              sentAtList[2] as int,
              sentAtList[3] as int,
              sentAtList[4] as int,
              sentAtList[5] as int,
              milliseconds,
            );
            sentAtString = date.toIso8601String();
          }
        } catch (e) {
          sentAtString = null;
        }
      }
    }
    // Always use createdAt as fallback (this is when the notification was created)
    if (sentAtString == null && json['createdAt'] != null) {
      // Handle createdAt array [2025,12,14,9,48,45,864806000]
      // Format: [year, month, day, hour, minute, second, nanoseconds]
      final createdAt = json['createdAt'] as List<dynamic>?;
      if (createdAt != null && createdAt.length >= 6) {
        try {
          // Convert nanoseconds to milliseconds (divide by 1000000)
          final nanoseconds = createdAt.length > 6
              ? createdAt[6] as int? ?? 0
              : 0;
          final milliseconds = nanoseconds ~/ 1000000;

          final date = DateTime(
            createdAt[0] as int, // year
            createdAt[1] as int, // month
            createdAt[2] as int, // day
            createdAt[3] as int, // hour
            createdAt[4] as int, // minute
            createdAt[5] as int, // second
            milliseconds, // millisecond
          );
          sentAtString = date.toIso8601String();
        } catch (e) {
          // If parsing fails, try without milliseconds
          try {
            final date = DateTime(
              createdAt[0] as int,
              createdAt[1] as int,
              createdAt[2] as int,
              createdAt[3] as int,
              createdAt[4] as int,
              createdAt[5] as int,
            );
            sentAtString = date.toIso8601String();
          } catch (e2) {
            sentAtString = null;
          }
        }
      }
    }

    // Parse readAt (could be String, List, or null)
    String? readAtString;
    final readAtValue = json[ApiKeys.readAt];
    if (readAtValue != null) {
      if (readAtValue is String) {
        readAtString = readAtValue;
      } else if (readAtValue is List) {
        // Handle readAt as array
        try {
          final readAtList = readAtValue;
          if (readAtList.length >= 6) {
            final nanoseconds = readAtList.length > 6
                ? readAtList[6] as int? ?? 0
                : 0;
            final milliseconds = nanoseconds ~/ 1000000;
            final date = DateTime(
              readAtList[0] as int,
              readAtList[1] as int,
              readAtList[2] as int,
              readAtList[3] as int,
              readAtList[4] as int,
              readAtList[5] as int,
              milliseconds,
            );
            readAtString = date.toIso8601String();
          }
        } catch (e) {
          readAtString = null;
        }
      }
    }

    return NotificationModel(
      id: json[ApiKeys.id] as int? ?? 0,
      title: json[ApiKeys.title] as String? ?? '',
      body: json[ApiKeys.body] as String? ?? '',
      notificationType: json[ApiKeys.notificationType] as String? ?? 'general',
      sentAt: sentAtString,
      readAt: readAtString,
      status: json[ApiKeys.status] as String? ?? 'SENT',
      data: json['data'] as String?,
    );
  }
}
