import 'package:flutter/material.dart';
import '../---Drawer---/1.setting/theme_provider.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  // ข้อมูลจำลองรายการแจ้งซ่อม
  final List<Map<String, dynamic>> _requests = [
    {
      'id': 'REQ001',
      'title': 'ซ่อมแอร์ห้องประชุม',
      'category': 'แอร์',
      'priority': 'ด่วน',
      'status': 'รอดำเนินการ',
      'date': '2025-08-06',
      'description': 'แอร์ไม่เย็น เสียงดัง',
    },
    {
      'id': 'REQ002', 
      'title': 'ซ่อมหลอดไฟ',
      'category': 'ไฟฟ้า',
      'priority': 'ปกติ',
      'status': 'กำลังดำเนินการ',
      'date': '2025-08-05',
      'description': 'หลอดไฟห้องทำงานขัดข้อง',
    },
    {
      'id': 'REQ003',
      'title': 'ซ่อมท่อน้ำรั่ว',
      'category': 'ประปา', 
      'priority': 'ด่วนมาก',
      'status': 'เสร็จสิ้น',
      'date': '2025-08-04',
      'description': 'ท่อน้ำใต้อ่างล้างจานรั่ว',
    },
  ];

  String _selectedFilter = 'ทั้งหมด';
  final List<String> _filterOptions = ['ทั้งหมด', 'รอดำเนินการ', 'กำลังดำเนินการ', 'เสร็จสิ้น'];

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
    final filteredRequests = _getFilteredRequests();

    return Scaffold(
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
            
            // Request List
            Expanded(
              child: filteredRequests.isEmpty
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
                            'ไม่มีรายการแจ้งซ่อม',
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
                      itemCount: filteredRequests.length,
                      itemBuilder: (context, index) {
                        final request = filteredRequests[index];
                        return _buildRequestCard(request, isDark);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request, bool isDark) {
    Color statusColor;
    IconData statusIcon;
    
    switch (request['status']) {
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
  // ความสำคัญ (ปกติ/ด่วน/ด่วนมาก) ถูกนำออกจากการแสดงผลตามคำขอ

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
        onTap: () => _showRequestDetail(request),
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
                      request['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  // ลบแท็กความสำคัญออก
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
                    request['category'],
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
                    request['date'],
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                request['description'],
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
                    'รหัส: ${request['id']}',
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
                        request['status'],
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

  List<Map<String, dynamic>> _getFilteredRequests() {
    if (_selectedFilter == 'ทั้งหมด') {
      return _requests;
    }
    return _requests.where((request) => request['status'] == _selectedFilter).toList();
  }

  void _showRequestDetail(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final isDark = AppTheme.isDarkMode;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF232526) : Colors.white,
          title: Text(
            'รายละเอียดใบแจ้งซ่อม',
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('รหัส:', request['id'], isDark),
              _buildDetailRow('หัวข้อ:', request['title'], isDark),
              _buildDetailRow('หมวดหมู่:', request['category'], isDark),
              _buildDetailRow('สถานะ:', request['status'], isDark),
              _buildDetailRow('วันที่:', request['date'], isDark),
              _buildDetailRow('รายละเอียด:', request['description'], isDark),
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
}
