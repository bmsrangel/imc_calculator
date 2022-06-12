import 'package:flutter/foundation.dart';

class ObscureTextStore extends ChangeNotifier {
  var obscureText = true;

  void toggleObscureText() {
    obscureText = !obscureText;
    notifyListeners();
  }
}
