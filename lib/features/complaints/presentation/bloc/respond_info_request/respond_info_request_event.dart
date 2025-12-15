part of 'respond_info_request_bloc.dart';

abstract class RespondInfoRequestEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendInfoRequestResponseEvent extends RespondInfoRequestEvent {
  final RespondToInfoRequestParams params;

  SendInfoRequestResponseEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class FetchInfoRequestEvent extends RespondInfoRequestEvent {
  final int complaintId;
  final int infoRequestId;

  FetchInfoRequestEvent({
    required this.complaintId,
    required this.infoRequestId,
  });

  @override
  List<Object?> get props => [complaintId, infoRequestId];
}
