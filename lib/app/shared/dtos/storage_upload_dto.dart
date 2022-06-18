import 'package:calculadora_imc/app/shared/models/image_file_model.dart';

class StorageUploadDTO {
  StorageUploadDTO({
    required this.imageFileModel,
    required this.userId,
  });

  final ImageFileModel imageFileModel;
  final String userId;
}
