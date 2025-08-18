import 'package:flutter/material.dart';
import '1.setting/theme_provider.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  void initState() {
    super.initState();
    AppTheme.addListener(_onThemeChanged);
  }
  
  @override
  void dispose() {
    AppTheme.removeListener(_onThemeChanged);
    super.dispose();
  }
  
  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ช่วยเหลือ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: isDark ? Colors.lightBlueAccent : Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
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
                  colors: [Color.fromARGB(255, 176, 208, 240), Colors.white],
                ),
              ),
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            // Header Card
            Card(
              elevation: 8,
              color: isDark ? const Color(0xFF232526) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: isDark ? Colors.lightBlueAccent : Colors.blue,
                      child: const Icon(Icons.help_outline, size: 35, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'คู่มือการใช้งาน RepairApp',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.blue.shade700,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'แอปพลิเคชันสำหรับแจ้งซ่อมและติดตามงานซ่อมบำรุง',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Getting Started Section
            _buildSectionCard(
              isDark: isDark,
              icon: Icons.play_circle_fill,
              title: 'เริ่มต้นใช้งาน',
              children: [
                _buildStepItem(
                  isDark: isDark,
                  stepNumber: '1',
                  title: 'เข้าสู่ระบบ',
                  description: 'กรอกชื่อผู้ใช้และรหัสผ่านเพื่อเข้าสู่ระบบ',
                  icon: Icons.login,
                ),
                _buildStepItem(
                  isDark: isDark,
                  stepNumber: '2',
                  title: 'เลือกสถานที่',
                  description: 'เลือกสถานที่ที่ต้องการแจ้งซ่อมจาก Dropdown',
                  icon: Icons.location_on,
                ),
                _buildStepItem(
                  isDark: isDark,
                  stepNumber: '3',
                  title: 'เข้าสู่หน้าหลัก',
                  description: 'หลังจากเข้าสู่ระบบสำเร็จจะเข้าสู่หน้าหลักของแอป',
                  icon: Icons.home,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Features Section
            _buildSectionCard(
              isDark: isDark,
              icon: Icons.featured_play_list,
              title: 'ฟีเจอร์หลัก',
              children: [
                _buildFeatureItem(
                  isDark: isDark,
                  icon: Icons.build_circle,
                  title: 'แจ้งซ่อม',
                  description: 'สร้างใบแจ้งซ่อมใหม่ระบุหัวข้อ หมวดหมู่ ความสำคัญ และรายละเอียด',
                ),
                _buildFeatureItem(
                  isDark: isDark,
                  icon: Icons.list_alt,
                  title: 'รายการ',
                  description: 'ดูรายการใบแจ้งซ่อมทั้งหมด กรองตามสถานะ และดูรายละเอียด',
                ),
                _buildFeatureItem(
                  isDark: isDark,
                  icon: Icons.settings,
                  title: 'ตั้งค่า',
                  description: 'ปรับแต่งการตั้งค่าแอป เปลี่ยนภาษา และโหมดมืด',
                ),
              ],
            ),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 6,
      color: isDark ? const Color(0xFF232526) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: isDark ? Colors.lightBlueAccent : Colors.blue,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.blue.shade700,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem({
    required bool isDark,
    required String stepNumber,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isDark ? Colors.lightBlueAccent : Colors.blue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                stepNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      size: 20,
                      color: isDark ? Colors.lightBlueAccent : Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required bool isDark,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isDark ? Colors.lightBlueAccent : Colors.blue).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isDark ? Colors.lightBlueAccent : Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
