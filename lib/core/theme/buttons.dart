import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:flutter/material.dart';

class AppButtonsTheme {
  AppButtonsTheme._();

  static ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(sBorderRadius))),
      foregroundColor: cColorTextWhite,
      backgroundColor: cColorPrimary,
      // side: const BorderSide(color: cColorPrimary),
      padding: const EdgeInsets.symmetric(vertical: sButtonHeight),
      elevation: 0,
      shadowColor: Colors.transparent,
      textStyle: const TextStyle(
          fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
    ),
  );

  static OutlinedButtonThemeData outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(sBorderRadius))),
      foregroundColor: cColorPrimary,
      side: const BorderSide(color: cColorPrimary),
      padding: const EdgeInsets.symmetric(vertical: sButtonHeight),
      textStyle: const TextStyle(
          fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
    ),
  );

  static TextButtonThemeData textButtonTheme = TextButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(sBorderRadius))),
      foregroundColor: cColorPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
    ),
  );
}