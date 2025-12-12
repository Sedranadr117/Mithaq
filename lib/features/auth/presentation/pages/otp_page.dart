import 'package:complaint_app/config/extensions/navigator.dart';
import 'package:complaint_app/config/extensions/theme.dart';
import 'package:complaint_app/config/helper/validation.dart' show FormValidators;
import 'package:complaint_app/config/themes/app_colors.dart';
import 'package:complaint_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:complaint_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:complaint_app/features/auth/presentation/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  OtpScreen({super.key, required this.email});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const int otpLength = 6;
  
  // 1. تعريف 6 Controllers (أو استخدام List لتكون أكثر مرونة)
  late final List<TextEditingController> _controllers;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // تهيئة قائمة الـ Controllers
    _controllers = List.generate(otpLength, (_) => TextEditingController());
  }

  @override
  void dispose() {
    // التخلص من جميع الـ Controllers
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
  
  // 2. دالة تجميع الرمز وإطلاق حدث التحقق
  void _onVerifyPressed() {
    // 3. تجميع الـ OTP Code من جميع الحقول
    final otpCode = _controllers.map((c) => c.text).join();
    
    // 4. التحقق من صحة الفورم (حقول ممتلئة وصحيحة)
    if (_formKey.currentState!.validate()) {
      // إطلاق حدث التحقق (VerifyOtpEvent)
      BlocProvider.of<AuthBloc>(context).add(
        VerifyOtpEvent(
          otpCode: otpCode, // الرمز المجمع
          email: widget.email, // الإيميل الممرر
        ),
      );
    } else {
      // إذا كان هناك خطأ في الـ Validation (قد لا نحتاجه لأن الـ Validator يجب أن يظهر الخطأ)
      // يمكنك عرض رسالة عامة هنا
    }
  }
  
  // دالة إطلاق حدث إعادة الإرسال
  void _onResendPressed() {
    BlocProvider.of<AuthBloc>(context).add(
      ResendOtpEvent(email: widget.email),
    );
  }
  @override
  Widget build(BuildContext context) {

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OtpVerificationSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم التحقق بنجاح الرجاء القيام بتسجيل الدخول!')),
          );
          context.pushReplacementPage(SignInScreen()); // افترض أن هذه الدالة تعود إلى أول شاشة
        } else if (state is OtpResendSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is AuthErrorState) {
          // إظهار رسالة الخطأ
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child:
     Scaffold(
      appBar: AppBar(
        leading: BackButton(color: AppColors.textPrimaryLight),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10.h),
            Text(
              'تحقق من الرمز',
              style: context.text.titleLarge!.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 24.sp,
                color: context.colors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'لقد أرسلنا رمزاً مكوناً من 6 أرقام إلى بريدك الإلكتروني ${widget.email}. الرجاء إدخاله أدناه لإتمام عملية التحقق.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5.h),

            Form(
              key: _formKey,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    otpLength,
                    (index) => SizedBox(
                      width: 13.w,
                      child: TextFormField(
                        controller: _controllers[index],
                        onChanged: (value) {
                          if (value.length == 1 && index < otpLength - 1) {
                            FocusScope.of(context).nextFocus();
                          }
                          else if (value.isEmpty && index > 0) {
                              // إذا قام المستخدم بحذف القيمة، ينتقل إلى الحقل السابق
                              FocusScope.of(context).previousFocus();
                            }
                        },
                        validator: (value) => FormValidators.validateSingleOtpDigit(value),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: context.text.titleLarge!,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          counterText: "",
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.w),
                            borderSide: BorderSide(
                              color: context.colors.primary,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder( // 👈 لإظهار خطأ Validation
                              borderRadius: BorderRadius.circular(2.w),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 3.h),
         BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (previous, current) => current is AuthLoadingState || current is OtpResendSuccessState,
                builder: (context, state) {
                  final bool isLoading = state is AuthLoadingState;
                  return TextButton(
                    onPressed: isLoading ? null : _onResendPressed, // تعطيل الزر أثناء التحميل
                    child: Text(
                      'إعادة إرسال الرمز',
                      style: context.text.bodyMedium!.copyWith(
                        color: context.colors.secondary,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  );
                },
              ),
            SizedBox(height: 1.h),
         BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final bool isLoading = state is AuthLoadingState;
                  return MainButton(
                    text: isLoading ? 'جاري التحقق...' : 'تحقق',
                    onPressed: isLoading ? null : _onVerifyPressed, // تعطيل الزر أثناء التحميل
                  );
                },
              ),
          ],
        ),
      ),
    ));
  }
}
