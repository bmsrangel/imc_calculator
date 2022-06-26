import 'package:calculadora_imc/app/shared/stores/auth_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:validatorless/validatorless.dart';

import 'widgets/custom_text_form_field.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late final AuthStore _authStore;

  late final TextEditingController _email$;
  late final GlobalKey<FormState> _formKey;
  late final GlobalKey<ScaffoldMessengerState> _messengerKey;

  @override
  void initState() {
    _authStore = Modular.get<AuthStore>();
    _email$ = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _messengerKey = GlobalKey<ScaffoldMessengerState>();
    _authStore.addListener(_authStoreListener);
    super.initState();
  }

  @override
  void dispose() {
    _authStore.removeListener(_authStoreListener);
    super.dispose();
  }

  void _authStoreListener() {
    if (_authStore.isLoading) {
      context.loaderOverlay.show();
    } else {
      if (context.loaderOverlay.visible) {
        context.loaderOverlay.hide();
      }
      if (_authStore.error != null) {
        final snackBar = SnackBar(
          content: Text(_authStore.error!),
          backgroundColor: Colors.red,
        );
        _messengerKey.currentState?.showSnackBar(snackBar);
      } else {
        Modular.to.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: ScaffoldMessenger(
        key: _messengerKey,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Recuperar Senha'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      labelText: 'E-mail',
                      keyboardType: TextInputType.emailAddress,
                      controller: _email$,
                      validator: Validatorless.multiple([
                        Validatorless.required('Campo obrigatório'),
                        Validatorless.email('E-mail inválido'),
                      ]),
                    ),
                    const SizedBox(height: 30.0),
                    FractionallySizedBox(
                      widthFactor: .7,
                      child: ElevatedButton(
                        onPressed: () {
                          final isFormValid = _formKey.currentState?.validate();
                          if (isFormValid != null && isFormValid) {
                            _authStore.resetPassword(_email$.text);
                          }
                        },
                        child: const Text('Recuperar Senha'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
