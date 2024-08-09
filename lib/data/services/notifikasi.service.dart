import 'package:dio/dio.dart';
import '../../utils/api_constants.dart';

class NotificationService {
  final Dio _dio = Dio();

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    try {
      final String apiUrl = '${ApiConstants.baseUrl}${ApiConstants.notifications}';
      final response = await _dio.get(apiUrl);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((item) => {
          'pengumuman': item['pengumuman'] as String,
          'created_at': item['created_at'] as String,
        }).toList();
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      throw Exception('Failed to load notifications: $e');
    }
  }
}
