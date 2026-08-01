import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Center(
        child: Text('Reports & Analytics Screen', style: Theme.of(context).textTheme.headlineMedium)
            .animate()
            .fade(duration: 400.ms)
            .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
      ),
    );
  }
}
