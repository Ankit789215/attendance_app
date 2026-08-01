import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Dashboard Overview', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(onPressed: () => context.push('/students'), child: const Text('Students')),
                ElevatedButton(onPressed: () => context.push('/attendance'), child: const Text('Attendance')),
                ElevatedButton(onPressed: () => context.push('/reports'), child: const Text('Reports')),
                ElevatedButton(onPressed: () => context.push('/batches'), child: const Text('Batches')),
                ElevatedButton(onPressed: () => context.push('/settings'), child: const Text('Settings')),
              ],
            )
          ],
        ).animate().fade(duration: 500.ms).scale(curve: Curves.easeOut),
      ),
    );
  }
}
