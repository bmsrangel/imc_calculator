import 'package:calculadora_imc/app/modules/home/repositories/weather/weather_repository.dart';
import 'package:calculadora_imc/app/modules/home/services/history_local_storage/history_local_storage_service.dart';
import 'package:calculadora_imc/app/modules/home/stores/bmi_store.dart';
import 'package:calculadora_imc/app/shared/repositories/auth/auth_repository.dart';
import 'package:calculadora_imc/app/shared/repositories/storage/storage_repository.dart';
import 'package:calculadora_imc/app/shared/services/current_user/current_user_service.dart';
import 'package:calculadora_imc/app/shared/services/image/image_service.dart';
import 'package:calculadora_imc/app/shared/services/location/location_service.dart';
import 'package:calculadora_imc/app/shared/stores/auth_store.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockImagePicker extends Mock implements ImagePicker {}

class MockGeolocatorPlatform extends Mock implements GeolocatorPlatform {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockStorageRepository extends Mock implements StorageRepository {}

class MockCurrentUserService extends Mock implements CurrentUserService {}

class MockImageService extends Mock implements ImageService {}

class MockLocationService extends Mock implements LocationService {}

class MockDio extends Mock implements Dio {}

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockHistoryLocalStorageService extends Mock
    implements HistoryLocalStorageService {}

class MockAuthStore extends Mock implements AuthStore {}

class MockBMIStore extends Mock implements BMIStore {}
