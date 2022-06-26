import 'package:calculadora_imc/app/shared/models/image_file_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ImageFileModel imageFileModel;
  var path = '/documents/image.jpg';
  var mimeType = 'image/jpeg';

  setUpAll(() {
    imageFileModel = ImageFileModel(
      path: path,
      mimeType: mimeType,
    );
  });

  test(
    'imageFileModel should be an instance of ImageFileModel',
    () {
      expect(imageFileModel, isA<ImageFileModel>());
    },
  );

  test(
    'imageFileModel attributes must match ',
    () {
      expect(imageFileModel.path, path);
      expect(imageFileModel.mimeType, mimeType);
    },
  );
}
