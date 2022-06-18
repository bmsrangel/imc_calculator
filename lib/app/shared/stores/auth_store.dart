import 'package:calculadora_imc/app/shared/dtos/storage_upload_dto.dart';
import 'package:calculadora_imc/app/shared/exceptions/storage_exception.dart';
import 'package:calculadora_imc/app/shared/models/image_file_model.dart';
import 'package:calculadora_imc/app/shared/repositories/storage/storage_repository.dart';
import 'package:flutter/material.dart';

import '../dtos/sign_up_dto.dart';
import '../exceptions/auth_exception.dart';
import '../models/user_model.dart';
import '../repositories/auth/auth_repository.dart';
import '../services/current_user/current_user_service.dart';
import '../services/image/image_service.dart';

enum ImageSource { camera, gallery }

class AuthStore extends ChangeNotifier {
  AuthStore(
    this._authRepository,
    this._userService,
    this._imageService,
    this._storageRepository,
  );

  final AuthRepository _authRepository;
  final CurrentUserService _userService;
  final ImageService _imageService;
  final StorageRepository _storageRepository;

  bool isLoading = false;
  UserModel? user;
  String? error;

  Future<void> getCurrentUser() async {
    user = await _userService.getCurrentUser();
  }

  Future<void> loginWithEmailPassword(String email, String password) async {
    try {
      error = null;
      isLoading = true;
      notifyListeners();
      user = await _authRepository.loginWithEmailPassword(email, password);
    } on AuthException catch (e) {
      error = e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUpWithEmailPassword(SignUpDTO userData) async {
    try {
      error = null;
      isLoading = true;
      notifyListeners();
      user = await _authRepository.signUpWithEmailPassword(userData);
    } on AuthException catch (e) {
      error = e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _authRepository.logout().then((_) {
      user = null;
      error = null;
    });
  }

  Future<void> setProfileImage(ImageSource source) async {
    ImageFileModel? imageFileModel;
    if (source == ImageSource.camera) {
      imageFileModel = await _imageService.getImageFromCamera();
    } else {
      imageFileModel = await _imageService.getImageFromGallery();
    }
    if (imageFileModel != null) {
      try {
        final uploadDTO = StorageUploadDTO(
          imageFileModel: imageFileModel,
          userId: user!.id,
        );
        final profileUrl = await _storageRepository.uploadImage(uploadDTO);
        await _authRepository.setProfileURL(profileUrl);
        user = user!.copyWith(profileUrl: profileUrl);
        notifyListeners();
      } on StorageException catch (e) {
        error = e.message;
      }
    }
  }
}
