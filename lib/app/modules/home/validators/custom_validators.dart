import 'package:flutter/material.dart';

class CustomValidators {
  CustomValidators._();

  static FormFieldValidator greaterThanZero(
    String message,
  ) {
    return (value) {
      final number = double.parse(value);
      if (number > 0) {
        return null;
      } else {
        return message;
      }
    };
  }
}
