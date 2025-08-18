import 'package:flutter/material.dart';
import 'theme_provider.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
        title: const Text('เกี่ยวกับแอป', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            Center(
              child: Icon(Icons.build_circle, color: isDark ? Colors.lightBlueAccent : Colors.blue, size: 80),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text('MT Request', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.blue)),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text('เวอร์ชัน 1.0.0', style: TextStyle(fontSize: 16, color: isDark ? Colors.white70 : Colors.black54)),
            ),
            const SizedBox(height: 24),
            Text('รายละเอียดแอปพลิเคชัน', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? Colors.white : Colors.black87)),
            const SizedBox(height: 8),
            Text('แอปพลิเคชันสำหรับจัดการใบแจ้งซ่อมและติดตามสถานะการซ่อมแซมภายในองค์กร รองรับการแจ้งซ่อมและดูรายการใบงาน', style: TextStyle(fontSize: 16, color: isDark ? Colors.white70 : Colors.black54)),
            const SizedBox(height: 24),
            Text('ผู้พัฒนา', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? Colors.white : Colors.black87)),
            const SizedBox(height: 8),
            Text('Sittikorn Pratomwan', style: TextStyle(fontSize: 16, color: isDark ? Colors.lightBlueAccent : Colors.blue)),
            const SizedBox(height: 8),
            Text('Kitchakan Sripaeng', style: TextStyle(fontSize: 16, color: isDark ? Colors.lightBlueAccent : Colors.blue)),
            const SizedBox(height: 8),
            Text('ติดต่อสอบถาม', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? Colors.white : Colors.black87)),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.email, color: isDark ? Colors.lightBlueAccent : Colors.blue),
                const SizedBox(width: 8),
                Text('sittikorn.pr@ku.th', style: TextStyle(fontSize: 16, color: isDark ? Colors.lightBlueAccent : Colors.blue)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.email, color: isDark ? Colors.lightBlueAccent : Colors.blue),
                const SizedBox(width: 8),
                Text('kitchakan.s@ku.th', style: TextStyle(fontSize: 16, color: isDark ? Colors.lightBlueAccent : Colors.blue)),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: Text('© 2025 Repair Management System', style: TextStyle(fontSize: 14, color: isDark ? Colors.white54 : Colors.black45)),
            ),
          ],
        ),
      ),
    );
  }
}
