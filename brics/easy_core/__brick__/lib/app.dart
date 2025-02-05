import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'routes/app_router.dart';

/// The root widget of the application.
class {{packageName}} extends StatelessWidget {
  /// Creates a [{{packageName}}] widget.
  const {{packageName}}({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '{{packageName}}',
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
