  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'dropdown_state.dart';

  class DropdownCubit<T> extends Cubit<DropdownState<T>> {
    DropdownCubit() : super(DropdownState<T>());

    void toggleDropdown() {
      emit(state.copyWith(isOpen: !state.isOpen));
    }

    void selectItem(T item) {
      emit(state.copyWith(selectedItem: item, isOpen: false));
    }

    void closeDropdown() {
      emit(state.copyWith(isOpen: false));
    }
  }
