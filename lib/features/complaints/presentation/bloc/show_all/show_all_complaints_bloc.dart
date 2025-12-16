// ...existing code...
import 'package:flutter/foundation.dart';
import 'package:complaint_app/features/complaints/domain/entities/comlaints_list_entity.dart';
import 'package:complaint_app/features/complaints/domain/usecases/get_all_complaint.dart';
import 'package:complaint_app/features/complaints/presentation/bloc/show_all/show_all_complaints_event.dart';
import 'package:complaint_app/features/complaints/presentation/bloc/show_all/show_all_complaints_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComplaintsBloc extends Bloc<ComplaintsEvent, ComplaintsState> {
  final GetAllComplaint getAllComplaint;
  List<ComplaintListEntity> complaints = [];
  bool isLoading = false;
  String? currentFilter;
  int currentPage = 0;
  ComplaintsBloc({required this.getAllComplaint}) : super(ComplaintInitial()) {
    on<GetAllComplaintsEvent>((event, emit) async {
      try {
        if (isLoading) return;
        isLoading = true;

        final Map<String, String> statusMap = {
          'جديدة': 'PENDING',
          'قيد المعالجة': 'IN PROGRESS',
          'منجزة': 'CLOSED',
          'مرفوضة': 'REJECTED',
          'طلب معلومات': 'INFO REQUESTED',
          'تم الحل': 'RESOLVED',
        };

        final String? incomingFilter = event.status;
        // If incomingFilter is null but we have a currentFilter, keep using currentFilter (pagination case)
        final String? filterToUse = incomingFilter ?? currentFilter;
        final bool filterChanged =
            incomingFilter != null && incomingFilter != currentFilter;

        if (event.refresh || filterChanged) {
          currentPage = 0;
          currentFilter = filterToUse;
          complaints.clear();
          emit(ComplaintLoading());
        }
        // For pagination, ensure currentFilter is preserved
        else if (incomingFilter == null && currentFilter != null) {
          // Pagination case - keep currentFilter as is
        }

        // Map Arabic filter text to API status code
        // If filter is null (الكل), mappedStatus will be null (get all)
        final String? mappedStatus =
            filterToUse != null && statusMap.containsKey(filterToUse)
            ? statusMap[filterToUse]!
            : null;

        if (kDebugMode) {
          print(
            '🔍 Filter: "$filterToUse" (current: "$currentFilter") -> Status: "$mappedStatus"',
          );
        }

        // Use filter API if status is specified, otherwise use getAllComplaints
        final result = mappedStatus != null
            ? await getAllComplaint.filter(
                page: currentPage,
                size: event.size,
                status: mappedStatus,
              )
            : await getAllComplaint(page: currentPage, size: event.size);

        result.fold(
          (failure) {
            isLoading = false;
            emit(ComplaintError(message: failure.errMessage));
          },
          (data) {
            try {
              // API filters by status, so add all results directly
              complaints.addAll(data.content);

              if (data.hasNext) currentPage++;

              isLoading = false;
              emit(
                ComplaintSuccess(complaint: data, allComplaints: complaints),
              );
            } catch (e) {
              isLoading = false;
              emit(
                ComplaintError(
                  message: 'Failed to process complaints: ${e.toString()}',
                ),
              );
            }
          },
        );
      } catch (e) {
        isLoading = false;
        emit(
          ComplaintError(message: 'Unexpected error occurred: ${e.toString()}'),
        );
      }
    });
  }
}
