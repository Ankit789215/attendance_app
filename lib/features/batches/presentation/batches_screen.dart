import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BatchesScreen extends StatelessWidget {
  const BatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Batches')),
      body: Center(
        child: Text('Batches Management Screen', style: Theme.of(context).textTheme.headlineMedium)
            .animate()
            .fade(duration: 400.ms)
            .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
      ),
    );
  }
}
