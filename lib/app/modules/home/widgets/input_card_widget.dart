import 'package:calculadora_imc/app/modules/home/validators/custom_validators.dart';
import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

class InputCardWidget extends StatelessWidget {
  const InputCardWidget({
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);

  final String title;
  final TextEditingController controller;

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
                validator: Validatorless.multiple([
                  Validatorless.required('Campo obrigatório'),
                  Validatorless.number('Por favor, insira um número válido'),
                  CustomValidators.greaterThanZero(
                    'O número precisa ser maior que zero',
                  )
                ]),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
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
