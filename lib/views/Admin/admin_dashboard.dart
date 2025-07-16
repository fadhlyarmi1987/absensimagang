import 'package:absensimagang/controller/admin_controller.dart';
import 'package:absensimagang/views/Admin/admin_home.dart';
import 'package:absensimagang/views/Admin/atur_lokasi.dart';
import 'package:absensimagang/views/Admin/list_karyawan_page.dart';
import 'package:absensimagang/views/Admin/aturwaktu_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/dashboard.controller.dart';
import 'halaman_notifikasi.dart';

class AdminDashboard extends StatelessWidget {
  final AdminController adminController = Get.put(AdminController());
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    // State untuk navigasi bottom bar
    RxInt selectedIndex = 0.obs;

    // Daftar halaman untuk setiap item bottom bar
    final List<Widget> pages = [
      AdminPage(),
      ListKaryawanPage(),
      SendNotificationPage(),
      AturWaktu(), 
      AturLokasiPage(),

    ];

    return Scaffold(
      body: Obx(() {
        return pages[selectedIndex.value];
      }),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: selectedIndex.value,
            onTap: (index) {
              selectedIndex.value = index;
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.table_chart),
                label: 'Data Absensi',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Kirim Notifikasi', // Label untuk menu notifikasi
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.access_time_filled),
                label: 'atur waktu',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'atur lokasi',
              ),
            ],
            selectedItemColor: const Color.fromARGB(255, 114, 90, 90),
            unselectedItemColor: Colors.grey,
          )),
    );
  }
}
