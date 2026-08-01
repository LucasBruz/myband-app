import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tokens de marca — dirección visual "dashboard oscuro + lima"
/// confirmada. Cambiar acá si se renombra la app o se ajusta la paleta.
class AppColors {
  static const lime = Color(0xFFD6FF3B); // acento principal
  static const bg = Color(0xFF151517); // fondo base
  static const card = Color(0xFF1E1F23); // tarjetas
  static const card2 = Color(0xFF232429); // tarjetas variante/gradiente
  static const border = Color(0xFF2B2C31);
  static const text = Color(0xFFF2F2F0);
  static const muted = Color(0xFF8B8D97);
  static const onLime = Color(0xFF101112); // texto sobre fondo lima
}

class AppTheme {
  /// MyBand es una app "dark-first": se piensa para ensayos y escenarios
  /// con poca luz, así que el tema oscuro es el principal.
  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.lime,
        brightness: Brightness.dark,
        primary: AppColors.lime,
        onPrimary: AppColors.onLime,
        surface: AppColors.card,
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.anton(
          fontSize: 34,
          color: AppColors.text,
          height: 0.95,
          letterSpacing: 0.5,
        ),
        displayMedium: GoogleFonts.anton(
          fontSize: 56,
          color: AppColors.text,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lime,
          foregroundColor: AppColors.onLime,
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        hintStyle: GoogleFonts.inter(color: AppColors.muted, fontSize: 14),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  /// Tema claro de respaldo (mismo esqueleto, por si se pide luego).
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.lime,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.interTextTheme(),
      );
}

/// Helper para el estilo de titular tipo "ORGANIZÁ TU BANDA" en mayúscula.
TextStyle headlineStyle(BuildContext context) =>
    Theme.of(context).textTheme.displayLarge!;

