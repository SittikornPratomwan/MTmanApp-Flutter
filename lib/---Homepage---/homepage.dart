import 'package:flutter/material.dart';
import '../---List---/list.dart';
import '../---Drawer---/drawer.dart';
import '../---Drawer---/1.setting/theme_provider.dart';
import '../---Report---/report.dart';

class HomePage extends StatefulWidget {
  final String location;
  final int? locationId;

  const HomePage({
    super.key,
    required this.location,
    this.locationId,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  // ตัวเลขสรุปสถานะ (ตัวอย่าง/จำลอง)
  int _countWaiting = 5;
  int _countInProgress = 2;
  int _countDone = 8;

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

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        _selectedIndex = 0; // หน้าแรก
      } else if (index == 1) {
        _selectedIndex = 1; // รายการ (index 1 ใน IndexedStack)
      } else if (index == 2) {
        _selectedIndex = 2; // รายงาน (index 2 ใน IndexedStack)
      }
    });
  }

  Widget _buildCategoryCard({
    required bool isDark,
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.8),
            color.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: Colors.white),

            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ปุ่มใหญ่แบบมองง่าย (UI อย่างเดียว ไม่ผูกฟังก์ชัน)
  Widget _buildBigActionTile({
    required bool isDark,
    required IconData icon,
    required String title,
    required Color color,
    int? count,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF232526) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          // Count centered at the bottom
          if (count != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDarkMode;
    
    // ชื่อหน้าตาม tab ที่เลือก
    String getPageName() {
      switch (_selectedIndex) {
        case 0:
          return 'หน้าแรก';
        case 1:
          return 'รายการ';
        case 2:
          return 'รายงาน';
        default:
          return 'หน้าแรก';
      }
    }
    
    return Scaffold(
      drawer: AppDrawer(
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      appBar: AppBar(
        title: Text(
          getPageName(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? Colors.lightBlueAccent : Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'Notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('แจ้งเตือนสำหรับ${getPageName()}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // หน้าแรก
          Container(
            // Ensure the background gradient covers the full screen height
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
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
                      // Use two light-blue tones so it doesn't turn white at the bottom
                      colors: [Color(0xFFB0D0F0), Color(0xFFDCEBFA)],
                    ),
                  ),
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  // เพิ่มระยะห่างจากขอบบนหน้าจอเล็กน้อย
                  const SizedBox(height: 16),
                  // ยินดีต้อนรับ
                  Card(
                    color: isDark ? Colors.grey[900] : Colors.white,
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                      child: Column(
                        children: [
                          Icon(Icons.handshake, size: 40, color: isDark ? Colors.lightBlueAccent : Colors.blue),
                          const SizedBox(height: 6),
                          Text(
                            'ยินดีต้อนรับ!',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.blue.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ระบบช่างซ่อมออนไลน์',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // สถิติแต่ละหมวดหมู่
                  Card(
                    color: isDark ? Colors.grey[900] : Colors.white,
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.category,
                                color: isDark ? Colors.lightBlueAccent : Colors.blue,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'หมวดหมู่งาน',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            // Increase item height a bit to avoid tiny overflow on some screens
                            childAspectRatio: 2.5,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            children: [
                              _buildCategoryCard(
                                isDark: isDark,
                                title: 'ไฟฟ้า',
                                count: 7,
                                icon: Icons.electrical_services,
                                color: Colors.amber,
                              ),
                              _buildCategoryCard(
                                isDark: isDark,
                                title: 'ประปา',
                                count: 4,
                                icon: Icons.water_drop,
                                color: Colors.blue,
                              ),
                              _buildCategoryCard(
                                isDark: isDark,
                                title: 'แอร์',
                                count: 3,
                                icon: Icons.ac_unit,
                                color: Colors.cyan,
                              ),
                              _buildCategoryCard(
                                isDark: isDark,
                                title: 'อินเทอร์เน็ต',
                                count: 1,
                                icon: Icons.wifi,
                                color: Colors.purple,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ปุ่มใหญ่ ๆ มองง่าย (UI เท่านั้น ไม่ได้ผูกการทำงาน)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      // เพิ่มความสูงของ tile เล็กน้อยเพื่อป้องกัน overflow
                      childAspectRatio: 1.15,
                      children: [
                        _buildBigActionTile(
                          isDark: isDark,
                          icon: Icons.schedule,
                          title: 'รอดำเนินการ',
                          color: Colors.orange,
                          count: _countWaiting,
                        ),
                        _buildBigActionTile(
                          isDark: isDark,
                          icon: Icons.engineering,
                          title: 'กำลังซ่อม',
                          color: Colors.blue,
                          count: _countInProgress,
                        ),
                        _buildBigActionTile(
                          isDark: isDark,
                          icon: Icons.check_circle,
                          title: 'เสร็จสิ้น',
                          color: Colors.green,
                          count: _countDone,
                        ),
                      ],
                    ),
                  ),
                  // เมนูหลัก (ถูกนำออกตามคำขอ)
                ],
              ),
            ),
          ),
        ),
          // หน้ารายการ
          const ListPage(),
          // หน้ารายงาน
          const ReportPage(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF232526) : const Color(0xFFE3F2FD),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'หน้าแรก',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'รายการ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assessment),
                label: 'รายงาน',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: isDark ? Colors.lightBlueAccent : Colors.blue,
            unselectedItemColor: isDark ? Colors.white54 : Colors.black54,
            backgroundColor: Colors.transparent,
            elevation: 0,
            onTap: _onItemTapped,
          ),
        ),
      ),

    );
  }
}
