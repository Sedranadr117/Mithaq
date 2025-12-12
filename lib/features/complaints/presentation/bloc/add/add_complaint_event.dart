part of 'add_complaint_bloc.dart';

abstract class AddComplaintEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendComplaintEvent extends AddComplaintEvent {
  final AddComplaintParams params;

  SendComplaintEvent(this.params);

  @override
  List<Object?> get props => [params];
}
