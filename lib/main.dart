import 'package:complaint_app/config/helper/injection_container.dart';
import 'package:complaint_app/config/themes/app_theme.dart';
import 'package:complaint_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:complaint_app/features/auth/presentation/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة الـ Service Locator
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => sl<AuthBloc>())],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(context),

            // localizationsDelegates: const [
            //   // هذه ضرورية لضمان عمل RTL بشكل صحيح
            //   DefaultMaterialLocalizations.delegate,
            //   DefaultWidgetsLocalizations.delegate,
            // ],
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: child!,
              );
            },
            home: WelcomeScreen(),
          );
        },
      ),
    );
  }
}
