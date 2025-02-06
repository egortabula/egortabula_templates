import 'package:flutter/material.dart';

Future<void> showSnackbar(
  BuildContext context, {
  required String message,
  bool showCloseIcon = true,
}) async {
  assert(message.isNotEmpty, 'message must not be empty');

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      showCloseIcon: showCloseIcon,
    ),
  );
}
