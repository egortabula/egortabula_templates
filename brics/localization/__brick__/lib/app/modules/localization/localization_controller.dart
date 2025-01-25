// ignore_for_file: avoid_catches_without_on_clauses /// No exceptions type

import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:{{packageName}}/app/data/services/localization_service.dart';
import 'package:{{packageName}}/core/i18n/translations.g.dart';
import 'package:{{packageName}}/core/services/navigation_service.dart';
import 'package:{{packageName}}/core/utils/extensions/app_locale_extension.dart';
import 'package:{{packageName}}/core/utils/functions/show_snackbar.dart';

/// Controller for managing the localization (language) settings
/// of the application.
///
/// Handles the logic for changing the app's locale and interacts with the
/// [LocalizationService] to apply the selected locale. Logs actions and errors
/// for debugging purposes.
class LocalizationController extends GetxController {
  /// Creates an instance of [LocalizationController].
  ///
  /// - [localizationService]: The service used for changing the app's locale.
  /// This parameter is required.
  LocalizationController({
    required LocalizationService localizationService,
    Logger? loggerImpl,
  })  : _localizationService = localizationService,
        _logger = loggerImpl ?? Logger('LocalizationController');

  final LocalizationService _localizationService;

  final Logger _logger;

  /// List of supported languages by application
  List<AppLocale> get supportedLocales => AppLocale.values;

  /// Changes the application's locale to the specified [newLocale].
  ///
  /// - [newLocale]: The new locale to apply. If `null`, no action is performed.
  Future<void> changeLocale(AppLocale? newLocale) async {
    if (newLocale == null) {
      _logger.warning(
        '⚠️ Attempted to change locale, but the provided locale is null.',
      );
      return;
    }

    try {
      // Log the start of the locale change process
      _logger.info(
        '🌐 Initiating locale change to: '
        '${newLocale.englishName} (${newLocale.languageCode})...',
      );

      // Delegate the locale change to the service
      await _localizationService.changeLocale(newLocale);

      // Log a message indicating the service method handled the locale change
      _logger.info(
        '✅ Locale change processed by LocalizationService for: '
        '${newLocale.englishName} (${newLocale.languageCode}).',
      );
    } catch (e, stackTrace) {
      final context = NavigationService.context;

      if (!context.mounted) return;
      await showSnackbar(
        context,
        message: t.localization.errors.changeLocaleErrorMessage,
      );
      // Log any errors during the locale change
      _logger.severe(
        '❌ An error occurred while changing locale to: '
        '${newLocale.englishName} (${newLocale.languageCode}).',
        e,
        stackTrace,
      );
    }
  }
}
