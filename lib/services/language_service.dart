import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LanguageService extends ChangeNotifier {
  static const _storage = FlutterSecureStorage();
  static const String _languageKey = 'selected_language';

  Locale _currentLocale = const Locale('pt', 'BR');

  Locale get currentLocale => _currentLocale;

  static const List<Locale> supportedLocales = [
    Locale('pt', 'BR'),
    Locale('en', 'US'),
  ];

  // Inicializar o idioma salvo
  Future<void> initializeLanguage() async {
    try {
      final savedLanguageCode = await _storage.read(key: _languageKey);

      if (savedLanguageCode != null) {
        _currentLocale = Locale(savedLanguageCode);
        notifyListeners();
      } else {
        // Se não há idioma salvo, usar o idioma do sistema
        _currentLocale = _getSystemLocale();
        await _saveLanguage(_currentLocale.languageCode);
        notifyListeners();
      }
    } catch (e) {
      // Usar português como padrão em caso de erro
      _currentLocale = const Locale('pt', 'BR');
      notifyListeners();
    }
  }

  // Obter idioma do sistema
  Locale _getSystemLocale() {
    final systemLocales = WidgetsBinding.instance.platformDispatcher.locales;
    for (final locale in systemLocales) {
      if (supportedLocales.any(
        (supported) => supported.languageCode == locale.languageCode,
      )) {
        return locale;
      }
    }
    return const Locale('pt', 'BR'); // Padrão para português
  }

  // Alterar idioma
  Future<void> changeLanguage(Locale locale) async {
    if (_currentLocale == locale) {
      return;
    }

    _currentLocale = locale;
    await _saveLanguage(locale.languageCode);
    notifyListeners();
  }

  // Salvar idioma no storage
  Future<void> _saveLanguage(String languageCode) async {
    try {
      await _storage.write(key: _languageKey, value: languageCode);
    } catch (e) {
      // Silently handle error
    }
  }

  // Obter nome do idioma atual
  String getCurrentLanguageName() {
    switch (_currentLocale.languageCode) {
      case 'pt':
        return 'Português';
      case 'en':
        return 'English';
      default:
        return 'Português';
    }
  }

  // Verificar se é português
  bool get isPortuguese => _currentLocale.languageCode == 'pt';

  // Verificar se é inglês
  bool get isEnglish => _currentLocale.languageCode == 'en';
}
