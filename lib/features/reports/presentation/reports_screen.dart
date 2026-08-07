import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import 'widgets/summary_card.dart';
import 'providers/report_providers.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        elevation: 0,
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'Monthly', icon: Icon(Icons.show_chart)),
            Tab(text: 'Batches', icon: Icon(Icons.bar_chart)),
            Tab(text: 'Students', icon: Icon(Icons.pie_chart)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMonthlyView(),
          _buildBatchView(),
          _buildStudentView(),
        ],
      ),
    );
  }

  // --- 1. Monthly View (Line Chart) ---
  Widget _buildMonthlyView() {
    final statsAsync = ref.watch(overallReportStatsProvider);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Last 6 Months Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          statsAsync.when(
            data: (stats) => Column(
              children: [
                Row(
                  children: [
                    Expanded(child: SummaryCard(title: 'Average %', value: '${stats['percentage'].toStringAsFixed(1)}%', icon: Icons.percent, color: Colors.blue)),
                    const SizedBox(width: 12),
                    Expanded(child: SummaryCard(title: 'Total Classes', value: '${stats['totalClasses']}', icon: Icons.calendar_month, color: Colors.purple)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: SummaryCard(title: 'Present', value: '${stats['present']}', icon: Icons.check_circle, color: Colors.green)),
                    const SizedBox(width: 12),
                    Expanded(child: SummaryCard(title: 'Absent', value: '${stats['absent']}', icon: Icons.cancel, color: Colors.red)),
                  ],
                ),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('Error loading stats: $err', style: const TextStyle(color: Colors.red)),
          ),
          const SizedBox(height: 24),
          
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Attendance Trend', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 250,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                                if (value.toInt() >= 0 && value.toInt() < months.length) {
                                  return Text(months[value.toInt()], style: const TextStyle(color: Colors.grey, fontSize: 12));
                                }
                                return const Text('');
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: 5,
                        minY: 50,
                        maxY: 100,
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 75),
                              FlSpot(1, 82),
                              FlSpot(2, 78),
                              FlSpot(3, 88),
                              FlSpot(4, 95),
                              FlSpot(5, 92),
                            ],
                            isCurved: true,
                            color: AppTheme.primaryColor,
                            barWidth: 4,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppTheme.primaryColor.withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. Batch View (Bar Chart) ---
  Widget _buildBatchView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Batch Performance Comparison', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: const SummaryCard(title: 'Top Batch', value: 'Batch B', icon: Icons.star, color: Colors.amber)),
              const SizedBox(width: 12),
              Expanded(child: const SummaryCard(title: 'Lowest Batch', value: 'Batch C', icon: Icons.warning, color: Colors.orange)),
            ],
          ),
          const SizedBox(height: 24),
          
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Attendance by Batch (%)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 250,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 100,
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 0: return const Text('Batch A');
                                  case 1: return const Text('Batch B');
                                  case 2: return const Text('Batch C');
                                  default: return const Text('');
                                }
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 85, color: Colors.blue, width: 20, borderRadius: BorderRadius.circular(4))]),
                          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 96, color: Colors.green, width: 20, borderRadius: BorderRadius.circular(4))]),
                          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 72, color: Colors.orange, width: 20, borderRadius: BorderRadius.circular(4))]),
                        ],
                      ),
                    ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. Student View (Pie Chart) ---
  Widget _buildStudentView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Top Student Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Jane Smith (Batch B)', style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: const SummaryCard(title: 'Attendance', value: '94%', icon: Icons.percent, color: Colors.teal)),
              const SizedBox(width: 12),
              Expanded(child: const SummaryCard(title: 'Classes Attended', value: '47/50', icon: Icons.check, color: Colors.green)),
            ],
          ),
          const SizedBox(height: 24),
          
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Attendance Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 250,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 60,
                        sections: [
                          PieChartSectionData(
                            color: Colors.green,
                            value: 94,
                            title: '94%',
                            radius: 40,
                            titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          PieChartSectionData(
                            color: Colors.red.shade400,
                            value: 6,
                            title: '6%',
                            radius: 40,
                            titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 500.ms).rotate(duration: 500.ms, curve: Curves.easeOut),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegend(Colors.green, 'Present'),
                      const SizedBox(width: 24),
                      _buildLegend(Colors.red.shade400, 'Absent'),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(width: 16, height: 16, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
