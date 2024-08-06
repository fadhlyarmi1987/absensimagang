import 'package:dio/dio.dart';
import 'package:absensimagang/utils/api_constants.dart';
import 'package:flutter/material.dart'; 

class MapController {
  final Dio dio = Dio();

  Future<String> sendAttendanceData({
    required String userid,
    required String name,
    required String typetime,
    required String time,
    required double latitude,
    required double longitude,
    required int kantorid,
  }) async {
    try {
      Map<String, dynamic> data = {
        'userid': userid,
        'name' : name,
        'typetime': typetime,
        'time': time,
        'latitude': latitude,
        'longitude': longitude,
        'kantorid': kantorid,
      };

      var response = await dio.post(ApiConstants.listabsen, data: data);

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

