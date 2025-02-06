import 'package:flutter/material.dart';
import 'package:{{packageName}}/core/i18n/translations.g.dart';
import 'package:{{packageName}}/core/utils/extensions/app_locale_extension.dart';
import 'package:{{packageName}}/core/utils/helpers/keys/keys.dart';

/// A list tile widget that displays the current locale and provides
/// an option to change it.
///
/// This widget is typically used in settings or profile pages to allow
/// users to select or change the app's language.
class LocalizationListTile extends StatelessWidget {
  /// Creates a [LocalizationListTile].
  ///
  /// - [onTap]: A callback function that gets invoked when the tile is tapped.
  const LocalizationListTile({
    required this.onTap,
    super.key,
  });

  /// A callback that is triggered when the list tile is tapped.
  ///
  /// This callback should typically navigate the user to the
  /// [LocalizationView], where they can select a new language or locale.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Translations
    final t = context.t.localization.widgets.listTile;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return ListTile(
      key: keys.localizationKeys.localizationListTile,
      leading: const Icon(Icons.language),
      title: Text(t.title),
      trailing: Text(
        TranslationProvider.of(context).locale.nativeName,
        style: textTheme.bodyLarge?.copyWith(color: colorScheme.primary),
      ),
      onTap: onTap,
    );
  }
}
