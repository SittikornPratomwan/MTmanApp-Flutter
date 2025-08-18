import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'authen.dart';
import '---Drawer---/1.setting/theme_provider.dart';

final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize theme system
  await AppTheme.initialize();
  
  // Initialize local notifications 1
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    AppTheme.addListener(_onThemeChanged);
    // Initialize theme notifier with current AppTheme state
    themeModeNotifier.value = AppTheme.isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  void dispose() {
    AppTheme.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    themeModeNotifier.value = AppTheme.isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 2,
            ),
            cardTheme: CardThemeData(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.black54,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            primaryColor: Colors.lightBlueAccent,
            scaffoldBackgroundColor: const Color(0xFF121212),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.lightBlueAccent,
              foregroundColor: Colors.white,
              elevation: 2,
            ),
            cardTheme: CardThemeData(
              color: const Color(0xFF232526),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF232526),
              selectedItemColor: Colors.lightBlueAccent,
              unselectedItemColor: Colors.white54,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF232526),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
              titleLarge: TextStyle(color: Colors.white),
            ),
          ),
          themeMode: mode,
          home: const Authen(),
        );
      },
    );
  }
}