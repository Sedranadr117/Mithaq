import 'package:complaint_app/config/themes/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final IconData? icon;
  final bool? isIcon;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.icon,
    this.isIcon,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(8);
    final borderColor = AppColors.textDisabledLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label فوق الحقل
        Text(
          label != 'اقترح حلاً' ? "$label *" : label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),

        /// الحقل نفسه
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(
              color: Theme.of(context).hintColor,
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            suffixIcon: isIcon == true
                ? Icon(icon, color: Theme.of(context).primaryColor)
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
