import 'package:absensimagang/utils/storage.dart';
import '../views/dashboard/edit.profile.dart';

class ApiConstants {
  ApiConstants._();
  
  static const String baseUrl = "http://192.168.2.32:8000/api/";

  //"http://192.168.64.139:8000/api/"; hotspot
  //"http://192.168.2.91:8000/api/"; wifikantor
  //192.168.100.20:8000/api/
  //http://192.168.2.95/
  //http://192.168.2.32:8000
  //http://103.31.39.244


  static const String login  = "login";
  static const String register = "register";
  static const String listabsen = "listabsen";
  static const String listabsen2 = "listabsen2";
  static const String absen = "absen";
  static const String notifications = "notifications";
  static const String file = "files";
  static const String user = "users";
  static String fileDownload(String id) => "files/$id";

}