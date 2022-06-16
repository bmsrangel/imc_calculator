import 'package:flutter/material.dart';

class CustomValidators {
  CustomValidators._();

  static FormFieldValidator greaterThanZero(
    String message,
  ) {
    return (value) {
      final number = double.parse(value.trim().replaceAll(',', '.'));
      if (number > 0) {
        return null;
      } else {
        return message;
      }
    };
  }

  static FormFieldValidator<String> number(String m) {
    return (v) {
      if (v?.isEmpty ?? true) return null;
      if (double.tryParse(v!.trim().replaceAll(',', '.')) != null) {
        return null;
      } else {
        return m;
      }
    };
  }
}
