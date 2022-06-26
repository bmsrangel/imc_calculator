import 'package:calculadora_imc/app/modules/home/widgets/greeting_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late String displayName;

  setUp(
    () {
      displayName = 'John Doe';
    },
  );

  testWidgets(
    'Morning GreetingWidget test',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GreetingWidget(
              currentDateTime: DateTime(2022, 06, 25, 08, 15),
              displayName: displayName,
            ),
          ),
        ),
      );

      final textFinder = find.text('Bom dia, John!');
      expect(textFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Afternoon GreetingWidget test',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GreetingWidget(
              currentDateTime: DateTime(2022, 06, 25, 14, 10),
              displayName: displayName,
            ),
          ),
        ),
      );

      final textFinder = find.text('Boa tarde, John!');
      expect(textFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Night GreetingWidget test',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GreetingWidget(
              currentDateTime: DateTime(2022, 06, 25, 18),
              displayName: displayName,
            ),
          ),
        ),
      );

      final textFinder = find.text('Boa noite, John!');
      expect(textFinder, findsOneWidget);
    },
  );
}
