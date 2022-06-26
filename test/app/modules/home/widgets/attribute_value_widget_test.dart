import 'package:calculadora_imc/app/modules/home/widgets/attribute_value_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'AttributeValueWidget test',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AttributeValueWidget(
              attribute: 'Weight',
              value: 112.0,
              resolution: 2,
              key: Key('weight_attribute_value_widget'),
            ),
          ),
        ),
      );

      final valueFinder = find.text('112.00');
      expect(valueFinder, findsOneWidget);
      final attributeFinder = find.text('Weight');
      expect(attributeFinder, findsOneWidget);
    },
  );
}
