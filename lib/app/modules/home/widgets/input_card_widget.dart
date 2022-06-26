import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

import '../validators/custom_validators.dart';

class InputCardWidget extends StatelessWidget {
  const InputCardWidget({
    Key? key,
    required this.title,
    required this.controller,
    this.textInputAction,
    this.focusNode,
  }) : super(key: key);

  final String title;
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                textAlign: TextAlign.center,
                controller: controller,
                focusNode: focusNode,
                validator: Validatorless.multiple([
                  Validatorless.required('Campo obrigatório'),
                  CustomValidators.number('Por favor, insira um número válido'),
                  CustomValidators.greaterThanZero(
                    'O número precisa ser maior que zero',
                  )
                ]),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: textInputAction,
              ),
              const SizedBox(height: 10.0),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
