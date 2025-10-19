import 'package:fabrica_de_software/pages/sign_up/sign_up_state.dart';
import 'package:fabrica_de_software/services/auth_service.dart';
import 'package:fabrica_de_software/services/secure_storage.dart';
import 'package:flutter/foundation.dart';

class SignUpController extends ChangeNotifier {
  final AuthService _service;
  final SecureStorage _secureStorage;

  SignUpController(this._service, this._secureStorage);

  SignUpState _state = SignUpInitialState();

  SignUpState get getState => _state;

  void _changeState(SignUpState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> signUp(String name, String email, String password) async {
    _changeState(SignUpLoadingState());
    try {
      final user = await _service.signUp(
        name: name,
        email: email,
        password: password,
      );
      if (user.id != null) {
        await _secureStorage.write(key: "CURRENT_USER", value: user.toJson());
        _changeState(SignUpSuccessState());
      } else {
        throw Exception();
      }
    } catch (e) {
      _changeState(SignUpErrorState(message: e.toString()));
    }
  }
}
