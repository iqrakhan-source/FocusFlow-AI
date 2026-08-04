import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  // ---------------------- LIGHT THEME ----------------------

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.card,
      error: AppColors.destructive,

      onPrimary: AppColors.primaryForeground,
      onSecondary: AppColors.secondaryForeground,
      onSurface: AppColors.foreground,
    ),

    scaffoldBackgroundColor: AppColors.background,

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.foreground,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: AppColors.foreground,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.extraLarge),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.primaryForeground,
        elevation: 0,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(AppRadius.large),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 54),
        side: const BorderSide(
          color: AppColors.border,
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(AppRadius.large),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.card,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),

      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.mutedForeground,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(AppRadius.large),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(AppRadius.large),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(AppRadius.large),
        borderSide: const BorderSide(
          color: AppColors.destructive,
        ),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
    ),

    bottomNavigationBarTheme:
    const BottomNavigationBarThemeData(
      backgroundColor: AppColors.card,
      selectedItemColor: AppColors.primary,
      unselectedItemColor:
      AppColors.mutedForeground,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),

    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,

      headlineLarge: AppTextStyles.heading1,
      headlineMedium: AppTextStyles.heading2,
      headlineSmall: AppTextStyles.heading3,

      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,

      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,

      labelLarge: AppTextStyles.button,
      labelMedium: AppTextStyles.labelMedium,
    ),
  );

  // ---------------------- DARK THEME ----------------------

  static ThemeData darkTheme = lightTheme.copyWith(
    brightness: Brightness.dark,

    colorScheme: const ColorScheme.dark(
      primary: DarkColors.primary,
      secondary: DarkColors.secondary,
      surface: DarkColors.card,

      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: DarkColors.foreground,
    ),

    scaffoldBackgroundColor: DarkColors.background,

    appBarTheme: AppBarTheme(
      backgroundColor: DarkColors.background,
      foregroundColor: DarkColors.foreground,
      elevation: 0,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: DarkColors.foreground,
      ),
    ),

    cardTheme: lightTheme.cardTheme.copyWith(
      color: DarkColors.card,
    ),

    dividerTheme: const DividerThemeData(
      color: DarkColors.border,
    ),

    bottomNavigationBarTheme:
    const BottomNavigationBarThemeData(
      backgroundColor: DarkColors.card,
      selectedItemColor: DarkColors.primary,
      unselectedItemColor:
      DarkColors.mutedForeground,
    ),

    inputDecorationTheme:
    lightTheme.inputDecorationTheme.copyWith(
      fillColor: DarkColors.card,
    ),
  );
}