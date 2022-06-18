import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import '../stores/history_store.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final HistoryStore _historyStore;
  late final DateFormat _brazilianDateFormat;

  @override
  void initState() {
    _historyStore = Modular.get<HistoryStore>();
    _historyStore.getHistoricMeasurements();
    _brazilianDateFormat = DateFormat('dd/MM/yy');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _historyStore,
          builder: (_, __) {
            if (_historyStore.isLoading) {
              return const CircularProgressIndicator();
            } else if (_historyStore.error != null) {
              return Text(_historyStore.error!);
            } else {
              if (_historyStore.measurements.isEmpty) {
                return const Text('Nenhum registro adicionado.');
              } else {
                return ListView.separated(
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: _historyStore.measurements.length,
                  itemBuilder: (context, index) {
                    final measurement = _historyStore.measurements[index];
                    return ListTile(
                      title: Text(
                        'IMC: ${measurement.bmi.toStringAsFixed(1)} (${measurement.classification})',
                      ),
                      subtitle: Text(
                        'Peso: ${measurement.weight.toStringAsFixed(1)}kg | Altura: ${measurement.height.toStringAsFixed(2)}m',
                      ),
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _brazilianDateFormat.format(
                              measurement.measurementDate,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}
