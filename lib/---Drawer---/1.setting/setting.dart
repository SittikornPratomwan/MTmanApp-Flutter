import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'about.dart';
import 'theme_provider.dart';
import '../../main.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with WidgetsBindingObserver {
  String _selectedLanguage = 'ไทย';
  bool _notificationsEnabled = true;
  
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
      if (mounted) {
        setState(() {
          _notificationsEnabled = status.isGranted;
        });
      }
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
          if (mounted) {
            setState(() {
              _notificationsEnabled = true;
            });
            _showSuccessMessage('เปิดการแจ้งเตือนเรียบร้อยแล้ว');
            // แสดงการแจ้งเตือนทดสอบ
            await _showTestNotification();
          }
        } else if (status.isDenied || status.isPermanentlyDenied) {
          if (mounted) {
            setState(() {
              _notificationsEnabled = false;
            });
            _showOpenSettingsDialog('เปิดการแจ้งเตือน');
          }
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

  // ทดสอบการแจ้งเตือน
  Future<void> _testNotification() async {
    try {
      // ตรวจสอบว่าการแจ้งเตือนเปิดอยู่หรือไม่
      final permission = Permission.notification;
      final status = await permission.status;
      
      if (status.isGranted) {
        // ส่งการแจ้งเตือนทดสอบ
        await _showTestNotification();
        _showSuccessMessage('ส่งการแจ้งเตือนทดสอบแล้ว');
      } else {
        // แสดง dialog ให้เปิดการแจ้งเตือนก่อน
        _showOpenSettingsDialog('เปิดการแจ้งเตือน');
      }
    } catch (e) {
      print('Error testing notification: $e');
      _showSuccessMessage('ไม่สามารถส่งการแจ้งเตือนได้');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ตั้งค่า',
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
            ListTile(
              leading: Icon(Icons.dark_mode, color: isDark ? Colors.lightBlueAccent : Colors.blue),
              title: Text('โหมดมืด', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              trailing: Switch(
                value: isDark,
                onChanged: (value) async {
                  await AppTheme.setDarkMode(value);
                  // Force rebuild MaterialApp
                  if (mounted) {
                    setState(() {});
                  }
                },
                activeColor: Colors.lightBlueAccent,
                inactiveThumbColor: Colors.blue,
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.language, color: isDark ? Colors.lightBlueAccent : Colors.blue),
              title: Text('ภาษา', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              subtitle: Text(_selectedLanguage, style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
              onTap: () {
                _showLanguageDialog(context, isDark);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.notifications, color: isDark ? Colors.lightBlueAccent : Colors.blue),
              title: Text('การแจ้งเตือน', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: _toggleSystemNotification,
                activeColor: Colors.lightBlueAccent,
                inactiveThumbColor: Colors.blue,
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.notification_add, color: isDark ? Colors.lightBlueAccent : Colors.blue),
              title: Text('ทดสอบการแจ้งเตือน', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              subtitle: Text('ส่งการแจ้งเตือนทดสอบ', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
              onTap: () {
                _testNotification();
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.info, color: isDark ? Colors.lightBlueAccent : Colors.blue),
              title: Text('เกี่ยวกับแอป', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String tempLanguage = _selectedLanguage;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF232526) : Colors.white,
              title: Text(
                'เลือกภาษา',
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: Text(
                      'ไทย',
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    ),
                    value: 'ไทย',
                    groupValue: tempLanguage,
                    onChanged: (String? value) {
                      setStateDialog(() {
                        tempLanguage = value!;
                      });
                    },
                    activeColor: isDark ? Colors.lightBlueAccent : Colors.blue,
                  ),
                  RadioListTile<String>(
                    title: Text(
                      'English',
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    ),
                    value: 'English',
                    groupValue: tempLanguage,
                    onChanged: (String? value) {
                      setStateDialog(() {
                        tempLanguage = value!;
                      });
                    },
                    activeColor: isDark ? Colors.lightBlueAccent : Colors.blue,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text(
                    'ยกเลิก',
                    style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.lightBlueAccent : Colors.blue,
                  ),
                  child: const Text(
                    'ตกลง',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedLanguage = tempLanguage;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
