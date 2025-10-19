import 'package:fabrica_de_software/common/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../mock/mock_firebase_auth_service.dart';

void main() {
  late MockFirebaseAuthService mockFirebaseAuthService;
  late UserModel user;

  setUp(() {
    mockFirebaseAuthService = MockFirebaseAuthService();
    user = UserModel(id: '1234567Ab', name: 'USER', email: 'teste@gmail.com');
  });
  group('Test sing up', () {
    test('Test sign up fail', () async {
      when(
        () => mockFirebaseAuthService.signUp(
          name: 'USER',
          email: 'user@gmail.com',
          password: 'User123456',
        ),
      ).thenThrow(Exception());

      expect(
        () => mockFirebaseAuthService.signUp(
          name: 'USER',
          email: 'user@gmail.com',
          password: 'User123456',
        ),
        throwsException,
      );
    });
    test('Test sign up sucess', () async {
      when(
        () => mockFirebaseAuthService.signUp(
          name: 'USER',
          email: 'user@gmail.com',
          password: 'User123456',
        ),
      ).thenAnswer((_) async => user);

      final result = await mockFirebaseAuthService.signUp(
        name: 'USER',
        email: 'user@gmail.com',
        password: 'User123456',
      );
      expect(result, user);
    });
  });
}
