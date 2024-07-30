import 'package:dio/dio.dart';
import '../model/user.dart';

class AuthService {
  final Dio _dio = Dio();

  AuthService() {
    _dio.options.baseUrl = 'http://192.168.1.20:8000/api';
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  Future<void> register(User user) async {
    try {
      final response = await _dio.post('/register', data: user.toJson());

      if (response.statusCode == 201) {
        print('User registered successfully');
      } else {
        throw Exception('Failed to register user');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print('Error sending request!');
        print(e.message);
      }
      throw Exception('Failed to register user');
    }
  }
}
