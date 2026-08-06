import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routers/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
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