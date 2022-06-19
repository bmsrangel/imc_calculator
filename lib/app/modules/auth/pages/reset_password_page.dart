import 'package:flutter/material.dart';

import 'widgets/custom_text_form_field.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Senha'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomTextFormField(
                labelText: 'E-mail',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 30.0),
              FractionallySizedBox(
                widthFactor: .7,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Recuperar Senha'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
