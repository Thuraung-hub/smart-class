import 'package:flutter/material.dart';

class AppTheme {
  static const Color emerald = Color(0xFF059669);
  static const Color emeraldLight = Color(0xFFD1FAE5);
  static const Color emeraldDark = Color(0xFF047857);
  static const Color zinc900 = Color(0xFF18181B);
  static const Color zinc600 = Color(0xFF52525B);
  static const Color zinc400 = Color(0xFFA1A1AA);
  static const Color zinc200 = Color(0xFFE4E4E7);
  static const Color zinc100 = Color(0xFFF4F4F5);
  static const Color zinc50 = Color(0xFFFAFAFA);
  static const Color white = Colors.white;

  static ThemeData get theme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: emerald,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: zinc50,
        fontFamily: 'Roboto',
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: white,
          foregroundColor: zinc900,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      );
}
