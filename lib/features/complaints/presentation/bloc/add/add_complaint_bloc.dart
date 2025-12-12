import 'package:complaint_app/features/complaints/domain/usecases/add_complaints.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/complaints_entity.dart';
import '../../../../../../../core/params/params.dart';

part 'add_complaint_event.dart';
part 'add_complaint_state.dart';

class AddComplaintBloc extends Bloc<AddComplaintEvent, AddComplaintState> {
  final AddComplaint addComplaintUseCase;

  AddComplaintBloc({required this.addComplaintUseCase})
    : super(AddComplaintInitial()) {
    on<SendComplaintEvent>((event, emit) async {
      emit(AddComplaintLoading());

      final result = await addComplaintUseCase(params: event.params);

      result.fold((failure) {
        emit(AddComplaintError(message: failure.errMessage));
      }, (data) => emit(AddComplaintSuccess(complaint: data)));
    });
  }
}
