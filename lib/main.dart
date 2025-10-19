import 'package:fabrica_de_software/firebase_options.dart';
import 'package:fabrica_de_software/locator.dart';
import 'package:fabrica_de_software/pages/app.dart';
import 'package:fabrica_de_software/common/utils/debug_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar tratamento de erros para reduzir logs em produção
  DebugUtils.configureErrorHandling();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupDependencies();
  runApp(const App());
}
