class ApiConstants {
  ApiConstants._();
  
  // Base URL API
  static const String baseUrl = "http://192.168.1.2:8000/api";

  // Endpoint statis
  static const String login = "$baseUrl/login";
  static const String register = "$baseUrl/register";
  static const String listAbsen = "$baseUrl/listabsen";
  static const String listAbsen2 = "$baseUrl/listabsen2";
  static const String absen = "$baseUrl/absen";
  static const String notifications = "$baseUrl/notifications";
  static const String files = "$baseUrl/files";
  static const String users = "$baseUrl/users";

  // Endpoint dinamis dengan parameter
  static String fileDownload(String id) => "$baseUrl/files/$id";

  // Tambahan untuk mempermudah debugging
  static void printAllEndpoints() {
    print('Base URL: $baseUrl');
    print('Login: $login');
    print('Register: $register');
    print('List Absen: $listAbsen');
    print('List Absen 2: $listAbsen2');
    print('Absen: $absen');
    print('Notifications: $notifications');
    print('Files: $files');
    print('Users: $users');
  }
}
