import 'package:classhub/core/theme/buttons.dart';
import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/texts.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData theme = ThemeData(
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: cBackground,
    colorScheme: const ColorScheme.light()
        .copyWith(primary: cColorPrimary, shadow: Colors.transparent),
    primaryColor: cColorPrimary,
    // fontFamily: 'EuclidSquare',
    fontFamily: 'Onest',
    appBarTheme: const AppBarTheme(
      backgroundColor: cColorPrimary,
      centerTitle: true,
      foregroundColor: cColorTextWhite,
      surfaceTintColor: cBackground,
      scrolledUnderElevation: 12,
    ),
    snackBarTheme: const SnackBarThemeData(
        backgroundColor: cColorGray4,
        contentTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: "Onest",
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