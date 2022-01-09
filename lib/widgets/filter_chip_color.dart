import 'package:flutter/material.dart';

class FilterColor extends MaterialStateColor {
  const FilterColor() : super(_defaultColor);

  static const int _defaultColor = 0xff1A1A18;
  static const int _selectedColor = 0xffffffff;

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return const Color(_selectedColor);
    }
    return const Color(_defaultColor);
  }
}
