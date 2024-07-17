import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:{{project_name.snakeCase()}}/app/modules/not_found/not_found_page.dart';
import 'package:{{project_name.snakeCase()}}/app/modules/not_found/not_found_binding.dart';
import 'package:{{project_name.snakeCase()}}/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(const _App());
}

Future<void> initServices() async {
  //TODO: add your services here like shared preferences or other for initialize before app start
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: kDebugMode,
        enableLog: kDebugMode,
        title: '{{project_name.sentenceCase()}}',
        binds: const [
          //TODO: register your global app bindings
        ],
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        unknownRoute: GetPage(
          name: Routes.notFound,
          page: () => const NotFoundPage(),
          binding: NotFoundBinding(),
        ),
        locale: Get.deviceLocale,
        supportedLocales: const [
          Locale('en'),
        ],
        fallbackLocale: const Locale('en'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: ThemeMode.system,
        defaultTransition: Transition.native,
      ),
    );
  }
}
