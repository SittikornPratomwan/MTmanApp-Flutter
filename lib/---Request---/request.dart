import 'package:flutter/material.dart';
import '../---Drawer---/1.setting/theme_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _departmentController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedCategory;
  String? _selectedType;
  List<File> _selectedImages = []; // เก็บรูปภาพที่เลือก

  final List<String> _categories = [
    'ไฟฟ้า',
    'ประปา',
    'แอร์',
    'อินเทอร์เน็ต',
    'อื่นๆ',
  ];

  final List<String> _types = [
    'ซ่อม',
    'สร้าง',
    'สั่งทำ',
  ];

  final List<String> _departments = [
    'IMD',
    'HR',
    'Accounting',
    'Logistic',
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    AppTheme.addListener(_onThemeChanged);
    _loadSavedData();
    _setupTextControllerListeners();
  }

  // โหลดข้อมูลที่บันทึกไว้
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _titleController.text = prefs.getString('request_title') ?? '';
      _descriptionController.text = prefs.getString('request_description') ?? '';
      _departmentController.text = prefs.getString('request_department') ?? '';
      _phoneController.text = prefs.getString('request_phone') ?? '';
      _selectedCategory = prefs.getString('request_category');
      _selectedType = prefs.getString('request_type');
    });
  }

  // บันทึกข้อมูลอัตโนมัติเมื่อมีการเปลี่ยนแปลง
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('request_title', _titleController.text);
    await prefs.setString('request_description', _descriptionController.text);
    await prefs.setString('request_department', _departmentController.text);
    await prefs.setString('request_phone', _phoneController.text);
    if (_selectedCategory != null) {
      await prefs.setString('request_category', _selectedCategory!);
    }
    if (_selectedType != null) {
      await prefs.setString('request_type', _selectedType!);
    }
  }

  // ตั้งค่า listener สำหรับ text controllers
  void _setupTextControllerListeners() {
    _titleController.addListener(_saveData);
    _descriptionController.addListener(_saveData);
    _departmentController.addListener(_saveData);
    _phoneController.addListener(_saveData);
  }

  // ล้างข้อมูลที่บันทึกไว้
  Future<void> _clearSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('request_title');
    await prefs.remove('request_description');
    await prefs.remove('request_department');
    await prefs.remove('request_phone');
    await prefs.remove('request_category');
    await prefs.remove('request_type');
  }
  
  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Keep the state alive
    final isDark = AppTheme.isDarkMode;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'แจ้งซ่อม',
          style: TextStyle(
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
                const SnackBar(
                  content: Text('แจ้งเตือนสำหรับแจ้งซ่อม'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
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
                  colors: [Color.fromARGB(255, 176, 208, 240), Colors.white],
                ),
              ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.build,
                    size: 60,
                    color: isDark ? Colors.lightBlueAccent : Colors.blue,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'สร้างใบแจ้งซ่อม',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // หัวข้อ
                  _buildTextField(
                    controller: _titleController,
                    label: 'หัวข้อ',
                    hint: 'ระบุหัวข้อการซ่อม',
                    isDark: isDark,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกหัวข้อ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // ลักษณะ
                  _buildDropdown(
                    value: _selectedType,
                    label: 'ลักษณะ',
                    items: _types,
                    onChanged: (value) async {
                      setState(() => _selectedType = value);
                      await _saveData(); // บันทึกทันทีเมื่อเปลี่ยนลักษณะ
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),
                  
                  // หมวดหมู่
                  _buildDropdown(
                    value: _selectedCategory,
                    label: 'หมวดหมู่',
                    items: _categories,
                    onChanged: (value) async {
                      setState(() => _selectedCategory = value);
                      await _saveData(); // บันทึกทันทีเมื่อเปลี่ยนหมวดหมู่
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),
                  
                  // รายละเอียด
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'รายละเอียด',
                    hint: 'อธิบายปัญหาที่พบ',
                    maxLines: 4,
                    isDark: isDark,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกรายละเอียด';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // ส่วนของผู้แจ้ง
                  Text(
                    'ข้อมูลผู้แจ้ง',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.lightBlueAccent : Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // แผนก (Dropdown)
                  _buildDropdown(
                    value: _departmentController.text.isEmpty ? null : _departmentController.text,
                    label: 'แผนก',
                    items: _departments,
                    onChanged: (value) async {
                      setState(() {
                        _departmentController.text = value ?? '';
                      });
                      await _saveData(); // บันทึกทันทีเมื่อเปลี่ยนแผนก
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),

                  // เบอร์โทร
                  _buildTextField(
                    controller: _phoneController,
                    label: 'เบอร์โทร',
                    hint: 'ระบุเบอร์โทรศัพท์',
                    isDark: isDark,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกเบอร์โทร';
                      }
                      if (!RegExp(r'^[0-9]{9,10}$').hasMatch(value)) {
                        return 'กรุณากรอกเบอร์โทรให้ถูกต้อง';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // ปุ่มเพิ่มรูปภาพ
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add_a_photo, color: Colors.white),
                      label: Text(
                        _selectedImages.isEmpty 
                            ? 'เพิ่มรูปภาพ'
                            : 'เพิ่มรูปภาพ (${_selectedImages.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.lightBlueAccent : Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            return SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt, color: Colors.green),
                                    title: const Text('ถ่ายรูป'),
                                    onTap: () async {
                                      Navigator.pop(context);
                                      await _pickImageFromCamera();
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo_library, color: Colors.blue),
                                    title: const Text('เลือกจากแกลเลอรี่'),
                                    onTap: () async {
                                      Navigator.pop(context);
                                      await _pickImageFromGallery();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // แสดงรูปภาพที่เลือก
                  if (_selectedImages.isNotEmpty)
                    SizedBox(
                      height: 160,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    _selectedImages[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 40),
                  
                  // ปุ่มส่งข้อมูล
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submitRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.lightBlueAccent : Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'ส่งใบแจ้งซ่อม',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
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
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
          hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
          filled: true,
          fillColor: isDark ? const Color(0xFF232526) : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: isDark ? Colors.lightBlueAccent : Colors.blue, width: 2),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String label,
    required List<String> items,
    required Function(String?) onChanged,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
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
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
          filled: true,
          fillColor: isDark ? const Color(0xFF232526) : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: isDark ? Colors.lightBlueAccent : Colors.blue, width: 2),
          ),
        ),
        dropdownColor: isDark ? const Color(0xFF232526) : Colors.white,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณาเลือก$label';
          }
          return null;
        },
      ),
    );
  }

  void _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ส่งใบแจ้งซ่อมเรียบร้อยแล้ว'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // รีเซ็ตฟอร์ม
      _titleController.clear();
      _descriptionController.clear();
      _departmentController.clear();
      _phoneController.clear();
      setState(() {
        _selectedCategory = null;
        _selectedType = null;
        _selectedImages.clear();
      });
      
      // ล้างข้อมูลที่บันทึกไว้
      await _clearSavedData();
    }
  }

  // ฟังก์ชันถ่ายรูปจากกล้อง
  Future<void> _pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    }
  }

  // ฟังก์ชันเลือกรูปจากแกลเลอรี่
  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images.map((image) => File(image.path)));
      });
    }
  }

  // ฟังก์ชันลบรูปภาพ
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  void dispose() {
    AppTheme.removeListener(_onThemeChanged);
    _titleController.dispose();
    _descriptionController.dispose();
    _departmentController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
