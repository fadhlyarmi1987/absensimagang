import 'package:absensimagang/utils/api_constants.dart';
import 'package:dio/dio.dart';

import '../../utils/log.dart';
import '../providers/api.provider.dart';

class Map2Service {
  // panggil class HttpClient yang sudah disetting di providers/api.provider.dart
  final HttpClient _httpClient = HttpClient();

  // rest-api checkIn
  Future<bool> checkIn(Map<String, dynamic> parameterData) async {
    try {
      // proses interaksi dengan server
      Response response = await _httpClient.post(ApiConstants.absen, data: parameterData);
      final responseBody = response.data;

      if (response.statusCode == 201 || response.statusCode == 200){
        // menampilkan response json di logcat
        Log.d('$responseBody');
        return true;
      } else {
        Log.e('Gagal mengirim data ke database');
        return false;
      }
      
    } on DioException catch (_) {
      Log.e(_.message.toString());
      return false;
    }
  }

  // rest-api checkOut
  Future<bool> checkOut(Map<String, dynamic> parameterData) async {
    try {
      Response response = await _httpClient.post(ApiConstants.absen, data: parameterData);
      final responseBody = response.data;

      if (response.statusCode == 201 || response.statusCode == 200){
        Log.d('$responseBody');
        return true;
      } else {
        Log.e('Gagal mengirim data ke database');
        return false;
      }
      
    } on DioException catch (_) {
      Log.e(_.message.toString());
      return false;
    }
  }
}