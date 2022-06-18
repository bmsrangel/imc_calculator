import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'guards/auth_guard.dart';
import 'guards/module_ready_guard.dart';
import 'pages/calculator_page.dart';
import 'pages/history_page.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/results_page.dart';
import 'services/history_local_storage/history_local_storage_service.dart';
import 'services/history_local_storage/shared_preferences_history_storage_service_impl.dart';
import 'stores/bmi_store.dart';
import 'stores/history_store.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
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
          guards: [
            AuthGuard(),
            ModuleReadyGuard(),
          ],
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
