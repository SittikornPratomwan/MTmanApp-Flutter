import 'package:flutter/material.dart';
import 'package:repairapp/---Drawer---/history.dart';
import '../authen.dart';
import '1.setting/setting.dart';
import 'help.dart';
import '1.setting/theme_provider.dart';

class AppDrawer extends StatefulWidget {
  final Function(int)? onPageChanged;
  
  const AppDrawer({super.key, this.onPageChanged});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
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

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF232526) : Colors.white,
      child: Column(
        children: [
          // Header ของ Drawer
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark 
                    ? [Colors.lightBlueAccent, Colors.blue.shade700]
                    : [Colors.blue, Colors.blue.shade700],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    // รูปโปรไฟล์
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 15),
                    // ชื่อผู้ใช้
                    const Text(
                      'ผู้ใช้งาน',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'user@example.com',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // รายการเมนู
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 12),
                // เพิ่มปุ่มประวัติการแจ้งซ่อมไว้ด้านบน
                _buildDrawerItem(
                  icon: Icons.history,
                  title: 'ประวัติการแจ้งซ่อมของฉัน',
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const HistoryPage()),
                    );
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'ตั้งค่า',
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SettingPage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.help,
                  title: 'ช่วยเหลือ',
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const HelpPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // ปุ่มออกจากระบบ
          Container(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showLogoutDialog(context, isDark);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  'ออกจากระบบ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (isDark ? Colors.lightBlueAccent : Colors.blue).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDark ? Colors.lightBlueAccent : Colors.blue,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hoverColor: isDark ? Colors.white10 : Colors.blue.withOpacity(0.1),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF232526) : Colors.white,
          title: Text(
            'ออกจากระบบ',
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          ),
          content: Text(
            'คุณต้องการออกจากระบบหรือไม่?',
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'ยกเลิก',
                style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate back to login
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Authen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'ออกจากระบบ',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
