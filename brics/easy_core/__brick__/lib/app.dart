import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:{{projectName.snakeCase()}}/routes/app_router.dart';

/// The root widget of the application.
class {{projectName.pascalCase()}}App extends StatelessWidget {
  /// Creates a [{{projectName.pascalCase()}}App] widget.
  const {{projectName.pascalCase()}}App ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '{{projectName.titleCase()}}',
      routerConfig: AppRouter.config,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      builder: (context, child) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: colorScheme.surfaceContainer,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarIconBrightness: colorScheme.brightness,
          ),
          child: GestureDetector(
            child: child,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          ),
        );
      },
    );
  }
}
