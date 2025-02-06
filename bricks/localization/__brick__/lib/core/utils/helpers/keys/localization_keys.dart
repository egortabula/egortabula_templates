import 'package:flutter/foundation.dart';
import 'package:{{packageName}}/core/i18n/translations.g.dart';

class LocalizationKeys {
  Key localeKey(AppLocale locale) {
    return Key('locale ${locale.name}');
  }

  final Key localesListView = const Key('LocalesListView');

  final Key backButton = const Key('BackButton');

  final Key localizationListTile = const Key('LocalizationListTile');
}
