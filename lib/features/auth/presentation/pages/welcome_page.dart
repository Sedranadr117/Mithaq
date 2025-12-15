import 'package:complaint_app/config/extensions/navigator.dart';
import 'package:complaint_app/config/extensions/theme.dart';
import 'package:complaint_app/config/themes/app_assets.dart';
import 'package:complaint_app/config/themes/app_colors.dart';
import 'package:complaint_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:complaint_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:complaint_app/features/auth/presentation/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colors.primary;
    Widget buildCurvedBackground() {
      return Container(
        height: 60.0.h,
        width: 100.0.w,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: context.colors.onSecondaryContainer,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            buildCurvedBackground(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  SizedBox(height: 10.0.h),
                  Text(
                    "أهلاً وسهلاً بك في ميثاق",
                    style: context.text.titleLarge!.copyWith(
                      color: context.colors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5.0.h),
                  SizedBox(
                    height: 35.0.h,
                    width: 80.0.w,
                    child: Image.asset(Assets.assetsMainScreen),
                  ),
                  const Spacer(),
                  MainButton(
                    text: "تسجيل حساب",
                    onPressed: () {
                      context.pushPage(SignupScreen());
                    },
                  ),
                  SizedBox(height: 2.0.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        context.pushPage(const SignInScreen());
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.background,
                        foregroundColor: primaryColor,
                        side: BorderSide(color: primaryColor, width: 2),
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.0.w,
                          vertical: 2.0.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        'تسجيل الدخول',
                        style: context.text.bodyLarge!.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
