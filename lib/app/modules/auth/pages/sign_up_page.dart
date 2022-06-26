import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:password_validators/password_validators.dart';
import 'package:validatorless/validatorless.dart';

import '../../../shared/dtos/sign_up_dto.dart';
import '../../../shared/stores/auth_store.dart';
import '../stores/obscure_text_store.dart';
import 'widgets/custom_text_form_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final TextEditingController _name$;
  late final TextEditingController _email$;
  late final TextEditingController _password$;
  late final TextEditingController _confirmPassword$;

  late final GlobalKey<FormState> _formKey;
  late final GlobalKey<ScaffoldMessengerState> _messengerKey;

  late final AuthStore _authStore;
  late final ObscureTextStore _passwordObscureTextStore;
  late final ObscureTextStore _confirmPasswordObscureTextStore;

  @override
  void initState() {
    _name$ = TextEditingController();
    _email$ = TextEditingController();
    _password$ = TextEditingController();
    _confirmPassword$ = TextEditingController();

    _formKey = GlobalKey<FormState>();
    _messengerKey = GlobalKey<ScaffoldMessengerState>();

    _authStore = Modular.get<AuthStore>();
    _passwordObscureTextStore = Modular.get<ObscureTextStore>();
    _confirmPasswordObscureTextStore = Modular.get<ObscureTextStore>();

    _authStore.addListener(_authStoreListener);
    super.initState();
  }

  @override
  void dispose() {
    _name$.dispose();
    _email$.dispose();
    _password$.dispose();
    _confirmPassword$.dispose();
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
          title: const Text('Criar Conta'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    labelText: 'Nome',
                    controller: _name$,
                    validator: Validatorless.required('Campo obrigatório'),
                  ),
                  const SizedBox(height: 10.0),
                  CustomTextFormField(
                    labelText: 'E-mail',
                    controller: _email$,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validatorless.multiple([
                      Validatorless.email('E-mail inválido'),
                      Validatorless.required('Campo obrigatório'),
                    ]),
                  ),
                  const SizedBox(height: 10.0),
                  AnimatedBuilder(
                    animation: _passwordObscureTextStore,
                    builder: (_, __) => CustomTextFormField(
                      labelText: 'Senha',
                      controller: _password$,
                      obscureText: _passwordObscureTextStore.obscureText,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordObscureTextStore.obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: _passwordObscureTextStore.toggleObscureText,
                      ),
                      validator: PasswordValidators.multipleValidators([
                        PasswordValidators.required('Campo obrigatório'),
                        PasswordValidators.minLength(
                          6,
                          'A senha precisa ter no mínimo 6 caracteres',
                        ),
                        PasswordValidators.containsNumberValidator(
                          'A senha precisa ter pelo menos um número',
                        ),
                        PasswordValidators.upperCaseCharacteresValidator(
                          'A senha precisa ter pelo menos uma letra maiúscula',
                        ),
                        PasswordValidators.lowerCaseCharacteresValidator(
                          'A senha precisa ter pelo menos uma letra minúscula',
                        ),
                        PasswordValidators.specialCharacteresValidator(
                          'A senha não possui caracteres especiais',
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  AnimatedBuilder(
                      animation: _confirmPasswordObscureTextStore,
                      builder: (_, __) => CustomTextFormField(
                            labelText: 'Confirmar Senha',
                            controller: _confirmPassword$,
                            obscureText:
                                _confirmPasswordObscureTextStore.obscureText,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _confirmPasswordObscureTextStore.obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: _confirmPasswordObscureTextStore
                                  .toggleObscureText,
                            ),
                            validator: PasswordValidators.multipleValidators([
                              PasswordValidators.required('Campo obrigatório'),
                              PasswordValidators.comparePasswords(
                                _password$,
                                'As senhas não coincidem',
                              ),
                            ]),
                          )),
                  const SizedBox(height: 30.0),
                  FractionallySizedBox(
                    widthFactor: .6,
                    child: ElevatedButton(
                      onPressed: () {
                        final isFormValid = _formKey.currentState!.validate();
                        if (isFormValid) {
                          final userData = SignUpDTO(
                            displayName: _name$.text,
                            email: _email$.text,
                            password: _password$.text,
                          );
                          _authStore.signUpWithEmailPassword(userData);
                        }
                      },
                      child: AnimatedBuilder(
                        animation: _authStore,
                        builder: (_, __) => _authStore.isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Criar conta'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
