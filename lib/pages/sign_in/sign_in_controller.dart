import 'package:fabrica_de_software/services/auth_service.dart';
import 'package:fabrica_de_software/services/secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:fabrica_de_software/pages/sign_in/sign_in_state.dart';

class SignInController extends ChangeNotifier {
  final AuthService _service;

  SignInState _state = SignInStateInitial();

  SignInController(this._service);

  SignInState get state => _state;

  void _changeState(SignInState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    const secureStorage = SecureStorage();
    _changeState(SignInStateLoading());

    try {
      final user = await _service.signIn(email: email, password: password);
      if (user.id != null) {
        await secureStorage.write(key: "CURRENT_USER", value: user.toJson());
        _changeState(SignInStateSucess());
      } else {
        throw Exception('Usuário não encontrado');
      }
    } catch (e) {
      _changeState(SignInStateError(message: e.toString()));
    }
  }
}
