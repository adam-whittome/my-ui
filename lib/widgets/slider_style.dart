import 'package:flutter/widgets.dart';

class SliderStyle {
  final Color colorLeftOfHandle;
  final Color colorRightOfHandle;
  final Color borderColor;
  final double borderWidth;

  const SliderStyle({
    required this.colorLeftOfHandle,
    required this.colorRightOfHandle,
    required this.borderColor,
    this.borderWidth = 0
  });
}