import 'package:flutter/material.dart';

class RoundedInputBorder extends OutlineInputBorder {
  const RoundedInputBorder({
    super.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
  });
}