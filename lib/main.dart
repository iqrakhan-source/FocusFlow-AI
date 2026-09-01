import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'features/reflection/viewmodel/reflection_viewmodel.dart';
import 'core/routers/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

import 'features/auth/viewmodel/auth_viewmodel.dart';
import 'features/calendar/viewmodel/calendar_viewmodel.dart';
import 'features/subject/viewmodel/subject_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),

        ChangeNotifierProvider(
          create: (_) => CalendarViewModel(),
        ),

        ChangeNotifierProvider(
          create: (_) => ReflectionViewModel(),
        ),

        ChangeNotifierProvider(
          create: (_) => DashboardViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => SubjectViewModel(),
        ),
      ],
      child: const StudentTracker(),
    ),
  );
}

class StudentTracker extends StatelessWidget {
  const StudentTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}