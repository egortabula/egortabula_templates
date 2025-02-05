import 'package:flutter/material.dart';
import 'package:{{packageName.snakeCase()}}/core/utils/helpers/keys/keys.dart';

/// A shorthand getter to retrieve the current [BuildContext]
/// from the navigator key.
BuildContext get c => keys.navigatorKeys.navigatorKey.currentState!.context;
