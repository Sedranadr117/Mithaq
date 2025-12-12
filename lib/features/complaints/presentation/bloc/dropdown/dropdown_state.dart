import 'package:equatable/equatable.dart';

class DropdownState<T> extends Equatable {
  final bool isOpen;
  final T? selectedItem;

  const DropdownState({this.isOpen = false, this.selectedItem});

  DropdownState<T> copyWith({bool? isOpen, T? selectedItem}) {
    return DropdownState<T>(
      isOpen: isOpen ?? this.isOpen,
      selectedItem: selectedItem ?? this.selectedItem,
    );
  }

  @override
  List<Object?> get props => [isOpen, selectedItem];
}
