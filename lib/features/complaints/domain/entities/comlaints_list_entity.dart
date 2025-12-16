import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ComplaintListEntity {
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
  final List<String> attachments;
  final int citizenId;
  final String citizenName;
  final String? createdAt;
  final String? updatedAt;
  final String? trackingNumber;
  final int? version;

  const ComplaintListEntity({
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
    this.createdAt,
    this.updatedAt,
    this.trackingNumber,
    this.version,
  });

  String get statusText {
    switch (status) {
      case "PENDING":
        return "جديدة";
      case "IN PROGRESS":
        return "قيد المعالجة";
      case "CLOSED":
        return "منجزة";
      case "REJECTED":
        return "مرفوضة";
      case "INFO REQUESTED":
        return "طلب معلومات";
      case "RESOLVED":
        return "تم الحل";
      default:
        return "غير معروف";
    }
  }

  Color statusColor(BuildContext context) {
    switch (status) {
      case "PENDING":
        return const Color(0xFF3B7C88);
      case "IN PROGRESS":
        return const Color(0xFFE6A43B);
      case "CLOSED":
        return const Color(0xFF1FAC82);
      case "REJECTED":
        return const Color(0xFFD75454);
      case "INFO REQUESTED":
        return const Color(0xFF5A6FAF);
      case "RESOLVED":
        return const Color(0xFF1FAC82);
      default:
        return Colors.grey;
    }
  }
}
