import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:{{packageName}}/app/modules/localization/localization_controller.dart';
import 'package:{{packageName}}/core/i18n/translations.g.dart';
import 'package:{{packageName}}/core/utils/extensions/app_locale_extension.dart';
import 'package:{{packageName}}/core/utils/helpers/keys/keys.dart';

/// A view for selecting the application's locale (language).
///
/// Displays a list of available languages and allows the user to select one.
/// The selected language is applied globally in the app. The title in the
/// app bar animates smoothly when changing the language.
class LocalizationView extends GetView<LocalizationController> {
  /// Creates an instance of [LocalizationView].
  const LocalizationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: keys.localizationKeys.backButton,
        leading: const BackButton(),
        title: AnimatedSwitcher(
          duration: Durations.medium1,
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (child, animation) {
            // Animation for sliding and fading out
            final fadeAnimation = Tween<double>(
              begin: 0,
              end: 1,
            ).animate(animation);

            final offsetAnimation = Tween<Offset>(
              begin: const Offset(0, 0.5), // Start from slightly below
              end: Offset.zero, // End at original position
            ).animate(animation);

            return Align(
              alignment: Alignment.centerLeft,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: SlideTransition(
                  position: offsetAnimation,
                  child: child,
                ),
              ),
            );
          },
          child: Text(
            context.t.localization.title,
            key: ValueKey(context.t.localization.title),
            textAlign: TextAlign.left,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView.separated(
        key: keys.localizationKeys.localesListView,
        itemBuilder: (context, index) {
          final locale = controller.supportedLocales[index];

          return RadioListTile<AppLocale>(
            key: keys.localizationKeys.localeKey(locale),
            title: Text(locale.nativeName),
            subtitle: Text(locale.englishName),
            value: locale,
            groupValue: TranslationProvider.of(context).locale,
            onChanged: controller.changeLocale,
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            height: 1,
            indent: 72,
          );
        },
        itemCount: controller.supportedLocales.length,
      ),
    );
  }
}
