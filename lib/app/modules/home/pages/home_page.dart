import 'package:calculadora_imc/app/modules/home/widgets/greeting_widget.dart';
import 'package:calculadora_imc/app/shared/stores/auth_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AuthStore _authStore;

  var pageIndex = 0;

  @override
  void initState() {
    _authStore = Modular.get<AuthStore>();
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
