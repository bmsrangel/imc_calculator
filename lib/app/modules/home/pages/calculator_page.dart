import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../stores/bmi_store.dart';
import '../stores/history_store.dart';
import '../widgets/input_card_widget.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  late final BMIStore _bmiStore;
  late final HistoryStore _historyStore;

  late final TextEditingController _weight$;
  late final TextEditingController _height$;

  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _bmiStore = Modular.get<BMIStore>();
    _historyStore = Modular.get<HistoryStore>();

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
      _historyStore.registerMeasurement(_bmiStore.result!);
      Modular.to.pushNamed('./results').then((_) {
        _bmiStore.result = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: Text(widget.title),
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InputCardWidget(
                    title: 'Peso (em kg)',
                    controller: _weight$,
                    textInputAction: TextInputAction.next,
                  ),
                  InputCardWidget(
                    title: 'Altura (em m)',
                    controller: _height$,
                  ),
                ],
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
    );
  }
}
