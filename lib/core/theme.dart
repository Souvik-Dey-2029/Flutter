import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AuraLife Design System
/// Deep dark theme with neon cyan + purple glassmorphism accents
class AuraColors {
  AuraColors._();

  // Core backgrounds
  static const Color scaffoldBg = Color(0xFF0B0B0B);
  static const Color cardBg = Color(0xFF0F0F1A);
  static const Color surfaceDark = Color(0xFF111122);
  static const Color surfaceLight = Color(0xFF1A1A2E);

  // Neon accents
  static const Color neonCyan = Color(0xFF00FFFF);
  static const Color neonPurple = Color(0xFFBF00FF);
  static const Color neonBlue = Color(0xFF536DFE);
  static const Color neonPink = Color(0xFFFF006E);

  // Semantic colors
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFAB00);
  static const Color error = Color(0xFFFF5252);
  static const Color info = Color(0xFF40C4FF);

  // Priority colors
  static const Color priorityHigh = Color(0xFFFF5252);
  static const Color priorityMedium = Color(0xFFFFAB00);
  static const Color priorityLow = Color(0xFF00E676);

  // Glass
  static Color glassWhite = Colors.white.withValues(alpha: 0.06);
  static Color glassBorder = Colors.white.withValues(alpha: 0.08);
  static Color glassHighlight = Colors.white.withValues(alpha: 0.12);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static Color textSecondary = Colors.white.withValues(alpha: 0.6);
  static Color textTertiary = Colors.white.withValues(alpha: 0.35);

  // Gradients
  static const LinearGradient neonGradient = LinearGradient(
    colors: [neonCyan, neonPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient neonGradientVertical = LinearGradient(
    colors: [neonCyan, neonPurple],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient cardGradient = LinearGradient(
    colors: [
      Colors.white.withValues(alpha: 0.08),
      Colors.white.withValues(alpha: 0.02),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkOverlay = LinearGradient(
    colors: [Color(0xFF0B0B0B), Color(0xFF111122)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AuraTextStyles {
  AuraTextStyles._();

  static TextStyle get displayLarge => GoogleFonts.poppins(
        fontSize: 42,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        color: AuraColors.textPrimary,
      );

  static TextStyle get displayMedium => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
        color: AuraColors.textPrimary,
      );

  static TextStyle get headlineLarge => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AuraColors.textPrimary,
      );

  static TextStyle get headlineMedium => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AuraColors.textPrimary,
      );

  static TextStyle get titleLarge => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AuraColors.textPrimary,
      );

  static TextStyle get titleMedium => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AuraColors.textPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AuraColors.textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AuraColors.textSecondary,
      );

  static TextStyle get bodySmall => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AuraColors.textTertiary,
      );

  static TextStyle get labelLarge => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AuraColors.textPrimary,
      );

  static TextStyle get labelMedium => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AuraColors.textSecondary,
      );

  static TextStyle get labelSmall => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AuraColors.textTertiary,
      );

  static TextStyle get mono => GoogleFonts.jetBrainsMono(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AuraColors.neonCyan,
      );
}

class AuraTheme {
  AuraTheme._();

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: AuraColors.scaffoldBg,
        colorScheme: const ColorScheme.dark(
          primary: AuraColors.neonCyan,
          secondary: AuraColors.neonPurple,
          surface: AuraColors.surfaceDark,
          error: AuraColors.error,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AuraColors.neonCyan,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AuraColors.glassBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AuraColors.glassBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AuraColors.neonCyan, width: 1.5),
          ),
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AuraColors.neonCyan,
            foregroundColor: Colors.black,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
}

// Shared decoration constants
class AuraDecorations {
  AuraDecorations._();

  static const double cardRadius = 20.0;
  static const double cardRadiusLarge = 24.0;
  static const double buttonRadius = 16.0;
  static const double blurSigma = 12.0;

  static BoxDecoration get glassDecoration => BoxDecoration(
        gradient: AuraColors.cardGradient,
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(color: AuraColors.glassBorder, width: 1),
      );

  static List<BoxShadow> neonShadow(Color color, {double blur = 20, double spread = 0}) => [
        BoxShadow(
          color: color.withValues(alpha: 0.3),
          blurRadius: blur,
          spreadRadius: spread,
        ),
      ];
}
