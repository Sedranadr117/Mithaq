import 'package:equatable/equatable.dart';

abstract class ComplaintsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAllComplaintsEvent extends ComplaintsEvent {
  final bool refresh;
  final int page;
  final int size;
  final String? status;
  GetAllComplaintsEvent({
    this.status,
    this.refresh = false,
    this.page = 0,
    this.size = 10,
  });
}
