import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../stores/bmi_store.dart';
import '../widgets/attribute_value_widget.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({Key? key}) : super(key: key);

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final BMIStore _bmiStore;
  late final Animation<double> _bmiAnimation;
  late final Animation<double> _weightAnimation;
  late final Animation<double> _heightAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _bmiStore = Modular.get<BMIStore>();
    _bmiAnimation =
        Tween<double>(begin: 0.0, end: _bmiStore.result!.bmi).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCirc,
      ),
    );
    _weightAnimation =
        Tween<double>(begin: 0.0, end: _bmiStore.result!.weight).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCirc,
      ),
    );
    _heightAnimation =
        Tween<double>(begin: 0.0, end: _bmiStore.result!.height).animate(
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
              animation: _bmiAnimation,
              builder: (context, child) {
                return LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  lineHeight: 30.0,
                  percent: _bmiAnimation.value / 40,
                  progressColor: getProgressColor(_bmiAnimation.value),
                  center: Text(
                    _bmiAnimation.value.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  barRadius: const Radius.circular(10.0),
                );
              },
            ),
            const SizedBox(height: 20.0),
            Card(
              margin: EdgeInsets.zero,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AnimatedBuilder(
                      animation: _weightAnimation,
                      builder: (context, child) {
                        return AttributeValueWidget(
                          attribute: 'Peso',
                          value: _weightAnimation.value,
                        );
                      },
                    ),
                    Container(
                      width: 2.0,
                      height: 20.0,
                      color: Colors.grey[400],
                    ),
                    AnimatedBuilder(
                      animation: _heightAnimation,
                      builder: (context, child) {
                        return AttributeValueWidget(
                          attribute: 'Altura',
                          value: _heightAnimation.value,
                          resolution: 2,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Classificação: ${_bmiStore.result!.classification}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
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
