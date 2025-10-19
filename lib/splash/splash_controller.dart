import 'package:fabrica_de_software/services/secure_storage.dart';
import 'package:fabrica_de_software/splash/splash_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashController extends ChangeNotifier {
  final SecureStorage _service;
  SplashController(this._service);

  SplashState _state = SplashStateInitial();

  SplashState get state => _state;

  void _changeState(SplashState newState) {
    _state = newState;
    notifyListeners();
  }

  void isUserLogged() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Verificar se há usuário autenticado no Firebase
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Usuário está autenticado no Firebase
        // Verificar se também há dados no storage local
        final storageResult = await _service.readAll(key: "CURRENT_USER");

        if (storageResult.isNotEmpty) {
          _changeState(SplashStateSucess());
        } else {
          // Firebase tem usuário, mas storage está vazio - limpar e ir para login
          await FirebaseAuth.instance.signOut();
          _changeState(SplashStateError());
        }
      } else {
        // Não há usuário autenticado no Firebase
        // Limpar qualquer dado residual do storage
        await _service.deleteOne(key: "CURRENT_USER");
        _changeState(SplashStateError());
      }
    } catch (e) {
      // Em caso de erro, limpar dados e ir para login
      await _service.deleteOne(key: "CURRENT_USER");
      await FirebaseAuth.instance.signOut();
      _changeState(SplashStateError());
    }
  }
}
