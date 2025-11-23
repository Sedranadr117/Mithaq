import 'package:complaint_app/config/extensions/theme.dart';
import 'package:complaint_app/config/themes/app_colors.dart';
import 'package:complaint_app/config/themes/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final String icon;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.icon,
    required this.isPassword ,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
    late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
  }

  void _toggleObscure() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.0.h),
        child: TextFormField(
           controller: widget.controller,
           validator: widget.validator,
          obscureText: _isObscured,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            labelText: widget.labelText,
            prefixIcon: Padding(
              padding: EdgeInsets.only(right: 2.0.w, left: 4.0.w),
              child: CustomIconWidget(
              iconName: widget.icon,
              color: context.colors.primary,
              // استخدام w لحجم الأيقونة
              size: 5.0.w,
                        ),
            ),
             suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.secondaryColor ,
                    ),
                    onPressed: _toggleObscure,
                  )
                : null,
            contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: BorderSide(color: context.colors.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: BorderSide(color: context.colors.primary, width: 0.5.w),
            ),
            fillColor: AppColors.backgroundLight,
            filled: true,
            labelStyle: context.text.bodyLarge!.copyWith(color: context.colors.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}