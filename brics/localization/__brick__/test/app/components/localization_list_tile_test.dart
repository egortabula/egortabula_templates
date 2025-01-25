import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{packageName}}/app/components/localization_list_tile.dart';
import 'package:{{packageName}}/core/i18n/translations.g.dart';
import 'package:{{packageName}}/core/utils/extensions/app_locale_extension.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalizationListTile Tests', () {
    late VoidCallback mockOnTap;
    var onTapCallCount = 0;

    setUp(() async {
      await LocaleSettings.setLocale(AppLocale.ru);
      mockOnTap = () => onTapCallCount++;
    });
    testWidgets('Renders all UI elements correctly', (tester) async {
      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: Scaffold(
              body: LocalizationListTile(
                onTap: mockOnTap,
                key: const Key('body'),
              ),
            ),
          ),
        ),
      );

      // Verify the leading icon is displayed
      expect(find.byIcon(Icons.language), findsOneWidget);

      // Verify the title text is displayed
      expect(find.text(t.localization.widgets.listTile.title), findsOneWidget);

      // Verify the trailing text (locale native name) is displayed

      final BuildContext context = tester.element(
        find.byKey(const Key('body')),
      );
      final appLocale = TranslationProvider.of(context).locale;

      expect(find.text(appLocale.nativeName), findsOneWidget);
    });

    testWidgets('Displays correct title and trailing text', (tester) async {
      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: Scaffold(
              body: LocalizationListTile(
                onTap: mockOnTap,
                key: const Key('body'),
              ),
            ),
          ),
        ),
      );

      final BuildContext context = tester.element(
        find.byKey(const Key('body')),
      );
      final appLocale = TranslationProvider.of(context).locale;

      // Verify title text
      expect(find.text(t.localization.widgets.listTile.title), findsOneWidget);

      // Verify trailing text matches native name
      expect(find.text(appLocale.nativeName), findsOneWidget);
    });

    testWidgets('Triggers onTap callback when tapped', (tester) async {
      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: Scaffold(
              body: LocalizationListTile(
                onTap: mockOnTap,
              ),
            ),
          ),
        ),
      );

      // Tap on the tile
      await tester.tap(find.byType(ListTile));
      await tester.pump();

      // Verify onTap is called
      expect(onTapCallCount, equals(1));
    });
  });
}
