import 'package:{{packageName}}/core/i18n/translations.g.dart';

extension AppLocaleExtension on AppLocale {
  String get nativeName {
    return switch (this) {
      AppLocale.ru => 'Русский',
      AppLocale.en => 'English'
    };
  }

  String get englishName {
    return switch (this) {
      AppLocale.ru => 'Russian',
      AppLocale.en => 'English'
    };
  }
}
