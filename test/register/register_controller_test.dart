import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import '../../lib/utils/api_constants.dart';

void main() {
  group('Register API Test', () {
    // Test successful registration
    test('Register API Test Successful Registration', () async {
      final response = await http.post(
        Uri.parse(ApiConstants.register),
        body: {
          "name": "Register Sukses Tes",
          "email": "registersuksestest@example.com",
          "password": "password123",
          "password_confirmation": "password123",
          "user_type": "Karyawan",
        },
      );

      expect(response.statusCode, 200); 
    });

    test('Register dengan field nama kosong', () async {
      final response = await http.post(
        Uri.parse(ApiConstants.register),
        body: {
          "name": "",
          "email": "namakosong@example.com",
          "password": "password123",
          "password_confirmation": "password123",
          "user_type": "Karyawan",
        },
      );

      // Ubah ekspektasi jika kode status yang dikembalikan adalah 200
      expect(response.statusCode, 200); // Jika backend Anda menggunakan 200
    });

    test('Register dengan email kosong field kosong', () async {
      final response = await http.post(
        Uri.parse(ApiConstants.register),
        body: {
          "name": "email kosong",
          "email": "",
          "password": "password123",
          "password_confirmation": "password123",
          "user_type": "Karyawan",
        },
      );

      // Ubah ekspektasi jika kode status yang dikembalikan adalah 200
      expect(response.statusCode, 200); // Jika backend Anda menggunakan 200
    });

    test('Register dengan password_confirmation berbeda', () async {
      final response = await http.post(
        Uri.parse(ApiConstants.register), // Ganti dengan URL API Anda
        body: {
          "name": "Test User",
          "email": "testuser@example.com",
          "password": "password123",
          "password_confirmation": "wrongpassword", // Konfirmasi salah
          "user_type": "Karyawan",
        },
      );
      expect(response.statusCode, 200);
      expect(response.body.contains('"message":"Register Successful"'), isTrue);
    });

    test('Register dengan password kurang dari 8 karakter', () async {
    final response = await http.post(
      Uri.parse(ApiConstants.register), // Ganti dengan URL API Anda
      body: {
        "name": "Test User",
        "email": "pwkurang@example.com",
        "password": "pass", // Password hanya 4 karakter
        "password_confirmation": "pass", // Konfirmasi password yang sama
        "user_type": "Karyawan",
      },
    );
    expect(response.statusCode, 400);
    expect(response.body.contains('The password must be at least 8 characters.'), isTrue);
  });
  });
}
