import 'package:flutter/foundation.dart';

/// Utilitários para controlar logs e debugging
class DebugUtils {
  /// Suprime erros de overflow em produção
  static void configureErrorHandling() {
    if (!kDebugMode) {
      // Em produção, captura erros mas não os exibe
      FlutterError.onError = (FlutterErrorDetails details) {
        // Log o erro internamente mas não quebra a UI
        debugPrint('Production Error Caught: ${details.exception}');
      };
    }
  }

  /// Verifica se deve mostrar logs de desenvolvimento
  static bool get shouldShowDebugLogs => kDebugMode;

  /// Log personalizado que só funciona em debug
  static void debugLog(String message) {
    if (kDebugMode) {
      debugPrint('[DEBUG] $message');
    }
  }

  /// Log de erro que funciona tanto em debug quanto produção
  static void errorLog(String message, [dynamic error]) {
    if (kDebugMode) {
      debugPrint('[ERROR] $message${error != null ? ': $error' : ''}');
    } else {
      // Em produção, registra mas não exibe
      debugPrint('[PROD_ERROR] $message');
    }
  }
}
