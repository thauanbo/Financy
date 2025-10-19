import 'package:fabrica_de_software/pages/sign_in/sign_in_controller.dart';
import 'package:fabrica_de_software/pages/sign_up/sign_up_controller.dart';
import 'package:fabrica_de_software/services/auth_firebase_service.dart';
import 'package:fabrica_de_software/services/auth_service.dart';
import 'package:fabrica_de_software/services/budget_firestore_service.dart';
import 'package:fabrica_de_software/services/budget_pdf_service.dart';
import 'package:fabrica_de_software/services/client_firestore_service.dart';
import 'package:fabrica_de_software/services/language_service.dart';
import 'package:fabrica_de_software/services/secure_storage.dart';
import 'package:fabrica_de_software/services/user_profile_service.dart';
import 'package:fabrica_de_software/splash/splash_controller.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupDependencies() {
  // Serviços principais
  locator.registerSingleton<AuthService>(AuthFirebaseService());
  locator.registerSingleton<ClientFirestoreService>(ClientFirestoreService());
  locator.registerSingleton<BudgetFirestoreService>(BudgetFirestoreService());
  locator.registerSingleton<BudgetPdfService>(BudgetPdfService());
  locator.registerSingleton<UserProfileService>(UserProfileService());
  locator.registerSingleton<LanguageService>(LanguageService());

  // Controllers
  locator.registerFactory<SplashController>(
    () => SplashController(const SecureStorage()),
  );

  locator.registerFactory<SignInController>(
    () => SignInController(locator.get<AuthService>()),
  );

  locator.registerFactory<SignUpController>(
    () => SignUpController(locator.get<AuthService>(), const SecureStorage()),
  );
}
