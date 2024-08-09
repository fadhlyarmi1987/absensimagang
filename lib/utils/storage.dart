import 'package:get_storage/get_storage.dart';

class Storage {
  final GetStorage _storage = GetStorage();

  void login() => _storage.write("isLogin", true);

  bool isLogin() => _storage.read<bool>("isLogin") ?? false;

  void name(String name) => _storage.write('name', name);

  String? getName() => _storage.read<String>('name') ?? 'unknown';

  void email(String email) => _storage.write('username', email);

  String? getEmail() => _storage.read<String>('username') ?? 'unknown';

  void password(String password) => _storage.write('password', password);

  String? getPassword() => _storage.read<String>('password') ?? 'unknown';

  void logout() {
    _storage.remove('isLogin');
    _storage.remove('name');
  }
}
