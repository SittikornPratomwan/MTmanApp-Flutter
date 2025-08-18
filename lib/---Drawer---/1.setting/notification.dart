import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../main.dart';
import 'app_theme.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with WidgetsBindingObserver {
  bool _pushNotifications = true;
  
  @override
  void initState() {
    super.initState();
    AppTheme.addListener(_onThemeChanged);
    WidgetsBinding.instance.addObserver(this);
    _checkNotificationPermission();
  }
  
  @override
  void dispose() {
    AppTheme.removeListener(_onThemeChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // เมื่อแอปกลับมาทำงาน ตรวจสอบสถานะการแจ้งเตือนใหม่
      _checkNotificationPermission();
    }
  }
  
  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  // ตรวจสอบสถานะการแจ้งเตือนปัจจุบัน
  Future<void> _checkNotificationPermission() async {
    try {
      final permission = Permission.notification;
      final status = await permission.status;
      setState(() {
        _pushNotifications = status.isGranted;
      });
    } catch (e) {
      print('Error checking notification permission: $e');
    }
  }

  // เปิด/ปิดการแจ้งเตือนในเครื่อง
  Future<void> _toggleSystemNotification(bool value) async {
    try {
      if (value) {
        // เปิดการแจ้งเตือน - ขอสิทธิ์
        final permission = Permission.notification;
        final status = await permission.request();
        
        if (status.isGranted) {
          setState(() {
            _pushNotifications = true;
          });
          
          // แสดงการแจ้งเตือนทดสอบ
          await _showTestNotification();
          
          _showSuccessMessage('เปิดการแจ้งเตือนเรียบร้อยแล้ว');
        } else if (status.isDenied) {
          setState(() {
            _pushNotifications = false;
          });
          _showOpenSettingsDialog('เปิดการแจ้งเตือน');
        } else if (status.isPermanentlyDenied) {
          setState(() {
            _pushNotifications = false;
          });
          _showOpenSettingsDialog('เปิดการแจ้งเตือน');
        }
      } else {
        // ปิดการแจ้งเตือน - นำไปยังหน้าตั้งค่าเพื่อปิดการแจ้งเตือน
        _showOpenSettingsDialog('ปิดการแจ้งเตือน');
      }
    } catch (e) {
      print('Error toggling notification: $e');
      // Fallback: แสดง dialog เพื่อไปตั้งค่า
      if (value) {
        _showOpenSettingsDialog('เปิดการแจ้งเตือน');
      } else {
        _showOpenSettingsDialog('ปิดการแจ้งเตือน');
      }
    }
  }

  // แสดงการแจ้งเตือนทดสอบ
  Future<void> _showTestNotification() async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'repair_app_channel',
        'Repair App Notifications',
        channelDescription: 'Notifications for repair app updates',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: false,
      );
      
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      
      await flutterLocalNotificationsPlugin.show(
        0,
        'การแจ้งเตือนเปิดใช้งานแล้ว',
        'คุณจะได้รับการแจ้งเตือนเมื่อมีการอัปเดตสถานะการซ่อม',
        platformChannelSpecifics,
      );
    } catch (e) {
      print('Error showing test notification: $e');
    }
  }

  // แสดงข้อความสำเร็จ
  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // แสดง dialog เพื่อไปยังหน้าตั้งค่าแอปในระบบ
  void _showOpenSettingsDialog(String action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final isDark = AppTheme.isDarkMode;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF232526) : Colors.white,
          title: Text(
            '$actionการแจ้งเตือน',
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          ),
          content: Text(
            'ต้องการ$actionการแจ้งเตือนในระบบโทรศัพท์\nคลิก "ไปตั้งค่า" เพื่อเปิดหน้าตั้งค่าแอป',
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
          ),
          actions: [
            TextButton(
              child: Text(
                'ปิด',
                style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // รีเซ็ต switch กลับสู่สถานะเดิม
                _checkNotificationPermission();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: action == 'เปิด' 
                  ? (isDark ? Colors.lightBlueAccent : Colors.blue)
                  : Colors.red,
              ),
              child: const Text(
                'ไปตั้งค่า',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  // เปิดหน้าตั้งค่าแอปในระบบ
                  await openAppSettings();
                  
                  // แสดงข้อความแนะนำทันที
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          action == 'เปิด' 
                            ? 'กรุณาเปิดการแจ้งเตือนในหน้าตั้งค่า'
                            : 'กรุณาปิดการแจ้งเตือนในหน้าตั้งค่า',
                        ),
                        backgroundColor: action == 'เปิด' 
                          ? Colors.green 
                          : Colors.orange,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                } catch (e) {
                  print('Error opening app settings: $e');
                  if (mounted) {
                    _showSuccessMessage('ไม่สามารถเปิดหน้าตั้งค่าได้');
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'การแจ้งเตือน',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
            Card(
              elevation: 6,
              color: isDark ? const Color(0xFF232526) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.notifications_active,
                          color: isDark ? Colors.lightBlueAccent : Colors.blue,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'ประเภทการแจ้งเตือน',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.blue.shade700,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Push Notifications
                    ListTile(
                      leading: Icon(Icons.phone_android, color: isDark ? Colors.lightBlueAccent : Colors.blue),
                      title: Text('แจ้งเตือนบนแอป', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                      subtitle: Text('รับการแจ้งเตือนผ่านแอปพลิเคชัน', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                      trailing: Switch(
                        value: _pushNotifications,
                        onChanged: _toggleSystemNotification,
                        activeColor: Colors.lightBlueAccent,
                        inactiveThumbColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Save Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('บันทึกการตั้งค่าเรียบร้อยแล้ว'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.lightBlueAccent : Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'บันทึกการตั้งค่า',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
