import 'package:dio/dio.dart';

class MapController {
  final Dio dio = Dio();

  Future<String> sendAttendanceData({
    required String userid,
    required String typetime,
    required String time,
    required double latitude,
    required double longitude,
    required int kantorid,
  }) async {
    try {
      Map<String, dynamic> data = {
        'userid': userid,
        'typetime': typetime,
        'time': time,
        'latitude': latitude,
        'longitude': longitude,
        'kantorid': kantorid,
      };

      String url = 'http://192.168.64.139:8000/api/listabsen';

      var response = await dio.post(url, data: data);

      if (response.statusCode == 201) {
        return 'Data berhasil dikirim';
      } else {
        return 'Gagal mengirim data';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
