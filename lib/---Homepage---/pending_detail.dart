import 'package:flutter/material.dart';
import '../---Drawer---/1.setting/theme_provider.dart';
import '../---Request---/signature_page.dart';

class PendingDetailPage extends StatefulWidget {
  final Map<String, dynamic> request;

  const PendingDetailPage({
    super.key,
    required this.request,
  });

  @override
  State<PendingDetailPage> createState() => _PendingDetailPageState();
}

class _PendingDetailPageState extends State<PendingDetailPage> {
  bool _isApproved = false;

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'รายละเอียดการแจ้งซ่อม',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? Colors.lightBlueAccent : Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
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
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    color: isDark ? Colors.grey[900] : Colors.white,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with ID and Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.request['id'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    widget.request['title'] ?? '',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Chip(
                                label: Text(widget.request['category'] ?? ''),
                                backgroundColor: _getCategoryColor(widget.request['category'] ?? ''),
                                labelStyle: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Category
                          _buildDetailItem(
                            isDark: isDark,
                            icon: Icons.category,
                            label: 'หมวดหมู่',
                            value: widget.request['category'] ?? '',
                            color: _getCategoryColor(widget.request['category'] ?? ''),
                          ),

                          // Type
                          _buildDetailItem(
                            isDark: isDark,
                            icon: Icons.build,
                            label: 'ประเภท',
                            value: widget.request['type'] ?? '',
                          ),

                          // Title
                          _buildDetailItem(
                            isDark: isDark,
                            icon: Icons.title,
                            label: 'หัวข้อ',
                            value: widget.request['title'] ?? '',
                          ),

                          // Description
                          _buildDetailItem(
                            isDark: isDark,
                            icon: Icons.description,
                            label: 'รายละเอียด',
                            value: widget.request['description'] ?? '',
                            isMultiline: true,
                          ),

                          // Requester
                          _buildDetailItem(
                            isDark: isDark,
                            icon: Icons.person,
                            label: 'ผู้ขอ',
                            value: widget.request['requester'] ?? '',
                          ),

                          // Phone
                          _buildDetailItem(
                            isDark: isDark,
                            icon: Icons.phone,
                            label: 'โทรศัพท์',
                            value: widget.request['phone'] ?? '',
                          ),

                          // Request Date
                          _buildDetailItem(
                            isDark: isDark,
                            icon: Icons.calendar_today,
                            label: 'วันที่ขอ',
                            value: widget.request['requestDate'] ?? '',
                          ),

                          // Procurement (optional)
                          if (widget.request['procurement'] != null) ...[
                            const SizedBox(height: 8),
                            Text('ข้อมูลการจัดซื้อ', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Approve Button at bottom
              if (!_isApproved)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      _showApprovalDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'เซ็นชื่ออนุมัติ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required bool isDark,
    required IconData icon,
    required String label,
    required String value,
    Color? color,
    bool isMultiline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (color ?? (isDark ? Colors.lightBlueAccent : Colors.blue)).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color ?? (isDark ? Colors.lightBlueAccent : Colors.blue),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  maxLines: isMultiline ? null : 1,
                  overflow: isMultiline ? null : TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'ไฟฟ้า':
        return Colors.amber;
      case 'ประปา':
        return Colors.blue;
      case 'แอร์':
        return Colors.cyan;
      case 'อินเทอร์เน็ต':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _showApprovalDialog() {
    final isDark = AppTheme.isDarkMode;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.purple,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                'ยืนยันการอนุมัติ',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'คุณต้องการอนุมัติการแจ้งซ่อม "${widget.request['title']}" หรือไม่?',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Colors.blue,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'จำเป็นต้องมีลายเซ็นเพื่อยืนยันการอนุมัติ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'ยกเลิก',
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();

                // Navigate to signature page
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignaturePage(request: widget.request),
                  ),
                );

                // If signature was completed and approved
                if (result == true) {
                  setState(() {
                    _isApproved = true;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.edit, size: 16),
                  const SizedBox(width: 4),
                  const Text('เซ็นชื่อ'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
