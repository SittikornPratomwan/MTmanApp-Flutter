import 'package:flutter/material.dart';
import '../---Drawer---/1.setting/theme_provider.dart';

  // ข้อมูลจำลองประวัติการแจ้งซ่อม
  final List<Map<String, dynamic>> _history = [
    {
      'id': 'HIS001',
      'title': 'ซ่อมคอมพิวเตอร์',
      'category': 'IT',
      'priority': 'ด่วน',
      'status': 'เสร็จสิ้น',
      'date': '2025-08-01',
      'description': 'คอมพิวเตอร์เปิดไม่ติด',
    },
    {
      'id': 'HIS002',
      'title': 'ซ่อมไฟห้องประชุม',
      'category': 'ไฟฟ้า',
      'priority': 'ปกติ',
      'status': 'กำลังดำเนินการ',
      'date': '2025-08-03',
      'description': 'ไฟห้องประชุมดับ',
    },
    {
      'id': 'HIS003',
      'title': 'ซ่อมแอร์',
      'category': 'แอร์',
      'priority': 'ด่วนมาก',
      'status': 'รอดำเนินการ',
      'date': '2025-08-05',
      'description': 'แอร์ไม่เย็น',
    },
  ];

  String _selectedFilter = 'ทั้งหมด';
  final List<String> _filterOptions = ['ทั้งหมด', 'รอดำเนินการ', 'กำลังดำเนินการ', 'เสร็จสิ้น'];

  List<Map<String, dynamic>> _getFilteredHistory() {
    if (_selectedFilter == 'ทั้งหมด') {
      return _history;
    }
    return _history.where((item) => item['status'] == _selectedFilter).toList();
  }

  Widget _buildHistoryCard(BuildContext context, Map<String, dynamic> item, bool isDark) {
    Color statusColor;
    IconData statusIcon;
    switch (item['status']) {
      case 'รอดำเนินการ':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case 'กำลังดำเนินการ':
        statusColor = Colors.blue;
        statusIcon = Icons.engineering;
        break;
      case 'เสร็จสิ้น':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }
    Color priorityColor;
    switch (item['priority']) {
      case 'ด่วนมาก':
        priorityColor = Colors.red;
        break;
      case 'ด่วน':
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.green;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF232526) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _showHistoryDetail(context, item),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: priorityColor),
                    ),
                    child: Text(
                      item['priority'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: priorityColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.category,
                    size: 16,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item['category'],
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item['date'],
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'รหัส: ${item['id']}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.lightBlueAccent : Colors.blue,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        statusIcon,
                        size: 16,
                        color: statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item['status'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHistoryDetail(BuildContext context, Map<String, dynamic> item) {
    final isDark = AppTheme.isDarkMode;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF232526) : Colors.white,
          title: Text(
            'รายละเอียดประวัติแจ้งซ่อม',
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('รหัส:', item['id'], isDark),
              _buildDetailRow('หัวข้อ:', item['title'], isDark),
              _buildDetailRow('หมวดหมู่:', item['category'], isDark),
              _buildDetailRow('ความสำคัญ:', item['priority'], isDark),
              _buildDetailRow('สถานะ:', item['status'], isDark),
              _buildDetailRow('วันที่:', item['date'], isDark),
              _buildDetailRow('รายละเอียด:', item['description'], isDark),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'ปิด',
                style: TextStyle(color: isDark ? Colors.lightBlueAccent : Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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
    final filteredHistory = _getFilteredHistory();
    return Scaffold(
      appBar: AppBar(
        title: const Text('ประวัติการแจ้งซ่อม', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        child: Column(
          children: [
            // Filter Dropdown
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'กรอง:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF232526) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedFilter,
                          isExpanded: true,
                          dropdownColor: isDark ? const Color(0xFF232526) : Colors.white,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          items: _filterOptions.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedFilter = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // History List
            Expanded(
              child: filteredHistory.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox,
                            size: 64,
                            color: isDark ? Colors.white54 : Colors.black54,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'ยังไม่มีประวัติการแจ้งซ่อม',
                            style: TextStyle(
                              fontSize: 18,
                              color: isDark ? Colors.white54 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: filteredHistory.length,
                      itemBuilder: (context, index) {
                        final item = filteredHistory[index];
                        return _buildHistoryCard(context, item, isDark);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}