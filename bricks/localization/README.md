# Localization Brick Template

A customizable brick template to simplify localization setup in Flutter projects using the slang package. This template includes ready-to-use components for handling localization and language changes.

## Features
1.	Simplified Localization Setup: Built on the slang package for streamlined translation management.
2.	LocalizationService: Manages locale changes, stores user-selected locales with Hive, and defaults to the device locale when necessary.
3.	LocalizationView: A pre-designed, Material Design 3-compliant view for selecting and changing locales.

## How to use

1. **Initialize LocalizationService**

Before starting your app, initialize the LocalizationService and ensure Hive is properly set up.

```dart
await Hive.initFlutter(); // Initialize Hive
await Get.put(LocalizationService(hive: Hive)).initialize(); // Initialize LocalizationService
```

2. **Wrap the Root Widget with TranslationProvider**

Wrap the root widget of your app with TranslationProvider to provide translation context throughout the app.

```dart
TranslationProvider(
  child: MyApp(),
);
```

3. **Configure MaterialApp**

Pass the necessary localization parameters to your MaterialApp.


```dart
MaterialApp(
  locale: TranslationProvider.of(context).flutterLocale,
  supportedLocales: AppLocaleUtils.supportedLocales,
  localizationsDelegates: GlobalMaterialLocalizations.delegates,
  // Other MaterialApp parameters
);
```

4. **Initialize LocalizationController**

Before navigating to the LocalizationView, initialize the LocalizationController using Get.put().

```dart
// Example: Initializing before navigation
Get.put(LocalizationController(localizationService: LocalizationService.instance));

// Navigate to LocalizationView
Get.to(() => const LocalizationView());
```

## Components

**LocalizationService**
- Handles locale changes.
- Uses Hive for persistent storage.
- Automatically applies the selected locale globally or defaults to the device locale.

**LocalizationView**
- A fully designed view for users to select their preferred language
- Implements Material Design 3 principles.

## Example usage

```dart
void main() async {
  // Initialize Hive and LocalizationService
  await Hive.initFlutter();
  await Get.put(LocalizationService(hive: Hive)).initialize();

  runApp(
    TranslationProvider(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: HomePage(),
    );
  }
}
```
## Notes

1.	Hive Initialization: Ensure that Hive.initFlutter() is called before initializing the LocalizationService.
2.	LocalizationController: Always initialize the controller before navigating to the LocalizationView.

## What’s Inside?

When you generate a project using this brick template, you’ll get:
- LocalizationService: Ready-to-use logic for managing locales
- LocalizationView: A polished UI for language selection.
- Setup and boilerplate: Preconfigured settings for integrating the slang package into your app.

---
This brick template simplifies the localization process, saving you time and effort while ensuring a seamless user experience for managing app languages. Happy coding! 🎉