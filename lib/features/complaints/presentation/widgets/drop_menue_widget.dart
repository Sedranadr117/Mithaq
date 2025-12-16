import 'package:complaint_app/config/themes/app_colors.dart';
import 'package:complaint_app/features/complaints/presentation/bloc/dropdown/dropdown_cubit.dart';
import 'package:complaint_app/features/complaints/presentation/bloc/dropdown/dropdown_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final void Function(T) onSelect;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DropdownCubit<T>, DropdownState<T>>(
      builder: (context, state) {
        final cubit = context.read<DropdownCubit<T>>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Label فوق الحقل
            Text(
              "$label *",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),

            /// الحقل نفسه
            InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                cubit.toggleDropdown();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.textDisabledLight),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.selectedItem?.toString() ?? "اختر $label",
                      style: TextStyle(
                        fontSize: 14,
                        color: state.selectedItem == null
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                    Icon(
                      state.isOpen
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),

            /// القائمة
            if (state.isOpen)
              Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 205,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 0,
                        ),
                        visualDensity: const VisualDensity(vertical: -2),
                        title: Text(
                          item as String,
                          style: const TextStyle(fontSize: 14),
                        ),
                        onTap: () {
                          cubit.selectItem(item);
                          onSelect(item);
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
