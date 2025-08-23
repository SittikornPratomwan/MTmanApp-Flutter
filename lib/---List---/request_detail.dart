import 'package:flutter/material.dart';
import '../---Drawer---/1.setting/theme_provider.dart';

class RequestDetailPage extends StatefulWidget {
  final Map<String, dynamic> request;

  const RequestDetailPage({
    super.key,
    required this.request,
  });

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  bool _isCompleting = false;

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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'รอดำเนินการ':
        return Colors.orange;
      case 'กำลังดำเนินการ':
        return Colors.blue;
      case 'เสร็จสิ้น':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'รอดำเนินการ':
        return Icons.schedule;
      case 'กำลังดำเนินการ':
        return Icons.engineering;
      case 'เสร็จสิ้น':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'ไฟฟ้า':
        return Icons.electrical_services;
      case 'ประปา':
        return Icons.water_drop;
      case 'แอร์':
        return Icons.ac_unit;
      case 'อินเทอร์เน็ต':
        return Icons.wifi;
      case 'ทั่วไป':
        return Icons.build;
      default:
        return Icons.category;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'ด่วนมาก':
        return Colors.red;
      case 'ด่วน':
        return Colors.orange;
      case 'ปกติ':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _completeJob() async {
    if (widget.request['status'] == 'เสร็จสิ้น') return;

    setState(() {
      _isCompleting = true;
    });

    // จำลองการประมวลผล
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          final isDark = AppTheme.isDarkMode;
          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF232526) : Colors.white,
            title: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'จบงานสำเร็จ',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(
              'งาน "${widget.request['title']}" ได้รับการจบงานเรียบร้อยแล้ว',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // ปิด dialog
                  Navigator.of(context).pop(true); // กลับไปหน้าก่อนหน้าพร้อมส่งผลลัพธ์
                },
                child: Text(
                  'ตกลง',
                  style: TextStyle(
                    color: isDark ? Colors.lightBlueAccent : Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    setState(() {
      _isCompleting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDarkMode;
    final statusColor = _getStatusColor(widget.request['status']);
    final priorityColor = _getPriorityColor(widget.request['priority']);
    final isCompleted = widget.request['status'] == 'เสร็จสิ้น';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'รายละเอียดงานซ่อม',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? Colors.lightBlueAccent : Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        decoration: isDark
            ? const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
                ),
              )
            : const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF8FBFF), Color(0xFFE3F2FD)],
                ),
              ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF232526) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _getStatusIcon(widget.request['status']),
                                  color: statusColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.request['title'],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        widget.request['status'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: statusColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Information Cards
                    _buildInfoCard(
                      isDark: isDark,
                      title: 'ข้อมูลทั่วไป',
                      icon: Icons.info_outline,
                      children: [
                        _buildInfoRow(
                          isDark: isDark,
                          icon: Icons.confirmation_number,
                          label: 'รหัสงาน',
                          value: widget.request['id'],
                        ),
                        _buildInfoRow(
                          isDark: isDark,
                          icon: _getCategoryIcon(widget.request['category']),
                          label: 'หมวดหมู่',
                          value: widget.request['category'],
                        ),
                        _buildInfoRow(
                          isDark: isDark,
                          icon: Icons.calendar_today,
                          label: 'วันที่แจ้ง',
                          value: widget.request['date'],
                        ),
                        _buildInfoRow(
                          isDark: isDark,
                          icon: Icons.priority_high,
                          label: 'ความสำคัญ',
                          value: widget.request['priority'],
                          valueColor: priorityColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildInfoCard(
                      isDark: isDark,
                      title: 'รายละเอียดปัญหา',
                      icon: Icons.description,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2d2d3a) : const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? Colors.white12 : Colors.black12,
                            ),
                          ),
                          child: Text(
                            widget.request['description'],
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark ? Colors.white : Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Timeline Card (ตัวอย่าง)
                    _buildInfoCard(
                      isDark: isDark,
                      title: 'ประวัติการดำเนินงาน',
                      icon: Icons.timeline,
                      children: [
                        _buildTimelineItem(
                          isDark: isDark,
                          time: widget.request['date'],
                          title: 'ได้รับแจ้งซ่อม',
                          description: 'ระบบได้รับการแจ้งซ่อมเรียบร้อยแล้ว',
                          isCompleted: true,
                        ),
                        if (widget.request['status'] != 'รอดำเนินการ')
                          _buildTimelineItem(
                            isDark: isDark,
                            time: '${widget.request['date']} + 1 วัน',
                            title: 'เริ่มดำเนินการ',
                            description: 'ช่างเริ่มเข้าตรวจสอบและซ่อมแซม',
                            isCompleted: true,
                          ),
                        if (isCompleted)
                          _buildTimelineItem(
                            isDark: isDark,
                            time: '${widget.request['date']} + 2 วัน',
                            title: 'งานเสร็จสิ้น',
                            description: 'การซ่อมแซมเสร็จสิ้นเรียบร้อย',
                            isCompleted: true,
                          ),
                      ],
                    ),
                    const SizedBox(height: 100), // เผื่อพื้นที่สำหรับปุ่ม
                  ],
                ),
              ),
            ),

            // Complete Job Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF232526) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isCompleted ? null : (_isCompleting ? null : _completeJob),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCompleted ? Colors.grey : Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: isCompleted ? 0 : 3,
                    ),
                    child: _isCompleting
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'กำลังบันทึก...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isCompleted ? Icons.check_circle : Icons.task_alt,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isCompleted ? 'งานเสร็จสิ้นแล้ว' : 'จบงาน',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required bool isDark,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF232526) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: isDark ? Colors.lightBlueAccent : Colors.blue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required bool isDark,
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? (isDark ? Colors.white : Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required bool isDark,
    required String time,
    required String title,
    required String description,
    required bool isCompleted,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? Colors.white54 : Colors.black38,
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
