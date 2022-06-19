import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modules/auth/auth_module.dart';
import 'modules/home/home_module.dart';
import 'shared/repositories/auth/auth_repository.dart';
import 'shared/repositories/auth/firebase_auth_repository_impl.dart';
import 'shared/repositories/storage/firebase_storage_repository_impl.dart';
import 'shared/repositories/storage/storage_repository.dart';
import 'shared/services/current_user/current_user_service.dart';
import 'shared/services/current_user/firebase_auth_current_user_service_impl.dart';
import 'shared/services/image/image_picker_image_service_impl.dart';
import 'shared/services/image/image_service.dart';
import 'shared/services/location/geolocator_location_service_impl.dart';
import 'shared/services/location/location_service.dart';
import 'shared/stores/auth_store.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    // External Packages Registers
    AsyncBind<SharedPreferences>((i) => SharedPreferences.getInstance()),
    Bind.lazySingleton((i) => ImagePicker()),
    Bind.singleton((i) => FirebaseAuth.instance),
    Bind.singleton((i) => FirebaseStorage.instance),
    Bind.lazySingleton((i) => GeolocatorPlatform.instance),

    // Repositories Registers
    Bind.lazySingleton<AuthRepository>(
      (i) => FirebaseAuthRepositoryImpl(i<FirebaseAuth>()),
    ),
    Bind.lazySingleton<StorageRepository>(
      (i) => FirebaseStorageRepositoryImpl(i<FirebaseStorage>()),
    ),

    // Services Registers
    Bind.lazySingleton<CurrentUserService>(
      (i) => FirebaseAuthCurrentUserServiceImpl(i<FirebaseAuth>()),
    ),
    Bind.lazySingleton<ImageService>(
      (i) => ImagePickerImageServiceImpl(i<ImagePicker>()),
    ),
    Bind.lazySingleton<LocationService>(
      (i) => GeolocatorLocationServiceImpl(i<GeolocatorPlatform>()),
    ),

    // Stores Registers
    Bind.lazySingleton(
      (i) => AuthStore(
        i<AuthRepository>(),
        i<CurrentUserService>(),
        i<ImageService>(),
        i<StorageRepository>(),
      ),
    ),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: HomeModule()),
    ModuleRoute('/auth', module: AuthModule()),
  ];
}
