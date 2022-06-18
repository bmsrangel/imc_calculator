import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
import 'shared/stores/auth_store.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    AsyncBind<SharedPreferences>((i) => SharedPreferences.getInstance()),
    Bind.lazySingleton<AuthRepository>(
      (i) => FirebaseAuthRepositoryImpl(FirebaseAuth.instance),
    ),
    Bind.lazySingleton<CurrentUserService>(
      (i) => FirebaseAuthCurrentUserServiceImpl(FirebaseAuth.instance),
    ),
    Bind.lazySingleton((i) => ImagePicker()),
    Bind.lazySingleton<ImageService>(
      (i) => ImagePickerImageServiceImpl(i<ImagePicker>()),
    ),
    Bind.lazySingleton<StorageRepository>(
      (i) => FirebaseStorageRepositoryImpl(FirebaseStorage.instance),
    ),
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
