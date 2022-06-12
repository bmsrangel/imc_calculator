import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:validatorless/validatorless.dart';

import '../../../shared/stores/auth_store.dart';
import '../stores/obscure_text_store.dart';
import 'widgets/custom_text_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthStore _authStore;
  late final ObscureTextStore _obscureTextStore;

  late final GlobalKey<FormState> _formKey;
  late final GlobalKey<ScaffoldMessengerState> _messengerKey;

  late final TextEditingController _email$;
  late final TextEditingController _password$;

  @override
  void initState() {
    _authStore = Modular.get<AuthStore>();
    _obscureTextStore = Modular.get<ObscureTextStore>();

    _formKey = GlobalKey<FormState>();
    _messengerKey = GlobalKey<ScaffoldMessengerState>();

    _email$ = TextEditingController();
    _password$ = TextEditingController();

    _authStore.addListener(_authStoreListener);
    super.initState();
  }

  @override
  void dispose() {
    _email$.dispose();
    _password$.dispose();
    _authStore.removeListener(_authStoreListener);
    super.dispose();
  }

  void _authStoreListener() {
    if (_authStore.error != null) {
      final errorSnackbar = SnackBar(
        content: Text(_authStore.error!),
        backgroundColor: Colors.red,
      );
      _messengerKey.currentState?.showSnackBar(errorSnackbar);
    }
    if (_authStore.user != null) {
      Modular.to.navigate('/calculator');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _messengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calculadora IMC'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  labelText: 'E-mail',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: _email$,
                  validator: Validatorless.multiple([
                    Validatorless.email('E-mail inválido'),
                    Validatorless.required('Campo obrigatório'),
                  ]),
                ),
                const SizedBox(height: 10.0),
                AnimatedBuilder(
                  animation: _obscureTextStore,
                  builder: (_, __) => CustomTextFormField(
                    labelText: 'Senha',
                    obscureText: _obscureTextStore.obscureText,
                    controller: _password$,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureTextStore.obscureText
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: _obscureTextStore.toggleObscureText,
                    ),
                    validator: Validatorless.multiple([
                      Validatorless.required('Campo obrigatório'),
                    ]),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Modular.to.pushNamed('./reset');
                    },
                    child: const Text(
                      'Esqueceu sua senha?',
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                FractionallySizedBox(
                  widthFactor: .7,
                  child: ElevatedButton(
                    onPressed: () {
                      final isFormValid = _formKey.currentState!.validate();
                      if (isFormValid) {
                        _authStore.loginWithEmailPassword(
                          _email$.text,
                          _password$.text,
                        );
                      }
                    },
                    child: AnimatedBuilder(
                      animation: _authStore,
                      builder: (_, __) => _authStore.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Entrar'),
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                const Text('Não possui conta?'),
                TextButton(
                  child: const Text('Crie a sua!'),
                  onPressed: () {
                    Modular.to.pushNamed('./signup');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
