import '../../dtos/storage_upload_dto.dart';

abstract class StorageRepository {
  Future<String> uploadImage(StorageUploadDTO uploadDto);
}
