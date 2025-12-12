part of 'add_complaint_bloc.dart';

abstract class AddComplaintState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddComplaintInitial extends AddComplaintState {}

class AddComplaintLoading extends AddComplaintState {}

class AddComplaintSuccess extends AddComplaintState {
  final ComplaintEntity complaint;

  AddComplaintSuccess({required this.complaint});

  @override
  List<Object?> get props => [complaint];
}

class AddComplaintError extends AddComplaintState {
  final String message;

  AddComplaintError({required this.message});

  @override
  List<Object?> get props => [message];
}
