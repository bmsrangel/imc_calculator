import 'package:flutter/material.dart';

class CustomValidators {
  CustomValidators._();

  static FormFieldValidator specialCharacteresValidator(
    String message,
  ) {
    return (value) {
      final specialCharacteresRegex = RegExp(r'[!@#$]');
      if (specialCharacteresRegex.hasMatch(value)) {
        return null;
      } else {
        return message;
      }
    };
  }

  static FormFieldValidator upperCaseCharacteresValidator(
    String message,
  ) {
    return (value) {
      final upperCaseCharacteresRegex = RegExp(r'[A-Z]');
      if (upperCaseCharacteresRegex.hasMatch(value)) {
        return null;
      } else {
        return message;
      }
    };
  }

  static FormFieldValidator lowerCaseCharacteresValidator(
    String message,
  ) {
    return (value) {
      final lowerCaseCharacteresRegex = RegExp(r'[a-z]');
      if (lowerCaseCharacteresRegex.hasMatch(value)) {
        return null;
      } else {
        return message;
      }
    };
  }

  static FormFieldValidator containsNumberValidator(
    String message,
  ) {
    return (value) {
      final containsNumberRegex = RegExp(r'[0-9]');
      if (containsNumberRegex.hasMatch(value)) {
        return null;
      } else {
        return message;
      }
    };
  }
}
