import 'package:flutter/material.dart';

class SimpleTextFieldShadows {

  static List<BoxShadow> regular({Color? color}) {
    return [
      BoxShadow(
        offset: const Offset(0, 2),
        blurRadius: 5.0,
        spreadRadius: 1.0,
        color: color ?? Colors.grey.shade400
      )
    ];
  }
}
