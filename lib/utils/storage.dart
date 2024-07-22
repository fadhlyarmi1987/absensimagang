import 'package:get_storage/get_storage.dart';

class Storage {
  final GetStorage _storage = GetStorage();

  void login() => _storage.write("isLogin", true);
  bool isLogin() => _storage.read<bool>("isLogin") ?? false;

  void logout() => _storage.remove('isLogin');
  
}