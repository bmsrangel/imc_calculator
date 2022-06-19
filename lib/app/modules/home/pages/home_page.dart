import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/stores/auth_store.dart';
import '../stores/weather_store.dart';
import '../widgets/greeting_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AuthStore _authStore;
  late final WeatherStore _weatherStore;

  var pageIndex = 0;

  @override
  void initState() {
    _authStore = Modular.get<AuthStore>();
    _weatherStore = Modular.get<WeatherStore>();
    _weatherStore.getCurrentTemperature();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GreetingWidget(
          currentDateTime: DateTime.now(),
          displayName: _authStore.user!.displayName,
        ),
        centerTitle: false,
        actions: [
          LayoutBuilder(builder: (context, constraints) {
            return Container(
              padding: const EdgeInsets.only(right: 16.0),
              width: constraints.maxHeight + 10,
              alignment: Alignment.centerRight,
              child: AnimatedBuilder(
                animation: _weatherStore,
                builder: (_, __) {
                  if (_weatherStore.isLoading) {
                    return const LinearProgressIndicator();
                  } else if (_weatherStore.currentTemperature == null ||
                      _weatherStore.error != null) {
                    return const Text('-');
                  } else {
                    return Text(
                      '${_weatherStore.currentTemperature!.toStringAsFixed(1)}°C',
                    );
                  }
                },
              ),
            );
          }),
        ],
      ),
      body: const RouterOutlet(),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Calculadora',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              Modular.to.navigate('/calculator');
              break;
            case 1:
              Modular.to.navigate('/history');
              break;
            case 2:
              Modular.to.navigate('/profile');
              break;
          }
          setState(() {
            pageIndex = index;
          });
        },
        selectedIndex: pageIndex,
      ),
    );
  }
}
