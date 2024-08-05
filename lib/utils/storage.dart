import 'package:get_storage/get_storage.dart';

class Storage {
  final GetStorage _storage = GetStorage();

  void login() => _storage.write("isLogin", true);
  bool isLogin() => _storage.read<bool>("isLogin") ?? false;
  void name(String name) => _storage.write('name', name);
  String? getName([userData]) => _storage.read<String>('name' ?? 'unkwon'); 

  void logout() => _storage.remove('isLogin');

  
  
}