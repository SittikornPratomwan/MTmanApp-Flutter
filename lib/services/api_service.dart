import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseURL = 'http://192.168.56.111:8516';
  
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Store authentication token
  String? _authToken;
  
  // Get current token
  String? get authToken => _authToken;
  
  // Set token
  void setToken(String token) {
    _authToken = token;
  }
  
  // Clear token
  void clearToken() {
    _authToken = null;
  }

  // Default headers
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  // Login API
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$baseURL/drugs/auth/login');
      
      final body = json.encode({
        'username': username,
        'password': password,
      });

      print('Login Request URL: $url');
      print('Login Request Body: $body');

      final response = await http.post(
        url,
        headers: _headers,
        body: body,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Connection timeout');
        },
      );

      print('Login Response Status: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

      final responseData = json.decode(response.body);

      // Check if response contains "success": true (accept both 200 and 201 status codes)
      if ((response.statusCode == 200 || response.statusCode == 201) && responseData['success'] == true) {
        // Store token if available
        if (responseData['token'] != null) {
          setToken(responseData['token']);
          print('Token saved: ${responseData['token']}');
        }
        
        return {
          'success': true,
          'data': responseData,
          'message': 'เข้าสู่ระบบสำเร็จ'
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': responseData['message'] ?? 'เข้าสู่ระบบไม่สำเร็จ'
        };
      }
    } catch (e) {
      print('Login Error: $e');
      return {
        'success': false,
        'data': null,
        'message': _getErrorMessage(e)
      };
    }
  }

  // Generic GET request
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('$baseURL$endpoint');
      final mergedHeaders = {..._headers, ...?headers};

      final response = await http.get(url, headers: mergedHeaders).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Connection timeout');
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': responseData['message'] ?? 'เกิดข้อผิดพลาด'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'data': null,
        'message': _getErrorMessage(e)
      };
    }
  }

  // Generic POST request
  Future<Map<String, dynamic>> post(String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('$baseURL$endpoint');
      final mergedHeaders = {..._headers, ...?headers};

      final response = await http.post(
        url,
        headers: mergedHeaders,
        body: json.encode(body),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Connection timeout');
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': responseData['message'] ?? 'เกิดข้อผิดพลาด'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'data': null,
        'message': _getErrorMessage(e)
      };
    }
  }

  // Generic PUT request
  Future<Map<String, dynamic>> put(String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('$baseURL$endpoint');
      final mergedHeaders = {..._headers, ...?headers};

      final response = await http.put(
        url,
        headers: mergedHeaders,
        body: json.encode(body),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Connection timeout');
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': responseData['message'] ?? 'เกิดข้อผิดพลาด'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'data': null,
        'message': _getErrorMessage(e)
      };
    }
  }

  // Generic DELETE request
  Future<Map<String, dynamic>> delete(String endpoint, {Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('$baseURL$endpoint');
      final mergedHeaders = {..._headers, ...?headers};

      final response = await http.delete(url, headers: mergedHeaders).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Connection timeout');
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        final responseData = response.body.isNotEmpty ? json.decode(response.body) : {};
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        final responseData = json.decode(response.body);
        return {
          'success': false,
          'data': null,
          'message': responseData['message'] ?? 'เกิดข้อผิดพลาด'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'data': null,
        'message': _getErrorMessage(e)
      };
    }
  }

  // Helper method to get user-friendly error messages
  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('SocketException')) {
      return 'ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้';
    } else if (error.toString().contains('timeout')) {
      return 'การเชื่อมต่อล้มเหลว (หมดเวลา)';
    } else if (error.toString().contains('FormatException')) {
      return 'ข้อมูลที่ได้รับจากเซิร์ฟเวอร์ไม่ถูกต้อง';
    } else {
      return 'เกิดข้อผิดพลาดในการเชื่อมต่อ';
    }
  }

  // Test connection
  Future<bool> testConnection() async {
    try {
      final url = Uri.parse('$baseURL/drugs/auth/login');
      final response = await http.head(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout');
        },
      );
      return response.statusCode < 500;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }
}
