import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:fabrica_de_software/common/constants/app_text_styles.dart';
import 'package:fabrica_de_software/generated/app_localizations.dart';
import 'package:fabrica_de_software/locator.dart';
import 'package:fabrica_de_software/services/language_service.dart';
import 'package:flutter/material.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = locator.get<LanguageService>();
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.greenlightTwo,
        elevation: 0,
        centerTitle: true,
        title: Text(
          localizations.language,
          style: AppTextStyles.smallText16.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListenableBuilder(
        listenable: languageService,
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.selectLanguage,
                  style: AppTextStyles.smallText16.copyWith(
                    color: AppColors.darkgrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Opção Português
                _buildLanguageOption(
                  context: context,
                  languageService: languageService,
                  locale: const Locale('pt', 'BR'),
                  title: localizations.portuguese,
                  subtitle: 'Português (Brasil)',
                  flag: '🇧🇷',
                ),

                const SizedBox(height: 12),

                // Opção Inglês
                _buildLanguageOption(
                  context: context,
                  languageService: languageService,
                  locale: const Locale('en', 'US'),
                  title: localizations.english,
                  subtitle: 'English (United States)',
                  flag: '🇺🇸',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required LanguageService languageService,
    required Locale locale,
    required String title,
    required String subtitle,
    required String flag,
  }) {
    final isSelected =
        languageService.currentLocale.languageCode == locale.languageCode;

    return GestureDetector(
      onTap: () async {
        await languageService.changeLanguage(locale);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                languageService.isPortuguese
                    ? 'Idioma alterado para $title'
                    : 'Language changed to $title',
              ),
              backgroundColor: AppColors.greenlightTwo,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.greenlightTwo.withOpacity(0.1)
                  : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.greenlightTwo : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.smallText16.copyWith(
                      color:
                          isSelected
                              ? AppColors.greenlightTwo
                              : AppColors.darkgrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.smallText.copyWith(
                      color:
                          isSelected ? AppColors.greenlightTwo : AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.greenlightTwo,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
