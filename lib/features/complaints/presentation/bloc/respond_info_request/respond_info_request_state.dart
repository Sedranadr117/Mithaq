part of 'respond_info_request_bloc.dart';

abstract class RespondInfoRequestState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RespondInfoRequestInitial extends RespondInfoRequestState {}

class RespondInfoRequestLoading extends RespondInfoRequestState {}

class FetchingInfoRequest extends RespondInfoRequestState {}

class InfoRequestLoaded extends RespondInfoRequestState {
  final InfoRequestPageEntity infoRequest;
  final InfoRequestEntity? selectedRequest;

  InfoRequestLoaded({required this.infoRequest, this.selectedRequest});

  @override
  List<Object?> get props => [infoRequest, selectedRequest];
}

class RespondInfoRequestSuccess extends RespondInfoRequestState {
  final ComplaintEntity complaint;
  final InfoRequestPageEntity infoRequest;
  RespondInfoRequestSuccess({
    required this.complaint,
    required this.infoRequest,
  });

  @override
  List<Object?> get props => [complaint];
}

class RespondInfoRequestError extends RespondInfoRequestState {
  final String message;

  RespondInfoRequestError({required this.message});

  @override
  List<Object?> get props => [message];
}
