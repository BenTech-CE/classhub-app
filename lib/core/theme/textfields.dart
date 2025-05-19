import 'package:classhub/core/theme/colors.dart';
import 'package:flutter/material.dart';

class RoundedInputBorder extends OutlineInputBorder {
  const RoundedInputBorder({
    super.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
  });
}

class RoundedColoredInputBorder extends OutlineInputBorder {
  const RoundedColoredInputBorder({
    super.borderSide = const BorderSide(color: cColorAzulSecondary),
    super.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
  });
}