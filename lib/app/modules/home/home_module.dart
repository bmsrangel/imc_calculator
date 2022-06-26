import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/services/location/location_service.dart';
import 'guards/auth_guard.dart';
import 'guards/location_guard.dart';
import 'guards/module_ready_guard.dart';
import 'pages/calculator_page.dart';
import 'pages/history_page.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/results_page.dart';
import 'repositories/weather/dio_weather_repository_impl.dart';
import 'repositories/weather/weather_repository.dart';
import 'services/history_local_storage/history_local_storage_service.dart';
import 'services/history_local_storage/shared_preferences_history_storage_service_impl.dart';
import 'stores/bmi_store.dart';
import 'stores/history_store.dart';
import 'stores/weather_store.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    // External Packages Register
    Bind.lazySingleton<Dio>(
      (i) => Dio(
        BaseOptions(
          baseUrl: 'https://api.open-meteo.com/v1/',
        ),
      ),
    ),

    // Repositories Register
    Bind.lazySingleton<WeatherRepository>(
      (i) => DioWeatherRepositoryImpl(i<Dio>()),
    ),

    // Services Register
    Bind.lazySingleton<HistoryLocalStorageService>(
      (i) => SharedPreferencesHistoryStorageServiceImpl(
        i<SharedPreferences>(),
      ),
    ),

    // Stores Register
    Bind.lazySingleton<BMIStore>((i) => BMIStore()),
    Bind.lazySingleton<HistoryStore>(
      (i) => HistoryStore(
        i<HistoryLocalStorageService>(),
      ),
      onDispose: (store) => store.dispose(),
    ),
    Bind.lazySingleton<WeatherStore>(
      (i) => WeatherStore(
        i<WeatherRepository>(),
        i<LocationService>(),
      ),
      onDispose: (store) => store.dispose(),
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
            LocationGuard(),
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
