import 'package:classhub/core/theme/colors.dart';
import 'package:flutter/material.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextStyle placeholder = const TextStyle(
    fontFamily: "Onest",
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    color: cColorText2Azul,
    height: 1.2
  );

  static TextTheme textTheme = const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 26,
      color: cColorText1,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      color: cColorText1,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      fontSize: 22,
      color: cColorText1,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      color: cColorText1,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      color: cColorText1,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      color: cColorText1,
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: cColorGray2,
      fontWeight: FontWeight.w500,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      color: cColorGray1,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: cColorTextBlack,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      color: cColorPrimary,
      fontWeight: FontWeight.w600,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      color: cColorText3,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      color: cColorText1,
      fontWeight: FontWeight.w600
    )
  );
}