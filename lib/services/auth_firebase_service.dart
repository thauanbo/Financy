import 'package:fabrica_de_software/common/models/user_model.dart';
import 'package:fabrica_de_software/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebaseService implements AuthService {
  final _auth = FirebaseAuth.instance;

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        return UserModel(
          id: result.user!.uid,
          name: result.user!.displayName,
          email: result.user!.email,
        );
      } else {
        throw Exception();
      }
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "null";
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> signUp({
    String? name,
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        result.user!.updateDisplayName(name);
        return UserModel(
          id: result.user!.uid,
          name: result.user!.displayName,
          email: result.user!.email,
        );
      } else {
        throw Exception();
      }
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "null";
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> signOut() async {
    try {
      await _auth.signOut();
      return UserModel(id: '', name: '', email: '');
    } catch (e) {
      rethrow;
    }
  }
}
