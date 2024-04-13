import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: OutlinedButton(
          onPressed: () {
            // Navigate to all posts screen
            Navigator.of(context).pushNamed('/all-posts');
          },
          child: const Text('Posts Screen'),
        ),
      ),
    );
  }
}
