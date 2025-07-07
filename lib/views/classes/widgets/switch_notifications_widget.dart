import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:flutter/material.dart';

import 'package:classhub/core/theme/colors.dart';
import 'package:flutter/material.dart';

class SwitchNotification extends StatelessWidget {
  final String name;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchNotification({
    Key? key,
    required this.name,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appColor = generateMaterialColor(cColorPrimary);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: cColorPrimary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.black87),
          ),
          Switch(
            value: value,
            activeTrackColor: cColorPrimary,
            inactiveTrackColor: appColor.shade100,
            activeColor: Colors.white,
            //trackOutlineColor: WidgetStatePropertyAll(outlineColor),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
