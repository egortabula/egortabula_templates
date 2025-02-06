import 'package:flutter/material.dart';
import '../helpers/keys/keys.dart';


/// A shorthand getter to retrieve the current [BuildContext]
/// from the navigator key.
BuildContext get c => keys.navigatorKeys.navigatorKey.currentState!.context;
