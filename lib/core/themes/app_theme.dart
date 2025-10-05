import 'package:flutter/material.dart';
import 'package:glpi_client_advanced/core/constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        
        // Typography
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 57,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.25,
          ),
          displayMedium: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w400,
          ),
          displaySmall: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w400,
          ),
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w400,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w400,
          ),
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        
        // App Bar
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        
        // Card
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        
        // Elevated Button
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            ),
          ),
        ),
        
        // Input Decoration
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        
        // Snack Bar
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          ),
          actionTextColor: Colors.white,
        ),
        
        // Divider
        dividerTheme: const DividerThemeData(
          thickness: 1,
          space: 16,
        ),
        
        // Navigation
        navigationBarTheme: NavigationBarThemeData(
          height: 80,
          backgroundColor: Colors.white,
          elevation: 8,
          indicatorColor: Colors.blue.shade100,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
        
        // Floating Action Button
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        
        // Dialog
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius * 2),
          ),
          elevation: 8,
        ),
        
        // Bottom Sheet
        bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppConstants.defaultRadius * 2),
            ),
          ),
          elevation: 8,
        ),
        
        // Tab Bar
        tabBarTheme: TabBarTheme(
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            color: Colors.blue.shade100,
          ),
          labelColor: Colors.blue.shade700,
          unselectedLabelColor: Colors.grey.shade600,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        ),
        
        // Data Table
        dataTableTheme: DataTableThemeData(
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
          dataRowColor: MaterialStateProperty.all(Colors.white),
          dividerThickness: 1,
          columnSpacing: 24,
          horizontalMargin: 16,
        ),
        
        // Chip
        chipTheme: ChipThemeData(
          backgroundColor: Colors.grey.shade200,
          disabledColor: Colors.grey.shade100,
          selectedColor: Colors.blue.shade100,
          secondarySelectedColor: Colors.blue.shade200,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          labelStyle: const TextStyle(fontSize: 12),
          secondaryLabelStyle: const TextStyle(fontSize: 12),
          brightness: Brightness.light,
        ),
        
        // Badge
        badgeTheme: BadgeThemeData(
          backgroundColor: Colors.red,
          textColor: Colors.white,
          smallSize: 8,
          largeSize: 16,
        ),
        
        // Progress Indicator
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.blue.shade600,
          linearTrackColor: Colors.grey.shade200,
          circularTrackColor: Colors.grey.shade200,
        ),
        
        // Scrollbar
        scrollbarTheme: ScrollbarThemeData(
          thickness: MaterialStateProperty.all(8),
          thumbColor: MaterialStateProperty.all(Colors.grey.shade400),
          trackColor: MaterialStateProperty.all(Colors.grey.shade100),
          radius: const Radius.circular(4),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        
        // Typography
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 57,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.25,
          ),
          displayMedium: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w400,
          ),
          displaySmall: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w400,
          ),
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w400,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w400,
          ),
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        
        // App Bar
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        
        // Card
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        
        // Elevated Button
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            ),
          ),
        ),
        
        // Input Decoration
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          ),
          filled: true,
          fillColor: Colors.grey.shade900,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        
        // Snack Bar
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          ),
          actionTextColor: Colors.white,
          backgroundColor: Colors.grey.shade800,
        ),
        
        // Divider
        dividerTheme: const DividerThemeData(
          thickness: 1,
          space: 16,
          color: Colors.grey,
        ),
        
        // Navigation
        navigationBarTheme: NavigationBarThemeData(
          height: 80,
          backgroundColor: Colors.grey.shade900,
          elevation: 8,
          indicatorColor: Colors.blue.shade700,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
        
        // Floating Action Button
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        
        // Dialog
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius * 2),
          ),
          elevation: 8,
          backgroundColor: Colors.grey.shade900,
        ),
        
        // Bottom Sheet
        bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppConstants.defaultRadius * 2),
            ),
          ),
          elevation: 8,
          backgroundColor: Colors.grey.shade900,
        ),
        
        // Tab Bar
        tabBarTheme: TabBarTheme(
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            color: Colors.blue.shade700,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade400,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        ),
        
        // Data Table
        dataTableTheme: DataTableThemeData(
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade800),
          dataRowColor: MaterialStateProperty.all(Colors.grey.shade900),
          dividerThickness: 1,
          columnSpacing: 24,
          horizontalMargin: 16,
        ),
        
        // Chip
        chipTheme: ChipThemeData(
          backgroundColor: Colors.grey.shade800,
          disabledColor: Colors.grey.shade700,
          selectedColor: Colors.blue.shade700,
          secondarySelectedColor: Colors.blue.shade600,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          labelStyle: const TextStyle(fontSize: 12, color: Colors.white),
          secondaryLabelStyle: const TextStyle(fontSize: 12, color: Colors.white),
          brightness: Brightness.dark,
        ),
        
        // Badge
        badgeTheme: BadgeThemeData(
          backgroundColor: Colors.red,
          textColor: Colors.white,
          smallSize: 8,
          largeSize: 16,
        ),
        
        // Progress Indicator
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.blue.shade600,
          linearTrackColor: Colors.grey.shade800,
          circularTrackColor: Colors.grey.shade800,
        ),
        
        // Scrollbar
        scrollbarTheme: ScrollbarThemeData(
          thickness: MaterialStateProperty.all(8),
          thumbColor: MaterialStateProperty.all(Colors.grey.shade600),
          trackColor: MaterialStateProperty.all(Colors.grey.shade800),
          radius: const Radius.circular(4),
        ),
      );
}