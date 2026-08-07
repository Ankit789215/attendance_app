import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    // Simple responsive breakpoint
    final isDesktop = size.width > 800;
    final isTablet = size.width > 600 && size.width <= 800;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              
              Text(
                'Overview',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ).animate().fade().slideX(),
              const SizedBox(height: 16),
              
              _buildSummaryCards(context, isDesktop, isTablet),
              const SizedBox(height: 32),
              
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ).animate().fade().slideX(delay: 100.ms),
              const SizedBox(height: 16),
              
              _buildQuickActions(context, isDesktop, isTablet),
              const SizedBox(height: 32),
              
              Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ).animate().fade().slideX(delay: 200.ms),
              const SizedBox(height: 16),
              
              _buildRecentActivity(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final dateFormatted = DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning, Admin 👋',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dateFormatted,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ).animate().fade(duration: 400.ms).slideY(begin: -0.2),
        
        CircleAvatar(
          radius: 24,
          backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
          child: const Icon(Icons.person, color: AppTheme.primaryColor),
        ).animate().scale(delay: 200.ms),
      ],
    );
  }

  Widget _buildSummaryCards(BuildContext context, bool isDesktop, bool isTablet) {
    final cards = [
      _SummaryData('Total Students', '1,240', Icons.people_alt, Colors.blue.shade600),
      _SummaryData('Present Today', '1,180', Icons.check_circle, Colors.green.shade600),
      _SummaryData('Absent Today', '60', Icons.cancel, Colors.red.shade600),
      _SummaryData('Attendance %', '95.1%', Icons.pie_chart, Colors.orange.shade600),
    ];

    int crossAxisCount = isDesktop ? 4 : (isTablet ? 3 : 2);
    double childAspectRatio = isDesktop ? 1.5 : (isTablet ? 1.3 : 1.1);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final data = cards[index];
        return Card(
          elevation: 2,
          shadowColor: data.color.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: data.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(data.icon, color: data.color, size: 28),
                ),
                const Spacer(),
                Text(
                  data.value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fade(delay: (100 * index).ms).scale();
      },
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isDesktop, bool isTablet) {
    final actions = [
      _ActionData('Add Student', Icons.person_add_alt_1, '/students'),
      _ActionData('Take Attendance', Icons.checklist_rtl, '/attendance'),
      _ActionData('Reports', Icons.bar_chart_rounded, '/reports'),
      _ActionData('Manage Batches', Icons.class_outlined, '/batches'),
    ];

    int crossAxisCount = isDesktop ? 4 : (isTablet ? 3 : 2);
    double childAspectRatio = isDesktop ? 3.0 : 2.5;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.push(action.route),
            borderRadius: BorderRadius.circular(16),
            child: Ink(
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(action.icon, color: AppTheme.primaryColor, size: 22),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      action.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).animate().fade(delay: (200 + 100 * index).ms).slideY(begin: 0.2);
      },
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    final activities = [
      {'name': 'John Doe', 'action': 'Marked Present in Mathematics', 'time': '10 mins ago', 'icon': Icons.check_circle_outline, 'color': Colors.green},
      {'name': 'Jane Smith', 'action': 'Added to Batch A', 'time': '1 hour ago', 'icon': Icons.person_add_alt, 'color': Colors.blue},
      {'name': 'Mike Johnson', 'action': 'Marked Absent in Physics', 'time': '2 hours ago', 'icon': Icons.cancel_outlined, 'color': Colors.red},
      {'name': 'Batch B', 'action': 'Daily Attendance Completed', 'time': '3 hours ago', 'icon': Icons.task_alt, 'color': Colors.purple},
    ];

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            leading: CircleAvatar(
              radius: 22,
              backgroundColor: (activity['color'] as Color).withValues(alpha: 0.15),
              child: Icon(activity['icon'] as IconData, color: activity['color'] as Color, size: 20),
            ),
            title: Text(activity['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(activity['action'] as String),
            ),
            trailing: Text(
              activity['time'] as String,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ).animate().fade(delay: (400 + 100 * index).ms).slideX(begin: 0.1);
        },
      ),
    );
  }
}

class _SummaryData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  _SummaryData(this.title, this.value, this.icon, this.color);
}

class _ActionData {
  final String title;
  final IconData icon;
  final String route;

  _ActionData(this.title, this.icon, this.route);
}
