import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'not_found_controller.dart';

class NotFoundPage extends GetView<NotFoundController> {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NotFoundPage'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'NotFoundPage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
