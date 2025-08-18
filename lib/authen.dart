import 'package:flutter/material.dart';
import '---Homepage---/homepage.dart';
import '---Drawer---/1.setting/theme_provider.dart';

class Authen extends StatefulWidget {
  const Authen({super.key});

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  late double screenWidth, screenHeight;
  bool redEye = true;
  String? selectedLocation;
  int? selectedLocationId;
  bool isLoading = false;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final Map<String, int> locationIdMap = {
    'LamLukKa': 1,
    'BanBueng': 2,
    'HeadOffice': 3,
  };

  @override
  void initState() {
    super.initState();
    AppTheme.addListener(_onThemeChanged);
  }
  
  @override
  void dispose() {
    AppTheme.removeListener(_onThemeChanged);
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  
  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    final isDark = AppTheme.isDarkMode;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: screenWidth,
        height: screenHeight,
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.1),
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      color: isDark ? const Color(0xFF232526) : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: isDark ? Colors.black.withOpacity(0.5) : Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.asset(
                        'images/logo.jpg',
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'เข้าสู่ระบบ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ระบบใบซ่อมสร้าง MT Request',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 30),
                  buildTextField(
                    controller: usernameController,
                    labelText: 'ชื่อผู้ใช้',
                    prefixIcon: Icons.person,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),
                  buildPasswordField(isDark: isDark),
                  const SizedBox(height: 30),
                  buildLocationRadio(isDark: isDark),
                  const SizedBox(height: 30),
                  buildLoginButton(isDark: isDark),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    required bool isDark,
  }) {
    return Container(
      width: screenWidth * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon, color: isDark ? Colors.lightBlue[200] : Colors.blue),
          labelText: labelText,
          labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
          filled: true,
          fillColor: isDark ? const Color(0xFF232526) : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: isDark ? Colors.lightBlueAccent : Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField({required bool isDark}) {
    return Container(
      width: screenWidth * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: passwordController,
        obscureText: redEye,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_outline, color: isDark ? Colors.lightBlue[200] : Colors.blue),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                redEye = !redEye;
              });
            },
            icon: Icon(
              redEye ? Icons.visibility_off : Icons.visibility,
              color: isDark ? Colors.lightBlue[200] : Colors.blue,
            ),
          ),
          labelText: 'รหัสผ่าน',
          labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
          filled: true,
          fillColor: isDark ? const Color(0xFF232526) : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: isDark ? Colors.lightBlueAccent : Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }

  Widget buildLocationRadio({required bool isDark}) {
    final List<Map<String, dynamic>> locations = [
      {'id': 1, 'name': 'LamLukKa', 'displayKey': 'lam_luk_ka'},
      {'id': 2, 'name': 'BanBueng', 'displayKey': 'ban_bueng'},
      {'id': 3, 'name': 'HeadOffice', 'displayKey': 'head_office'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF232526) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'สถานที่:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.lightBlue[200] : Colors.blue,
            ),
          ),
          const SizedBox(height: 10),
          ...locations.map(
            (loc) => RadioListTile<int>(
              title: Text(
                loc['displayKey'] == 'lam_luk_ka'
                    ? 'ลำลูกกา'
                    : loc['displayKey'] == 'ban_bueng'
                        ? 'บ้านบึง'
                        : 'สำนักงานใหญ่',
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              value: loc['id'],
              groupValue: selectedLocationId,
              onChanged: (int? value) {
                setState(() {
                  selectedLocationId = value;
                  selectedLocation = loc['name'];
                });
              },
              activeColor: isDark ? Colors.lightBlueAccent : Colors.blue,
              tileColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoginButton({required bool isDark}) {
    return Container(
      width: screenWidth * 0.6,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.lightBlueAccent.withOpacity(0.2) : Colors.blue.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? Colors.lightBlueAccent : Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: isLoading ? null : handleLogin,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'เข้าสู่ระบบ',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Future<void> handleLogin() async {
    if (usernameController.text.isEmpty) {
      showSnackbar(
        'กรุณากรอก ชื่อผู้ใช้',
        backgroundColor: Colors.red
      );
      return;
    }
    if (passwordController.text.isEmpty) {
      showSnackbar(
        'กรุณากรอก รหัสผ่าน',
        backgroundColor: Colors.red
      );
      return;
    }
    if (selectedLocationId == null) {
      showSnackbar(
        'กรุณาเลือกสถานที่',
        backgroundColor: Colors.red
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Allow login with any valid username/password
    if (usernameController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      print('Login Success: Location = ${selectedLocation ?? ''}, ID = ${selectedLocationId ?? ''}');
      showSnackbar(
        'เข้าสู่ระบบสำเร็จ',
        backgroundColor: Colors.green,
      );
      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              location: selectedLocation ?? '',
              locationId: selectedLocationId,
            ),
          ),
        );
      }
    } else {
      showSnackbar(
        'เข้าสู่ระบบไม่สำเร็จ',
        backgroundColor: Colors.red,
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  void showSnackbar(String message, {Color backgroundColor = Colors.blue}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          backgroundColor: backgroundColor,
        ),
      );
    }
  }
}
