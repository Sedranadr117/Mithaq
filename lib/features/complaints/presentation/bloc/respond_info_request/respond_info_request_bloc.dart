import 'package:flutter/foundation.dart';
import 'package:complaint_app/features/complaints/domain/entities/info_request_entity.dart';
import 'package:complaint_app/features/complaints/domain/usecases/get_info_requests_for_complaint.dart';
import 'package:complaint_app/features/complaints/domain/usecases/respond_to_info_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/complaints_entity.dart';
import '../../../../../../core/params/params.dart';

part 'respond_info_request_event.dart';
part 'respond_info_request_state.dart';

class RespondInfoRequestBloc
    extends Bloc<RespondInfoRequestEvent, RespondInfoRequestState> {
  final RespondToInfoRequest respondToInfoRequestUseCase;
  final GetInfoRequestsForComplaint getInfoRequestsForComplaintUseCase;

  RespondInfoRequestBloc({
    required this.respondToInfoRequestUseCase,
    required this.getInfoRequestsForComplaintUseCase,
  }) : super(RespondInfoRequestInitial()) {
    on<FetchInfoRequestEvent>(_onFetchInfoRequest);
    on<SendInfoRequestResponseEvent>((event, emit) async {
      try {
        emit(RespondInfoRequestLoading());

        final result = await respondToInfoRequestUseCase(params: event.params);

        result.fold(
          (failure) {
            emit(RespondInfoRequestError(message: failure.errMessage));
          },
          (data) => emit(
            RespondInfoRequestSuccess(
              complaint: data,
              infoRequest: InfoRequestPageEntity(
                content: [],
                page: 0,
                size: 0,
                totalElements: 0,
                totalPages: 0,
                hasNext: false,
                hasPrevious: false,
              ),
            ),
          ),
        );
      } catch (e) {
        emit(
          RespondInfoRequestError(
            message: 'Unexpected error occurred: ${e.toString()}',
          ),
        );
      }
    });
  }

  void _onFetchInfoRequest(
    FetchInfoRequestEvent event,
    Emitter<RespondInfoRequestState> emit,
  ) async {
    emit(FetchingInfoRequest());
    try {
      final result = await getInfoRequestsForComplaintUseCase(
        complaintId: event.complaintId,
        page: 0,
        size: 100, // Get enough to find the specific request
      );

      result.fold(
        (failure) {
          emit(RespondInfoRequestError(message: failure.errMessage));
        },
        (infoRequestPage) {
          debugPrint(
            '📋 Fetched ${infoRequestPage.content.length} info requests for complaint ${event.complaintId}',
          );
          debugPrint('🔍 Looking for info request ID: ${event.infoRequestId}');
          debugPrint(
            '📋 Available IDs: ${infoRequestPage.content.map((r) => r.id).toList()}',
          );

          // Find the specific info request by ID
          InfoRequestEntity? selectedRequest;
          try {
            selectedRequest = infoRequestPage.content.firstWhere(
              (req) => req.id == event.infoRequestId,
            );
            debugPrint(
              '✅ Found info request: ${selectedRequest.requestMessage}',
            );
          } catch (e) {
            // If not found, use the first one if available
            if (infoRequestPage.content.isNotEmpty) {
              selectedRequest = infoRequestPage.content.first;
              debugPrint(
                '⚠️ Info request ${event.infoRequestId} not found, using first: ${selectedRequest.id}',
              );
            } else {
              debugPrint('❌ No info requests found');
              emit(
                RespondInfoRequestError(
                  message: 'لم يتم العثور على طلب المعلومات',
                ),
              );
              return;
            }
          }

          emit(
            InfoRequestLoaded(
              infoRequest: infoRequestPage,
              selectedRequest: selectedRequest,
            ),
          );
          debugPrint('✅ Emitted InfoRequestLoaded state');
        },
      );
    } catch (e) {
      emit(
        RespondInfoRequestError(
          message: 'Failed to fetch info request: ${e.toString()}',
        ),
      );
    }
  }
}
