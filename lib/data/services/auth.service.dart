import 'package:absensimagang/utils/api_constants.dart';
import 'package:dio/dio.dart';

import '../providers/api.provider.dart';

class AuthService {
  HttpClient httpClient = HttpClient();

  Future<bool> login(Map<String, dynamic> data) async {
    try {
      Response response = await httpClient.post(ApiConstants.login, data: data);
      var responseBody = response.data;
      if (responseBody['metaData']['code'] == 200) {
        return true;
      } else {
        return false;
      }
      
    } on DioError catch(_) {
      throw Exception(_.message);
    }
  }

  Future<bool> register(Map<String, dynamic> data) async {
    try {
      Response response = await httpClient.post(ApiConstants.register, data: data);
      var responseBody = response.data;
      if (responseBody['metaData']['code'] == 200) {
        return true;
      } else {
        return false;
      }
      
    } on DioError catch(_) {
      throw Exception(_.message);
    }
  }


}