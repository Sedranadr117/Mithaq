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

        // Check if filter actually changed (including switching to "all" which is null)
        final bool filterChanged = incomingFilter != currentFilter;

        // Determine which filter to use:
        // - If incomingFilter is provided (including null for "all"), use it
        // - If incomingFilter is null and no refresh, it's pagination - use currentFilter
        final String? filterToUse = (event.refresh || filterChanged)
            ? incomingFilter // Use incoming filter when refreshing or filter changed
            : currentFilter; // Keep current filter for pagination

        if (event.refresh || filterChanged) {
          currentPage = 0;
          currentFilter =
              filterToUse; // This will be null when "all" is selected
          complaints.clear();
          emit(ComplaintLoading());
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

              // Always sort complaints so that the most recently created are on top
              complaints.sort((a, b) {
                final aDate = a.createdAt != null
                    ? DateTime.tryParse(a.createdAt!)
                    : null;
                final bDate = b.createdAt != null
                    ? DateTime.tryParse(b.createdAt!)
                    : null;

                if (aDate == null && bDate == null) return 0;
                if (aDate == null) return 1; // nulls go to bottom
                if (bDate == null) return -1;

                // Newest first
                return bDate.compareTo(aDate);
              });

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
