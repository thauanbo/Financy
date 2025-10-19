import 'package:fabrica_de_software/pages/sign_up/sign_up_controller.dart';
import 'package:fabrica_de_software/services/auth_service.dart';
import 'package:fabrica_de_software/services/secure_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuthService extends Mock implements AuthService {}

class MockSecureStorage extends Mock implements SecureStorage {}

class MockSignUpController extends Mock implements SignUpController {}
