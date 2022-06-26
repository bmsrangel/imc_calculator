import 'package:calculadora_imc/app/modules/auth/pages/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'Testing CustomTextFormField',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextFormField(
              labelText: 'Test',
            ),
          ),
        ),
      );
      final finder = find.byType(CustomTextFormField);
      expect(finder, findsOneWidget);
    },
  );
}
