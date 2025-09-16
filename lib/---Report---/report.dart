import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../---Drawer---/1.setting/theme_provider.dart';

/// Clean ReportPage — desktop-centered responsive layout.
class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String _selectedPeriod = 'สัปดาห์นี้';
  String _selectedCategory = 'ทั้งหมด';

  final List<Map<String, dynamic>> _reportData = [
    {'category': 'รถยนต์/โฟคลิฟ', 'completed': 45, 'pending': 5, 'inProgress': 3},
    {'category': 'หอพัก', 'completed': 20, 'pending': 2, 'inProgress': 1},
    {'category': 'เครื่องจักร', 'completed': 30, 'pending': 4, 'inProgress': 2},
    {'category': 'อื่นๆ', 'completed': 10, 'pending': 1, 'inProgress': 0},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDarkMode;

    final int totalCompleted = _reportData.fold(0, (s, e) => s + (e['completed'] as int));
    final int totalPending = _reportData.fold(0, (s, e) => s + (e['pending'] as int));
    final int totalInProgress = _reportData.fold(0, (s, e) => s + (e['inProgress'] as int));
    final int totalAll = totalCompleted + totalPending + totalInProgress;
    final double completionRate = totalAll > 0 ? (totalCompleted / totalAll) * 100 : 0;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxContentWidth = math.min(1100, constraints.maxWidth * 0.95).toDouble();

          // Match homepage full-screen background gradient
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: isDark
                ? const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF232526), Color(0xFF414345)],
                    ),
                  )
                : const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFB0D0F0), Color(0xFFDCEBFA)],
                    ),
                  ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _buildHeader(isDark, completionRate, totalAll),
                    const SizedBox(height: 20),
                    _buildFilters(),
                    const SizedBox(height: 20),
                    _buildOverview(totalAll, totalCompleted, totalPending),
                    const SizedBox(height: 20),
                    _buildCategoryReports(),
                  ]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(bool isDark, double completionRate, int totalAll) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF17202A) : Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)]),
      child: Row(children: [
        const Icon(Icons.analytics, size: 28),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('รายงานการซ่อมบำรุง', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          const SizedBox(height: 4),
          Text('งานทั้งหมด $totalAll • อัตราสำเร็จ ${completionRate.toStringAsFixed(1)}%', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
        ])
      ]),
    );
  }

  Widget _buildFilters() {
    return Row(children: [
      Expanded(
        child: DropdownButton<String>(
          value: _selectedPeriod,
          items: ['วันนี้', 'สัปดาห์นี้', 'เดือนนี้'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _selectedPeriod = v ?? _selectedPeriod),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: DropdownButton<String>(
          value: _selectedCategory,
          items: ['ทั้งหมด', 'รถยนต์/โฟคลิฟ', 'หอพัก', 'เครื่องจักร', 'อื่นๆ'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _selectedCategory = v ?? _selectedCategory),
        ),
      ),
    ]);
  }

  Widget _buildOverview(int totalAll, int completed, int pending) {
    return Row(children: [
      _smallCard('งานทั้งหมด', '$totalAll'),
      const SizedBox(width: 12),
      _smallCard('เสร็จสิ้น', '$completed'),
      const SizedBox(width: 12),
      _smallCard('รอดำเนินการ', '$pending'),
    ]);
  }

  Widget _smallCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)), const SizedBox(height: 8), Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
      ),
    );
  }

  Widget _buildCategoryReports() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('รายงานตามหมวดหมู่', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      ..._reportData.map((d) => Card(child: ListTile(title: Text(d['category']), subtitle: Text('เสร็จ ${d['completed']} • รอ ${d['pending']}')))).toList(),
    ]);
  }
}
