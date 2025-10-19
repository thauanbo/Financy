import 'package:fabrica_de_software/common/models/user_model.dart';
import 'package:fabrica_de_software/services/auth_service.dart';

class MockAuthService implements AuthService {
  @override
  Future<UserModel> signOut() async {
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(id: 'mockId', email: 'mockEmail@example.com');
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      if (password.startsWith('123')) {
        throw Exception();
      }
      return UserModel(id: email.hashCode.toString(), email: email);
    } catch (e) {
      if (password.startsWith('123')) {
        throw 'A senha não pode começar com 123';
      }
      throw 'Ops! Algo deu errado!';
    }
  }

  @override
  Future<UserModel> signUp({
    String? name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      if (password.startsWith('123')) {
        throw Exception();
      }
      return UserModel(id: email.hashCode.toString(), name: name, email: email);
    } catch (e) {
      if (password.startsWith('123')) {
        throw 'A senha não pode começar com 123';
      }
      throw 'Ops! Algo deu errado!';
    }
  }
}
