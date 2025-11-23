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
  });

  String get statusText {
    switch (status) {
      case "PENDING":
        return "جديدة";
      case "IN_PROGRESS":
        return "قيد المعالجة";
      case "CLOSED":
        return "منجزة";
      case "REJECTED":
        return "مرفوضة";
      default:
        return "غير معروف";
    }
  }

  Color statusColor(BuildContext context) {
    switch (status) {
      case "PENDING":
        return const Color(0xFF3B7C88);
      case "IN_PROGRESS":
        return const Color(0xFFE6A43B);
      case "CLOSED":
        return const Color(0xFF1FAC82);
      case "REJECTED":
        return const Color(0xFFD75454);
      default:
        return Colors.grey;
    }
  }
}