import 'package:complaint_app/config/helper/injection_container.dart';
import 'package:complaint_app/config/themes/app_theme.dart';
import 'package:complaint_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:complaint_app/features/auth/presentation/pages/welcome_page.dart';
import 'package:complaint_app/features/complaints/domain/usecases/add_complaints.dart';
import 'package:complaint_app/features/complaints/domain/usecases/get_all_complaint.dart';
import 'package:complaint_app/features/complaints/presentation/bloc/add/add_complaint_bloc.dart';
import 'package:complaint_app/features/complaints/presentation/bloc/show_all/show_all_complaints_bloc.dart';
import 'package:complaint_app/features/complaints/presentation/bloc/show_all/show_all_complaints_event.dart';
import 'package:complaint_app/features/complaints/presentation/pages/add_complaints_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider<ComplaintsBloc>(
          create: (_) =>
              ComplaintsBloc(getAllComplaint: sl<GetAllComplaint>())
                ..add(GetAllComplaintsEvent(refresh: true)),
        ),
        BlocProvider(
          create: (_) =>
              AddComplaintBloc(addComplaintUseCase: sl<AddComplaint>()),
          child: const AddComplaintsPage(),
        ),
      ],
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
