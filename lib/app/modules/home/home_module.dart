import 'package:calculadora_imc/app/modules/home/guards/module_ready_guard.dart';
import 'package:calculadora_imc/app/modules/home/pages/calculator_page.dart';
import 'package:calculadora_imc/app/modules/home/pages/history_page.dart';
import 'package:calculadora_imc/app/modules/home/pages/profile_page.dart';
import 'package:calculadora_imc/app/modules/home/pages/results_page.dart';
import 'package:calculadora_imc/app/modules/home/services/history_local_storage_service.dart';
import 'package:calculadora_imc/app/modules/home/services/shared_preferences_history_storage_service_impl.dart';
import 'package:calculadora_imc/app/modules/home/stores/bmi_store.dart';
import 'package:calculadora_imc/app/modules/home/stores/history_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'guards/auth_guard.dart';
import 'pages/home_page.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    AsyncBind<SharedPreferences>((i) => SharedPreferences.getInstance()),
    Bind.lazySingleton<HistoryLocalStorageService>(
      (i) => SharedPreferencesHistoryStorageServiceImpl(
        i<SharedPreferences>(),
      ),
    ),
    Bind.lazySingleton((i) => BMIStore()),
    Bind.lazySingleton(
      (i) => HistoryStore(
        i<HistoryLocalStorageService>(),
      ),
    ),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      Modular.initialRoute,
      child: (_, __) => const HomePage(title: 'Calculadora IMC'),
      guards: [
        AuthGuard(),
        ModuleReadyGuard(),
      ],
      children: [
        ChildRoute(
          '/calculator',
          child: (_, __) => const CalculatorPage(title: 'Calculadora IMC'),
        ),
        ChildRoute(
          '/history',
          child: (_, __) => const HistoryPage(),
        ),
        ChildRoute(
          '/profile',
          child: (_, __) => const ProfilePage(),
        ),
      ],
    ),
    ChildRoute('/results', child: (_, __) => const ResultsPage()),
  ];
}
