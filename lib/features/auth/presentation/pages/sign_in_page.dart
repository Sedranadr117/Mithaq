import 'package:complaint_app/config/extensions/navigator.dart';
import 'package:complaint_app/config/extensions/theme.dart';
import 'package:complaint_app/config/helper/validation.dart';
import 'package:complaint_app/config/themes/app_assets.dart';
import 'package:complaint_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:complaint_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:complaint_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:complaint_app/features/auth/presentation/widgets/main_button.dart';
import 'package:complaint_app/features/complaints/presentation/pages/complaints_page.dart';
import 'package:complaint_app/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:complaint_app/features/notification/presentation/bloc/notification_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      // 2. إطلاق الحدث (Event) بعد التأكد من صحة المدخلات
      BlocProvider.of<AuthBloc>(context).add(
        LoginUserEvent(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          // Send FCM token to server after successful login
          try {
            context.read<NotificationBloc>().add(SendFcmTokenEvent());
            debugPrint('📤 Sending FCM token after login...');
          } catch (e) {
            debugPrint('⚠️ Failed to send FCM token after login: $e');
          }

          context.pushReplacementPage(HomePage());
        } else if (state is AuthErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: context.colors.primary,
        body: Directionality(
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

              Expanded(
                child: Container(
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
                        minHeight: MediaQuery.of(context).size.height * 0.8,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'تسجيل الدخول',
                              style: context.text.titleLarge!.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4.0.h),
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
                                      : _onLoginPressed,
                                  text: state is AuthLoadingState
                                      ? 'جاري التحميل...'
                                      : 'تسجيل دخول', // إظهار حالة التحميل
                                );
                              },
                            ),
                            SizedBox(height: 3.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('لا تمتلك حساب؟'),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size(0, 0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    context.pushReplacementPage(
                                      const SignupScreen(),
                                    );
                                  },
                                  child: Text(
                                    'سجل حساب جديد',
                                    style: context.text.bodyMedium!.copyWith(
                                      color: context.colors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
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
