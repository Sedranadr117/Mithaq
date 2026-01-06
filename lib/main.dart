import 'package:complaint_app/config/helper/injection_container.dart';
import 'package:complaint_app/config/themes/app_theme.dart';
import 'package:complaint_app/core/databases/cache/cache_helper.dart';
import 'package:complaint_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:complaint_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:complaint_app/features/auth/presentation/pages/welcome_page.dart';
import 'package:complaint_app/features/complaints/domain/usecases/add_complaints.dart';
import 'package:complaint_app/features/complaints/domain/usecases/get_all_complaint.dart';
import 'package:complaint_app/features/complaints/presentation/bloc/add/add_complaint_bloc.dart';
import 'package:complaint_app/features/complaints/presentation/bloc/show_all/show_all_complaints_bloc.dart';
import 'package:complaint_app/features/complaints/presentation/bloc/show_all/show_all_complaints_event.dart';
import 'package:complaint_app/features/complaints/presentation/pages/add_complaints_page.dart';
import 'package:complaint_app/core/services/notification_service.dart';
import 'package:complaint_app/features/complaints/presentation/pages/complaints_page.dart';
import 'package:complaint_app/features/notification/presentation/pages/notification_page.dart';
import 'package:complaint_app/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:complaint_app/features/notification/presentation/bloc/notification_event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init();

  // Create NotificationBloc instance BEFORE initializing NotificationService
  // This ensures callbacks can be set up immediately
  final notificationBloc = sl<NotificationBloc>();

  // Set up notification callbacks BEFORE initializing NotificationService
  // This ensures they're available when listeners are registered
  NotificationService.instance.onNotificationReceived = (message) {
    // Add notification to bloc from anywhere in the app
    notificationBloc.add(NotificationReceivedEvent(message: message));
    debugPrint(
      '📬 Notification received globally: ${message.notification?.title}',
    );
  };

  NotificationService.instance.onNotificationClicked = (message) {
    // Handle notification click from anywhere in the app
    notificationBloc.add(NotificationClickedEvent(message: message));
    debugPrint(
      '📬 Notification clicked globally: ${message.notification?.title}',
    );

    // Navigate to the notification screen when a notification is tapped
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => const NotificationPage()),
    );
  };

  // Initialize NotificationService AFTER callbacks are set
  // This ensures listeners can use the callbacks immediately
  await NotificationService.instance.init();

  // Pass the bloc to MyApp so it can use BlocProvider.value
  runApp(MyApp(notificationBloc: notificationBloc));
}

class MyApp extends StatelessWidget {
  final NotificationBloc notificationBloc;

  const MyApp({super.key, required this.notificationBloc});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: notificationBloc,
        ), // Use the instance from main()
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
      child: Builder(
        builder: (context) {
          final secureStorage = sl<SecureStorageHelper>();

          return Sizer(
            builder: (context, orientation, deviceType) {
              return MaterialApp(
                navigatorKey: navigatorKey,
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
                home: FutureBuilder<String?>(
                  future: secureStorage.getSavedAuthToken(
                    AuthRepositoryImpl.AUTH_TOKEN_KEY,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final token = snapshot.data;
                    return (token == null || token.isEmpty)
                        ? const WelcomeScreen()
                        : const HomePage();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
