import 'package:absensimagang/utils/api_constants.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../providers/api.provider.dart';

class AuthService {
  HttpClient httpClient = HttpClient();

  Future<bool> login(Map<String, dynamic> data) async {
    try {
      dio.Response response = await httpClient.post(ApiConstants.login, data: data);
      var responseBody = response.data;
      if (responseBody['metaData']['code'] == 200) {
        return true;
      } else {
        return false;
      }
    } on dio.DioException catch(_) {
      //throw Exception(_.message);
      Get.snackbar(
        'Login Gagal', 
        'Silakan coba lagi!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
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


}