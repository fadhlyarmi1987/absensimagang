// lib/data/view_models/map_view_model.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../utils/api_constants.dart';
import '../../utils/storage.dart';
import '../../views/maps/map.controller.dart';
import '../providers/api.provider.dart';

class MapViewModel {
  Future<void> sendDataToDatabaseMeri(BuildContext context) async {
    String? currentName = await Storage().getName();
    LatLng officeMeriPosition = LatLng(-7.482906085307217, 112.44929725580936);
    HttpClient httpClient = HttpClient();

    final dio = Dio();
    final String apiUrl = '${ApiConstants.baseUrl}${ApiConstants.absen}';

    try {
      var response = await httpClient.post(apiUrl, data: {
        'name': currentName,
        'typetime': 'checkin',
        'latitude': officeMeriPosition.latitude,
        'longitude': officeMeriPosition.longitude,
        'kantorid': 'Meri'
      });

      if (response.statusCode != 200) {
        print('Data berhasil dikirim ke database');
        MapController()
            .showSuccessDialog(context, currentName ?? "", officeMeriPosition);
      } else {
        print('Gagal mengirim data ke database');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> sendDataToDatabaseGraha(BuildContext context) async {
    String? currentName = await Storage().getName();
    LatLng officeGrahaPosition = LatLng(-7.491750, 112.461981);
    HttpClient httpClient = HttpClient();

    final dio = Dio();
    final String apiUrl = '${ApiConstants.baseUrl}${ApiConstants.absen}';

    try {
      var response = await httpClient.post(apiUrl, data: {
        'name': currentName,
        'typetime': 'checkin',
        'latitude': officeGrahaPosition.latitude,
        'longitude': officeGrahaPosition.longitude,
        'kantorid': 'Graha'
      });

      if (response.statusCode == 200) {
        print('Data berhasil dikirim ke database');
        MapController()
            .showSuccessDialog(context, currentName ?? "", officeGrahaPosition);
      } else {
        print('Gagal mengirim data ke database');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> sendDataToDatabaseMeriCheckout(BuildContext context) async {
    String? currentName = await Storage().getName();
    LatLng officeMeriPosition = LatLng(-7.482906085307217, 112.44929725580936);
    HttpClient httpClient = HttpClient();

    final dio = Dio();
    final String apiUrl = '${ApiConstants.baseUrl}${ApiConstants.absen}';

    try {
      var response = await httpClient.post(apiUrl, data: {
        'name': currentName,
        'typetime': 'checkout',
        'latitude': officeMeriPosition.latitude,
        'longitude': officeMeriPosition.longitude,
        'kantorid': 'Meri'
      });

      if (response.statusCode == 200) {
        print('Data berhasil dikirim ke database');
        MapController()
            .showSuccessDialog(context, currentName ?? "", officeMeriPosition);
      } else {
        print('Gagal mengirim data ke database');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> sendDataToDatabaseGrahaCheckout(BuildContext context) async {
    String? currentName = await Storage().getName();
    LatLng officeGrahaPosition = LatLng(-7.491750, 112.461981);
    HttpClient httpClient = HttpClient();

    final dio = Dio();
    final String apiUrl = '${ApiConstants.baseUrl}${ApiConstants.absen}';

    try {
      var response = await httpClient.post(apiUrl, data: {
        'name': currentName,
        'typetime': 'checkout',
        'latitude': officeGrahaPosition.latitude,
        'longitude': officeGrahaPosition.longitude,
        'kantorid': 'Graha'
      });

      if (response.statusCode == 200) {
        print('Data berhasil dikirim ke database');
        MapController()
            .showSuccessDialog(context, currentName ?? "", officeGrahaPosition);
      } else {
        print('Gagal mengirim data ke database');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
