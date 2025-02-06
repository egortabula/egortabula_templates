import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'error_controller.dart';

class ErrorView extends GetView<ErrorController> {
  const ErrorView({
    required this.error,
    super.key,
  });

  final Exception error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(
        child: Text('Welcome to Error module!'),
      ),
    );
  }
}
