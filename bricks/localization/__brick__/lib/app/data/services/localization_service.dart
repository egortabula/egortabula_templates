import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:{{packageName}}/core/i18n/translations.g.dart';

/// A service responsible for managing app localization.
///
/// This service handles initializing, retrieving, and changing
/// the app's locale, as well as storing the selected locale persistently
/// using Hive.
///
/// Usage:
/// - Call [LocalizationService.init] to initialize the service.
/// - Use [changeLocale] to update the app's locale.
/// - Use [getLocale] to retrieve the currently selected locale.
class LocalizationService extends GetxService {
  /// Creates an instance of [LocalizationService].
  ///
  /// - [hive]: The Hive interface used for storing and retrieving locale data.
  LocalizationService({
    required this.hive,
  });

  /// A singleton instance of the [LocalizationService].
  static LocalizationService get instance => Get.find();

  /// The key for the Hive box where locale data is stored.
  static const String boxKey = 'localeBox';

  /// The key for storing the selected locale in the Hive box.
  static const String localeKey = 'selectedLocale';

  /// Initializes the [LocalizationService].
  ///
  /// This method registers the service in the GetX dependency system
  /// if it's not already registered,
  /// and calls [initialize] to set up the Hive box for locale storage.
  ///
  /// - [hive]: The Hive interface for persistent storage.
  static Future<void> init({
    required HiveInterface hive,
  }) async {
    if (!Get.isRegistered<LocalizationService>()) {
      final service = Get.put(
        LocalizationService(
          hive: hive,
        ),
      );
      await service.initialize();
    }
  }

  /// The Hive interface used for managing persistent data.
  final HiveInterface hive;

  /// The Hive box for storing locale-related data.
  late Box<String> _box;

  /// Logger for logging localization-related events.
  final Logger _logger = Logger('LocalizationService');

  /// Initializes the service by opening the Hive box and
  /// setting the initial locale.
  ///
  /// If a locale is already saved in the box, it will be used. Otherwise,
  /// the device's locale will be used as the default.
  Future<void> initialize() async {
    _logger.info('Initializing LocalizationService...');
    _box = await hive.openBox(boxKey);

    final savedLocale = getLocale();
    if (savedLocale == null) {
      await LocaleSettings.useDeviceLocale();

      _logger.info('No saved locale found. Using device locale.');
    } else {
      await LocaleSettings.setLocale(savedLocale);

      _logger.info('Saved locale found. Using locale: $savedLocale');
    }
  }

  /// Changes the app's locale and saves it persistently.
  ///
  /// - [newLocale]: The new locale to be set.
  Future<void> changeLocale(AppLocale newLocale) async {
    _logger.info('Attempting to change locale to ${newLocale.languageCode}...');
    await LocaleSettings.setLocale(newLocale, listenToDeviceLocale: true);

    await _box.put(localeKey, newLocale.languageTag);

    _logger.info('Locale successfully changed to ${newLocale.languageCode}.');
  }

  /// Retrieves the currently selected locale from persistent storage.
  ///
  /// If no locale is found in the storage, `null` is returned.
  AppLocale? getLocale() {
    _logger.fine('Retrieving saved locale from storage...');
    final savedLocale = _box.get(localeKey);
    if (savedLocale == null) {
      _logger.fine('No saved locale found.');
      return null;
    }

    final appLocale = AppLocaleUtils.parse(savedLocale);
    _logger.fine('Saved locale found: $appLocale.');
    return appLocale;
  }

  /// Clears all locale data from persistent storage
  Future<void> clearAll() async {
    _logger.warning('Clearing all data in the locale box...');
    await _box.clear();

    _logger.info('All locale data cleared.');
  }
}
