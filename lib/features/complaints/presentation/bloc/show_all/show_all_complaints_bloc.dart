// ...existing code...
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
      if (isLoading) return;
      isLoading = true;

      final Map<String, String> statusMap = {
        'جديدة': 'PENDING',
        'قيد المعالجة': 'IN_PROGRESS',
        'منجزة': 'CLOSED',
        'مرفوضة': 'REJECTED',
      };

      final String? incomingFilter = event.status;
      final bool filterChanged =
          incomingFilter != null && incomingFilter != currentFilter;

      if (event.refresh || filterChanged) {
        currentPage = 0;
        currentFilter = incomingFilter;
        complaints.clear();

        isLoading = false;
        emit(ComplaintLoading());
        isLoading = true;
      } else {
        emit(ComplaintLoading());
      }

      final mappedStatus = currentFilter != null
          ? statusMap[currentFilter!]
          : null;

      final result = await getAllComplaint(
        page: currentPage,
        size: event.size,
        status: mappedStatus,
      );

      result.fold(
        (failure) {
          isLoading = false;
          emit(ComplaintError(message: failure.errMessage));
        },
        (data) {
          complaints.addAll(data.content);

          List<ComplaintListEntity> filteredComplaints = complaints;
          if (mappedStatus != null) {
            filteredComplaints = complaints
                .where((c) => c.status == mappedStatus)
                .toList();
          }

          if (data.hasNext) currentPage++;

          isLoading = false;
          emit(
            ComplaintSuccess(
              complaint: data,
              allComplaints: filteredComplaints,
            ),
          );
        },
      );
    });
  }
}
