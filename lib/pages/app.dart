import 'package:fabrica_de_software/common/constants/routes.dart';
import 'package:fabrica_de_software/pages/clients/clients_page_firestore.dart';
import 'package:fabrica_de_software/pages/clients/client_profile_page.dart';
import 'package:fabrica_de_software/pages/forgot_password/check_email_page.dart';
import 'package:fabrica_de_software/pages/forgot_password/forgot_password_page.dart';
import 'package:fabrica_de_software/pages/main_navigation_page.dart';
import 'package:fabrica_de_software/pages/onboarding/onboarding_pag.dart';
import 'package:fabrica_de_software/pages/profile/profile_page.dart';
import 'package:fabrica_de_software/pages/sign_in/sign_in_page.dart';
import 'package:fabrica_de_software/pages/sign_up/sign_up_page.dart';
import 'package:fabrica_de_software/pages/statistics/statistics_page.dart';
import 'package:fabrica_de_software/pages/workflow/workflow_page.dart';
import 'package:fabrica_de_software/pages/settings/language_settings_page.dart';
import 'package:fabrica_de_software/pages/pdfs/saved_pdfs_page.dart';
import 'package:fabrica_de_software/splash/splash_page.dart';
import 'package:fabrica_de_software/themes/default_theme.dart';
import 'package:fabrica_de_software/services/language_service.dart';
import 'package:fabrica_de_software/locator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fabrica_de_software/generated/app_localizations.dart';

import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _HomeState();
}

class _HomeState extends State<App> {
  late LanguageService _languageService;

  @override
  void initState() {
    super.initState();
    _languageService = locator.get<LanguageService>();
    _languageService.initializeLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _languageService,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: defaultTheme,
          locale: _languageService.currentLocale,
          // Configuração para reduzir erros de overflow em desenvolvimento
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(1.0), // Fixa escala do texto
              ),
              child: child!,
            );
          },
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: LanguageService.supportedLocales,
          initialRoute: NamedRoutes.splash,
          routes: {
            NamedRoutes.initial: (context) => const OnboardingPag(),
            NamedRoutes.splash: (context) => const SplashPage(),
            NamedRoutes.signUp: (context) => const SignUpPage(),
            NamedRoutes.signIn: (context) => const SignInPage(),
            NamedRoutes.home: (context) => const MainNavigationPage(),
            NamedRoutes.statistics: (context) => const StatisticsPage(),
            NamedRoutes.workflow: (context) => const WorkflowPage(),
            NamedRoutes.forgotPassword: (context) => const ForgotPasswordPage(),
            NamedRoutes.checkEmail: (context) => const CheckEmailPage(),
            NamedRoutes.clients: (context) => const ClientsPageWithFirestore(),
            NamedRoutes.profile: (context) => const ProfilePage(),
            NamedRoutes.languageSettings:
                (context) => const LanguageSettingsPage(),
            NamedRoutes.savedPdfs: (context) => const SavedPdfsPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == NamedRoutes.clientProfile) {
              final args = settings.arguments as Map<String, dynamic>?;
              if (args != null && args['client'] != null) {
                return MaterialPageRoute(
                  builder:
                      (context) => ClientProfilePage(client: args['client']),
                );
              }
            }
            return null;
          },
        );
      },
    );
  }
}
