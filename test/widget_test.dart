import 'package:fabrica_de_software/pages/onboarding/onboarding_pag.dart';
import 'package:fabrica_de_software/widgets/custom_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('OnboardingPag deve ter botão Get Started', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: OnboardingPag()));

      // Assert
      expect(find.text('Get Started'), findsOneWidget);
      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.text('Spend Smarter'), findsOneWidget);
      expect(find.text('Save More'), findsOneWidget);
    });

    testWidgets('PrimaryButton deve ser clicável', (WidgetTester tester) async {
      // Arrange
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Test Button',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();

      // Assert
      expect(pressed, isTrue);
    });
  });
}
