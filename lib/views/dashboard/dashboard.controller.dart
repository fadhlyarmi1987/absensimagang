import 'package:absensimagang/route/page.dart';
import 'package:absensimagang/utils/storage.dart';
import 'package:get/get.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
}

class DashboardController extends GetxController {

  final Storage _storage = Storage();
  void logout() {
    _storage.logout();
    Get.toNamed(Routes.init);
  }

  var listhadir = [
    {
      'date': 'Kamis, 18 Juli 2024',
      'checkIn': '07.45',
      'checkOut': '17.10',
    },
    {
      'date': 'Rabu, 17 Juli 2024',
      'checkIn': '07.45',
      'checkOut': '17.10',
    },
    {
      'date': 'Selasa, 16 Juli 2024',
      'checkIn': '07.45',
      'checkOut': '17.10',
    },
    {
      'date': 'Senin, 15 Juli 2024',
      'checkIn': '07.45',
      'checkOut': '17.10',
    },
    {
      'date': 'Jumat, 12 Juli 2024',
      'checkIn': '07.45',
      'checkOut': '17.20',
    },
  ].obs;
}
