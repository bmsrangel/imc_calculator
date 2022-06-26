import 'package:calculadora_imc/app/modules/home/widgets/input_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TextEditingController controller;
  late GlobalKey<FormState> formKey;
  late Widget widget;

  setUp(
    () {
      controller = TextEditingController();
      formKey = GlobalKey<FormState>();
      widget = MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: InputCardWidget(
              controller: controller,
              title: 'Weight',
            ),
          ),
        ),
      );
    },
  );
  testWidgets(
    'InputCardWidget test',
    (tester) async {
      await tester.pumpWidget(widget);

      final formFieldFinder = find.byType(TextFormField);
      expect(formFieldFinder, findsOneWidget);
      await tester.enterText(formFieldFinder, '112');
      expect(controller.text, '112');
    },
  );

  testWidgets(
    'Testing error messages',
    (tester) async {
      await tester.pumpWidget(widget);

      final formFieldFinder = find.byType(TextFormField);
      expect(formFieldFinder, findsOneWidget);
      formKey.currentState!.validate();
      await tester.pumpAndSettle();
      var errorFinder = find.text('Campo obrigatório');
      expect(errorFinder, findsOneWidget);

      await tester.enterText(formFieldFinder, '112a');
      expect(controller.text, '112a');
      formKey.currentState!.validate();
      await tester.pumpAndSettle();
      errorFinder = find.text('Por favor, insira um número válido');
      expect(errorFinder, findsOneWidget);

      await tester.enterText(formFieldFinder, '-1');
      expect(controller.text, '-1');
      formKey.currentState!.validate();
      await tester.pumpAndSettle();
      errorFinder = find.text('O número precisa ser maior que zero');
      expect(errorFinder, findsOneWidget);
    },
  );
}
