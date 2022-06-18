import 'dart:io';

import 'package:calculadora_imc/app/shared/dtos/storage_upload_dto.dart';
import 'package:calculadora_imc/app/shared/exceptions/storage_exception.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'storage_repository.dart';

class FirebaseStorageRepositoryImpl implements StorageRepository {
  FirebaseStorageRepositoryImpl(this._storage);

  final FirebaseStorage _storage;

  @override
  Future<String> uploadImage(StorageUploadDTO uploadDto) async {
    try {
      final storageReference = _storage.ref();
      final newFileName = DateTime.now().millisecondsSinceEpoch.toString();
      final fileExtension = _getFileExtension(uploadDto.imageFileModel.path);
      final newFileNameWithExtension = '$newFileName.$fileExtension';
      final imageReference = storageReference.child(
        '${uploadDto.userId}/$newFileNameWithExtension',
      );
      final imageFile = File(uploadDto.imageFileModel.path);
      final uploadTask = await imageReference.putFile(
        imageFile,
        SettableMetadata(
          contentType: uploadDto.imageFileModel.mimeType,
        ),
      );
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw StorageException(e.message.toString());
    }
  }

  String _getFileExtension(String filePath) {
    final splittedPath = filePath.split('.');
    final fileExtension = splittedPath.last;
    return fileExtension;
  }
}
