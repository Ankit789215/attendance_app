import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../domain/models/student.dart';
import '../../../../core/theme/app_theme.dart';

class StudentDetailsScreen extends StatelessWidget {
  final Student student;

  const StudentDetailsScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Profile Header
            CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              child: Text(
                student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              student.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: student.status == 'Active'
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                student.status,
                style: TextStyle(
                  color: student.status == 'Active' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Info Cards
            _buildInfoCard(context, [
              _buildInfoRow(Icons.class_, 'Batch', student.batch),
              const Divider(),
              _buildInfoRow(Icons.calendar_today, 'Admission Date', DateFormat('yMMMd').format(student.admissionDate)),
              const Divider(),
              _buildInfoRow(Icons.pie_chart, 'Attendance', '${student.attendancePercentage.toStringAsFixed(1)}%'),
            ]),
            const SizedBox(height: 16),
            _buildInfoCard(context, [
              _buildInfoRow(Icons.phone, 'Phone Number', student.phone),
              const Divider(),
              _buildInfoRow(Icons.phone_android, 'Parent Phone', student.parentPhone),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade500, size: 22),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(fontSize: 15, color: Colors.grey),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
