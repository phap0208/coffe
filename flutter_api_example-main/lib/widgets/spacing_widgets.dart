import 'package:flutter/material.dart';

// Widget to add consistent vertical spacing across the app
class VerticalSpacing extends StatelessWidget {
  const VerticalSpacing({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 10);
  }
}

// Widget to add consistent horizontal spacing across the app
class HorizontalSpacing extends StatelessWidget {
  const HorizontalSpacing({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: 10);
  }
}
