import 'package:classhub/core/theme/buttons.dart';
import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/texts.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData theme = ThemeData(
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: cBackground,
    colorScheme: const ColorScheme.light()
        .copyWith(primary: cColorPrimary, shadow: Colors.transparent),
    primaryColor: cColorPrimary,
    // fontFamily: 'EuclidSquare',
    fontFamily: 'Poppins',
    appBarTheme: const AppBarTheme(
      backgroundColor: cBackground,
      centerTitle: true,
      foregroundColor: cColorPrimary,
      surfaceTintColor: cBackground,
      scrolledUnderElevation: 12,
    ),
    snackBarTheme: const SnackBarThemeData(
        backgroundColor: cColorGray4,
        contentTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins",
            color: cColorText1)),
    iconTheme: const IconThemeData(color: cColorGray2),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: cBackground,
      elevation: 0,
      height: 70,
    ),
    textTheme: AppTextTheme.textTheme,
    elevatedButtonTheme: AppButtonsTheme.elevatedButtonTheme,
    outlinedButtonTheme: AppButtonsTheme.outlinedButtonTheme,
    textButtonTheme: AppButtonsTheme.textButtonTheme,
  );
}