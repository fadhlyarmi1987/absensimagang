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
    // kalau hanya memanggil storage tidak perlu await
    String? currentName = await Storage().getName();
    // kalau officeMeriPosition akan dibuat dibanyak fungsi makan lebih baik ditaruh di luar fungsi ini (sendDataToDatabaseMeri) supaya tidak Boilerpate
    LatLng officeMeriPosition = LatLng(-7.482906085307217, 112.44929725580936);
    // begitupun juga dengan HttpClient, jika nanti dibuat banyak lebih baik ditaruh di luar fungsi 
    HttpClient httpClient = HttpClient();

    final dio = Dio();
    final String apiUrl = '${ApiConstants.baseUrl}${ApiConstants.absen}';
    // noted: kalau sudah menggunakan HttpClient tidak perlu memanggil Dio lagi, karena Dio sudah di set di HttpClient
    // dan juga untuk url tidak perlu dengan baseUrl nya karena di HttpClient sudah di set baseUrl nya,
    // jadi cukup `await httpClient.post('absen', data: ....);` atau variable seperti: ApiConstants.absen
    try {
      var response = await httpClient.post(apiUrl, data: {
        'name': currentName,
        'typetime': 'checkin',
        'latitude': officeMeriPosition.latitude,
        'longitude': officeMeriPosition.longitude,
        'kantorid': 'Meri'
      });

      // httpStatusCode 2xx itu success jadi gunakan OR untuk sebuah kondisi
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Data berhasil dikirim ke database');
        // noted:
        //Jangan menggunakan BuildContext setelah jeda asynchronous (seperti setelah await). 
        //Flutter memberikan peringatan ini karena BuildContext yang digunakan setelah await mungkin tidak lagi valid. 
        //Hal ini bisa terjadi jika widget yang terkait dengan BuildContext tersebut telah dihapus dari tree widget atau digantikan oleh widget lain selama operasi asynchronous.
        //Kenapa tidak boleh menggunakan BuildContext setelah async gaps?
        //Ketika sebuah operasi asynchronous terjadi (misalnya, ketika Anda menunggu await), ada kemungkinan bahwa framework Flutter dapat menghapus atau menggantikan widget yang terkait dengan BuildContext tersebut. Jika Anda mencoba menggunakan BuildContext yang sudah tidak terkait dengan widget manapun, Anda bisa mendapatkan error atau perilaku tak terduga.
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

      if (response.statusCode == 200 || response.statusCode == 201) {
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

      if (response.statusCode == 200 || response.statusCode == 201) {
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

      if (response.statusCode == 200 || response.statusCode == 201) {
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
