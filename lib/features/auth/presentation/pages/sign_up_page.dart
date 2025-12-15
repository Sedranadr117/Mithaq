import 'package:complaint_app/config/extensions/navigator.dart';
import 'package:complaint_app/config/extensions/theme.dart';
import 'package:complaint_app/config/helper/validation.dart';
import 'package:complaint_app/config/themes/app_assets.dart';
import 'package:complaint_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:complaint_app/features/auth/presentation/pages/otp_page.dart';
import 'package:complaint_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:complaint_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:complaint_app/features/auth/presentation/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
// استيراد Sizer

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignUpPressed() {
    if (_formKey.currentState!.validate()) {
      // 2. إطلاق حدث التسجيل (RegisterUserEvent)
      BlocProvider.of<AuthBloc>(context).add(
        RegisterUserEvent(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.sizeOf(context).height;
    final primaryColor = context.colors.primary;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: primaryColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            context.pushReplacementPage(
              OtpScreen(email: _emailController.text),
            );
          } else if (state is AuthErrorState) {
            // إظهار رسالة الخطأ
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 11.h),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 40.w,
                    child: Image.asset(
                      Assets.assetsWhiteLogoIcon,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // البطاقة البيضاء (مكان تسجيل الحساب)
              Expanded(
                child: Container(
                  // استخدام h بدلاً من hp

                  // استخدام w بدلاً من wp
                  padding: EdgeInsets.all(6.0.w),
                  decoration: BoxDecoration(
                    color: context.colors.onSecondaryContainer,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: context.colors.shadow,
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            MediaQuery.of(context).size.height *
                            0.8, // على الأقل 80% من الشاشة
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // استخدام h
                            Text(
                              'تسجيل حساب',
                              style: context.text.titleLarge!.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4.0.h),
                            CustomTextField(
                              labelText: 'الاسم الكامل',
                              icon: 'person',
                              isPassword: false,
                              controller: _nameController,
                              validator: (value) =>
                                  FormValidators.userNameValidator(value),
                            ),
                            SizedBox(height: 2.5.h),
                            CustomTextField(
                              labelText: 'البريد الإلكتروني',
                              icon: 'email',
                              isPassword: false,
                              controller: _emailController,
                              validator: (value) =>
                                  FormValidators.emailValidator(value),
                            ),
                            SizedBox(height: 2.5.h),
                            CustomTextField(
                              labelText: 'كلمة المرور',
                              icon: 'lock',
                              isPassword: true,
                              controller: _passwordController,
                              validator: (value) =>
                                  FormValidators.strongPasswordValidator(value),
                            ),
                            SizedBox(height: 4.0.h), // استخدام h
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                return MainButton(
                                  onPressed: state is AuthLoadingState
                                      ? null
                                      : _onSignUpPressed,
                                  text: state is AuthLoadingState
                                      ? 'جاري التحميل'
                                      : 'تسجيل حساب ',
                                );
                              },
                            ),

                            SizedBox(height: 2.5.h),
                            TextButton(
                              onPressed: () {
                                context.pushReplacementPage(
                                  const SignInScreen(),
                                );
                              },
                              child: Text(
                                'لديك بالفعل حساب؟ سجل دخول',
                                style: context.text.bodyMedium!.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
