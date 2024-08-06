import 'package:get_storage/get_storage.dart';

class Storage {
  final GetStorage _storage = GetStorage();

  void login() => _storage.write("isLogin", true);

  bool isLogin() => _storage.read<bool>("isLogin") ?? false;

  void name(String name) => _storage.write('name', name);

  String? getName() => _storage.read<String>('name') ?? 'unknown';

  void logout() {
    _storage.remove('isLogin');
    _storage.remove('name'); // Menghapus nama saat logout (opsional)
  }
}
