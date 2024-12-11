
import 'package:absensimagang/utils/api_constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Model dan fungsi yang digunakan untuk login
class MockClient extends Mock implements http.Client {}

void main() {
  group('Login API Test', () {
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
    });

    test('Login Success Test', () async {
      // Mocking response sukses dari API login
      when(() => mockClient.post(
        Uri.parse(ApiConstants.login),
        body: {
          'email': 'testuser@example.com',
          'password': 'password123',
        },
      )).thenAnswer((_) async => http.Response(
            json.encode({
              'token': 'your_token_here',
            }),
            200,
          ));

      // Kirim request login
      final response = await mockClient.post(
        Uri.parse(ApiConstants.login),
        body: {
          'email': 'testuser@example.com',
          'password': 'password123',
        },
      );

      // Mengecek apakah status code 200 dan token ada di respons
      expect(response.statusCode, 200);
      final jsonResponse = json.decode(response.body);
      expect(jsonResponse['token'], isNotNull);
    });

    test('Login Failure Test', () async {
      // Mocking response gagal dari API login
      when(() => mockClient.post(
        Uri.parse(ApiConstants.login),
        body: {
          'email': 'wronguser@example.com',
          'password': 'wrongpassword',
        },
      )).thenAnswer((_) async => http.Response(
            json.encode({
              'message': 'Unauthorized',
            }),
            401,
          ));

      // Kirim request login
      final response = await mockClient.post(
        Uri.parse(ApiConstants.login),
        body: {
          'email': 'wronguser@example.com',
          'password': 'wrongpassword',
        },
      );

      // Mengecek apakah status code 401 dan pesan error muncul
      expect(response.statusCode, 401);
      final jsonResponse = json.decode(response.body);
      expect(jsonResponse['message'], 'Unauthorized');
    });
  });
}
 