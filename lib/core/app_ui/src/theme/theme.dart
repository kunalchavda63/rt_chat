
import 'package:rt_chat/core/app_ui/app_ui.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.hex2824,
    scaffoldBackgroundColor: AppColors.hexEeeb,
    cardColor: AppColors.white,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.hex2824),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.hex4fc9),
      ),
      hintStyle: const TextStyle(color: AppColors.hex7777),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.hex2824,
        foregroundColor: AppColors.hexEeeb,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.hexEeeb,
    scaffoldBackgroundColor: AppColors.hex2824,
    cardColor: AppColors.hex3E3f,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.hexEeeb),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.hex3E3f,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.hex5353),
      ),
      hintStyle: const TextStyle(color: AppColors.hex7777),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.hexEeeb,
        foregroundColor: AppColors.hex2824,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
