import 'package:absensimagang/model/attended.dart';
import 'package:absensimagang/utils/api_constants.dart';
import 'package:absensimagang/utils/storage.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../providers/api.provider.dart';

class AuthService {
  HttpClient httpClient = HttpClient();
  Storage storage = Storage();

  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
  try {
    dio.Response response = await httpClient.post(ApiConstants.login, data: data);
    var responseBody = response.data;
    if (responseBody['metaData']['code'] == 200) {
      storage.name(responseBody['response']['name']);
      return {
        'success': true,
        'name': responseBody['response']['name'] ?? 'Pengguna'
      };
    } else {
      return {'success': false, 'name': null};
    }
  } on dio.DioException catch(_) {
    Get.snackbar(
      'Login Gagal', 
      'Silakan coba lagi!',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
    return {'success': false, 'name': null};
  }
}


  Future<bool> register(Map<String, dynamic> data) async {
    try {
      dio.Response response = await httpClient.post(ApiConstants.register, data: data);
      var responseBody = response.data;
      if (responseBody['metaData']['code'] == 200) {
        return true;
      } else {
        return false;
      }
    } on dio.DioException catch(_) {
      //throw Exception(_.message);
      Get.snackbar(
        'Register Gagal', 
        'Silakan coba lagi!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  Future<List<Attended>> ListAbsen(Map<String, dynamic> data) async {
    try {
      dio.Response response = await httpClient.get(ApiConstants.listabsen);
      var responseBody = response.data;
      if (responseBody['metaData']['code'] == 200) {
        return responseBody.data;
      } else {
        return [];
      }
    } on dio.DioException catch(_) {
      //throw Exception(_.message);
      Get.snackbar(
        'Register Gagal', 
        'Silakan coba lagi!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return [];
    } catch (e, stackTrace) {
      print('error : $e');
      print('stackTrace: $stackTrace');
      return[];
    }
  }


}