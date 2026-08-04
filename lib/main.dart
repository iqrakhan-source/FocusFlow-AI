import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          theme: AppTheme.lightTheme,

          darkTheme: AppTheme.darkTheme,

          themeMode: themeProvider.themeMode,

          home:  Scaffold(
            body: Center(
              child: FloatingActionButton(
                onPressed: () {
                  context.read<ThemeProvider>().toggleTheme();
                },
                child: const Icon(Icons.dark_mode),
              ),
            ),
          ),
        );
      },
    );
  }
}