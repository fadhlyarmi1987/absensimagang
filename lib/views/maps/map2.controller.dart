import 'package:absensimagang/data/services/map2.service.dart';
import 'package:absensimagang/views/maps/map.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../route/page.dart';
import '../../utils/storage.dart';

class Map2Binding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Map2Controller());
  }
}

class Map2Controller extends GetxController {
  // panggil Map2Service
  final Map2Service _service = Map2Service();
  // panggil Storage untuk mengambil Data yang di simpan di Local Storage
  final Storage _storage = Storage();

  // buat variable untuk menampung Data nama (kebetulan menggunakan method dari getx)
  RxString name = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // inisialisasi value name, data dari Local Storage 
    name.value = _storage.getName() ?? '';
  }

  Future<void> checkIn(String kantorId, double latitude, double longitude) async {
    // panggil checkIn di Map2Service untuk melakukan interaksi dengan Server (Rest-API)
    bool result = await _service.checkIn({
      'name': name.value,
      'typetime': 'checkin',
      'latitude': latitude,
      'longitude': longitude,
      'kantorid': kantorId,
    });

    // jika checkIn success
    if (result) {
      // maka dialog success di panggil
      showSuccessDialog(name.value, true);
    } else {
      // jika checkIn failed
      showFailedDialog();
    }
  }

  Future<void> checkOut(String kantorId, double latitude, double longitude) async {
    // panggil checkOut di Map2Service untuk melakukan interaksi dengan Server (Rest-API)
    bool result = await _service.checkOut({
      'name': name.value,
      'typetime': 'checkout',
      'latitude': latitude,
      'longitude': longitude,
      'kantorid': kantorId,
    });

    // jika checkOut success
    if (result) {
      // maka dialog success di panggil
      showSuccessDialog(name.value, false);
    } else {
      // jika checkIn failed
      showFailedDialog();
    }
  }

  void showSuccessDialog(String name, bool checkIn) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Column(
              children: [
                AnimatedCheckmark(),
                const SizedBox(height: 10),
                const Text(
                  'BERHASIL',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Natusi $name Absen ${checkIn ? 'Masuk' : 'Pulang'}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Get.offAllNamed(Routes.dahsboard);
              },
            ),
          ],
        );
      },
    );
  }

  void showFailedDialog() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Column(
              children: [
                FadeInXMark(),
                const SizedBox(height: 10),
                const Text(
                  'ERROR !!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Gagal mengirim Data!'),
              SizedBox(height: 20),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

}