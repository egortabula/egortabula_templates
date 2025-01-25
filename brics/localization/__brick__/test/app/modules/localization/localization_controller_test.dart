import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{packageName}}/app/data/services/localization_service.dart';
import 'package:{{packageName}}/app/modules/localization/localization_controller.dart';
import 'package:{{packageName}}/core/i18n/translations.g.dart';
import 'package:{{packageName}}/core/services/navigation_service.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockLocalizationService extends Mock implements LocalizationService {}

class MockLogger extends Mock implements Logger {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalizationController controller;
  late MockLocalizationService mockLocalizationService;
  late MockLogger mockLogger;

  setUp(() {
    mockLocalizationService = MockLocalizationService();
    mockLogger = MockLogger();

    controller = LocalizationController(
      localizationService: mockLocalizationService,
      loggerImpl: mockLogger,
    );

    // Register default values for mocktail
    registerFallbackValue(AppLocale.en);
  });

  group('LocalizationController', () {
    test('should initialize with the provided service', () {
      expect(controller, isNotNull);
    });

    test(
      'should log a warning if newLocale is null ',
      () async {
        // Arrange
        when(() => mockLogger.warning(any())).thenReturn(null);

        // Act
        await controller.changeLocale(null);

        // Assert
        verify(
          () => mockLogger.warning(
            '⚠️ Attempted to change locale, but the provided locale is null.',
          ),
        ).called(1);

        verifyNever(() => mockLocalizationService.changeLocale(any()));
      },
    );

    test(
      'should change locale when valid newLocale is provided',
      () async {
        // Arrange
        const newLocale = AppLocale.ru;
        when(() => mockLogger.info(any())).thenReturn(null);
        when(() => mockLocalizationService.changeLocale(newLocale))
            .thenAnswer((_) async {});

        // Act
        await controller.changeLocale(newLocale);

        // Assert
        verify(() => mockLocalizationService.changeLocale(newLocale)).called(1);
        verify(
          () => mockLogger.info(
            '🌐 Initiating locale change to: Russian (ru)...',
          ),
        ).called(1);

        verify(
          () => mockLogger.info(
            '✅ Locale change processed by LocalizationService for: '
            'Russian (ru).',
          ),
        ).called(1);
      },
    );

    testWidgets(
      'should log error and show snackbar when service fails',
      (tester) async {
        await tester.pumpWidget(
          TranslationProvider(
            child: MaterialApp(
              navigatorKey: NavigationService.navigatorKey,
              home: const Scaffold(
                body: Center(),
              ),
            ),
          ),
        );

        const newLocale = AppLocale.en;
        const errorMessage = 'Test error';

        when(() => mockLocalizationService.changeLocale(any()))
            .thenThrow(Exception(errorMessage));
        when(() => mockLogger.severe(any())).thenReturn(null);

        await controller.changeLocale(newLocale);
        await tester.pumpAndSettle();
        expect(find.byType(SnackBar), findsOne);

        verify(
          () => mockLogger.severe(
            '❌ An error occurred while changing locale to: English (en).',
            any(),
            any(),
          ),
        ).called(1);
      },
    );
  });
}
