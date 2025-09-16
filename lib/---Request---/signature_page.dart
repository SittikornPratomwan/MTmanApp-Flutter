import 'package:flutter/material.dart';
import '../---Drawer---/1.setting/theme_provider.dart';

class SignaturePage extends StatefulWidget {
  final Map<String, dynamic> request;

  const SignaturePage({
    super.key,
    required this.request,
  });

  @override
  State<SignaturePage> createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  bool _signed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ลงนามอนุมัติ'),
        backgroundColor: isDark ? Colors.lightBlueAccent : Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('เอกสาร: ${widget.request['id'] ?? ''}'),
                    const SizedBox(height: 8),
                    Text(widget.request['title'] ?? ''),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('ทดสอบการเซ็นโดยการกดปุ่มด้านล่าง'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                setState(() => _signed = true);
                // Return true to indicate signed/approved
                Navigator.of(context).pop(true);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14.0),
                child: Text('เซ็นชื่อและอนุมัติ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
