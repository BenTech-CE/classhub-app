import 'package:classhub/core/theme/sizes.dart';
import 'package:flutter/material.dart';

class BaseClassWidget extends StatefulWidget {
  final MaterialColor classColor;
  final Widget child; 

  const BaseClassWidget({
    Key? key,
    required this.classColor,
    required this.child,
  }) : super( key: key );

  @override
  State<BaseClassWidget> createState() => _BaseClassWidgetState();
}

class _BaseClassWidgetState extends State<BaseClassWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(sPadding3),
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: widget.classColor.shade100,
          border: Border.fromBorderSide(
              BorderSide(color: widget.classColor.shade300, width: 4)),
          borderRadius: const BorderRadius.all(Radius.circular(24))),
      child: widget.child,
    );
  }
}
