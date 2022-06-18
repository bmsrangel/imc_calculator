import 'package:flutter/material.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({
    Key? key,
    required this.displayName,
    required this.currentDateTime,
  }) : super(key: key);

  final String displayName;
  final DateTime currentDateTime;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_generateGreeting(currentDateTime)}, ${_extractFirstName(displayName)}!',
    );
  }

  String _generateGreeting(DateTime dateTime) {
    final currentHour = dateTime.hour;
    if (currentHour >= 0 && currentHour < 12) {
      return 'Bom dia';
    } else if (currentHour < 18) {
      return 'Boa tarde';
    } else {
      return 'Boa noite';
    }
  }

  String _extractFirstName(String displayName) {
    final splittedDisplayName = displayName.split(' ');
    final firstName = splittedDisplayName.first;
    return firstName;
  }
}
