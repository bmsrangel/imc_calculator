import 'package:calculadora_imc/app/modules/home/stores/bmi_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/stores/auth_store.dart';
import '../widgets/input_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AuthStore _authStore;
  late final BMIStore _bmiStore;

  late final TextEditingController _weight$;
  late final TextEditingController _height$;

  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _authStore = Modular.get<AuthStore>();
    _bmiStore = Modular.get<BMIStore>();

    _bmiStore.addListener(_resultListener);

    _weight$ = TextEditingController();
    _height$ = TextEditingController();

    _formKey = GlobalKey<FormState>();

    super.initState();
  }

  @override
  void dispose() {
    _weight$.dispose();
    _height$.dispose();

    _bmiStore.removeListener(_resultListener);
    super.dispose();
  }

  void _resultListener() {
    if (_bmiStore.result != null) {
      Modular.to.pushNamed('./results').then((_) {
        _bmiStore.result = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var appBar = AppBar(
      title: Text(widget.title),
      actions: [
        IconButton(
          onPressed: () {
            _authStore.logout();
            Modular.to.navigate('/auth/');
          },
          icon: const Icon(Icons.exit_to_app),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: screenSize.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: InputCardWidget(
                          title: 'Peso (em kg)',
                          controller: _weight$,
                        ),
                      ),
                      Expanded(
                        child: InputCardWidget(
                          title: 'Altura (em m)',
                          controller: _height$,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50.0),
              ElevatedButton(
                onPressed: () {
                  final isFormValid = _formKey.currentState!.validate();
                  if (isFormValid) {
                    _bmiStore.calculateBMI(_weight$.text, _height$.text);
                  }
                },
                child: const Text('Calcular'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
