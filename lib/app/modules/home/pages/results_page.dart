import 'package:calculadora_imc/app/modules/home/stores/bmi_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({Key? key}) : super(key: key);

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final BMIStore _bmiStore;
  late final Animation<double> _resultAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _bmiStore = Modular.get<BMIStore>();
    _resultAnimation =
        Tween<double>(begin: 0.0, end: _bmiStore.result!.bmi).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCirc,
      ),
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Seu IMC é:',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 15.0),
            AnimatedBuilder(
                animation: _resultAnimation,
                builder: (context, child) {
                  return LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    lineHeight: 30.0,
                    percent: _resultAnimation.value / 40,
                    progressColor: getProgressColor(_resultAnimation.value),
                    center: Text(
                      _resultAnimation.value.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    barRadius: const Radius.circular(10.0),
                  );
                }),
            const SizedBox(height: 15.0),
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.grey[400]!,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 0.0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AttributeValueWidget(
                      attribute: 'Peso',
                      value: _bmiStore.result!.weight,
                    ),
                    Container(
                      width: 2.0,
                      height: 20.0,
                      color: Colors.grey[400],
                    ),
                    AttributeValueWidget(
                      attribute: 'Altura',
                      value: _bmiStore.result!.height,
                    ),
                  ],
                ),
              ),
            ),
            Text(
              'Classificação: ${_bmiStore.result!.classification}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Color getProgressColor(double value) {
    if (value < 18.5) {
      return Colors.yellow;
    } else if (value < 24.9) {
      return Colors.green;
    } else if (value < 29.9) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}

class AttributeValueWidget extends StatelessWidget {
  const AttributeValueWidget({
    Key? key,
    required this.attribute,
    required this.value,
  }) : super(key: key);

  final String attribute;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toStringAsFixed(1),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 28.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          attribute,
        ),
      ],
    );
  }
}
