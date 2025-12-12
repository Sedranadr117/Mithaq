import 'package:complaint_app/features/complaints/domain/entities/comlaints_list_entity.dart';
import 'package:complaint_app/features/complaints/domain/entities/complaints_pageination_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ComplaintsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ComplaintInitial extends ComplaintsState {}

class ComplaintLoading extends ComplaintsState {}

class ComplaintSuccess extends ComplaintsState {
  final ComplaintsPageEntity complaint;
  final List<ComplaintListEntity> allComplaints;

  ComplaintSuccess({required this.allComplaints, required this.complaint});

  @override
  List<Object?> get props => [complaint, allComplaints];
}

class ComplaintError extends ComplaintsState {
  final String message;

  ComplaintError({required this.message});

  @override
  List<Object?> get props => [message];
}
