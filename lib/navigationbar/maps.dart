import 'package:flutter/material.dart';

class MapsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SwiftStyle'),
      ),
      body: const Center(
        child: Text(
          'Maps Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
