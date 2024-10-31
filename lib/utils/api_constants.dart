import 'package:absensimagang/utils/storage.dart';
import '../views/dashboard/edit.profile.dart';

class ApiConstants {
  ApiConstants._();
  
  static const String baseUrl = "http://192.168.1.6:8000/api/";

  //192.168.1.7 wifi kontrakan


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