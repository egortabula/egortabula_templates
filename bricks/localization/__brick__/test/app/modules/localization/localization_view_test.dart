import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{packageName}}/app/data/services/localization_service.dart';
import 'package:{{packageName}}/app/modules/localization/localization_controller.dart';
import 'package:{{packageName}}/app/modules/localization/localization_view.dart';
import 'package:{{packageName}}/core/i18n/translations.g.dart';
import 'package:{{packageName}}/core/services/navigation_service.dart';
import 'package:{{packageName}}/core/utils/extensions/app_locale_extension.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalizationService extends Mock implements LocalizationService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  late MockLocalizationService mockLocalizationService;

  setUp(() async {
    mockLocalizationService = MockLocalizationService();
    await LocaleSettings.setLocale(AppLocale.en);

    // Register fallback values for mocktail
    registerFallbackValue(AppLocale.en);
  });

  group('LocalizationView', () {
    final rootWidget = TranslationProvider(
      child: MaterialApp.router(
        routerConfig: GoRouter(
          navigatorKey: NavigationService.navigatorKey,
          routes: [
            GoRoute(
              path: '/',
              name: 'Localizations',
              builder: (context, state) {
                Get.put(
                  LocalizationController(
                    localizationService: mockLocalizationService,
                  ),
                );
                return const LocalizationView();
              },
            ),
          ],
        ),
      ),
    );
    testWidgets('should render app bar with correct title', (tester) async {
      // Mock translations

      // Build the widget
      await tester.pumpWidget(rootWidget);

      // Verify AppBar title
      expect(find.byType(AppBar), findsOneWidget);
      expect(
        find.byKey(ValueKey(t.localization.title)),
        findsOne,
      );
    });

    testWidgets('should render list of locales', (tester) async {
      // Build the widget
      await tester.pumpWidget(rootWidget);

      // Verify the list displays all locales
      for (final locale in AppLocale.values) {
        expect(find.text(locale.nativeName), findsAny);
        expect(find.text(locale.englishName), findsAny);
      }
    });

    testWidgets('should call changeLocale when a locale is selected',
        (tester) async {
      const selectedLocale = AppLocale.ru;

      // Mock the changeLocale method
      when(() => mockLocalizationService.changeLocale(any()))
          .thenAnswer((_) async {});

      await tester.pumpWidget(
        rootWidget,
      );

      // Tap on a locale to select it
      final targetTile = find.text(selectedLocale.nativeName);
      await tester.tap(targetTile);

      // Wait for animations and UI updates
      await tester.pumpAndSettle();

      // Verify that changeLocale was called with the selected locale
      verify(
        () => Get.find<LocalizationController>().changeLocale(selectedLocale),
      ).called(1);
    });
  });
}
