import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/admin_controller.dart';
import '../../controller/dashboard.controller.dart';

class AdminPage extends StatelessWidget {
  final AdminController adminController = Get.put(AdminController());
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Halaman Admin"),
        backgroundColor: Colors.red.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    title: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.redAccent),
                        SizedBox(width: 10),
                        Text("Konfirmasi Logout"),
                      ],
                    ),
                    content:
                        Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("Batal"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          controller.logout();
                        },
                        child: Text("Keluar",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromARGB(255, 193, 193, 193),
        child: Column(
          children: [
            // Input untuk memilih tanggal
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pilih Tanggal:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Obx(() {
                    return GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: adminController.selectedDate.value,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          adminController.selectedDate.value = pickedDate;
                          adminController.filterAttendanceByDate();
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 178, 220, 255),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          DateFormat('dd MMM yyyy')
                              .format(adminController.selectedDate.value),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (adminController.filteredAttendanceData.isEmpty) {
                  return const Center(
                    child: Text("Tidak ada data absensi untuk tanggal ini."),
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.white,
                        child: DataTable(
                          columnSpacing: 20,
                          headingRowColor:
                              MaterialStateProperty.all(Colors.red.shade700),
                          dataRowColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.red.shade100;
                              }
                              return Colors.red.shade50;
                            },
                          ),
                          headingTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          columns: const [
                            DataColumn(label: Text('Nama')),
                            DataColumn(label: Text('Kantor')),
                            DataColumn(label: Text('Check-in')),
                            DataColumn(label: Text('Check-out')),
                            DataColumn(label: Text('Status')),
                          ],
                          rows: _getSortedAttendanceRows(),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<DataRow> _getSortedAttendanceRows() {
    return adminController.filteredAttendanceData.entries.map((entry) {
      String userName = entry.key;
      List<Map<String, dynamic>> userAttendances = entry.value;

      DateTime? checkInTime;
      DateTime? checkOutTime;

      // Hanya ambil data 'check-in' dan 'check-out'
      for (var attendance in userAttendances) {
        if (attendance['type'] == 'check-in') {
          checkInTime = attendance['timestamp'];
        } else if (attendance['type'] == 'check-out') {
          checkOutTime = attendance['timestamp'];
        }
      }

      // Pastikan checkInTime ada sebelum sorting
      if (checkInTime != null) {
        userAttendances.sort((a, b) {
          DateTime aCheckIn =
              a['type'] == 'check-in' ? a['timestamp'] : DateTime(0);
          DateTime bCheckIn =
              b['type'] == 'check-in' ? b['timestamp'] : DateTime(0);
          return bCheckIn.compareTo(bCheckIn); // Descending order
        });
      }

      String formatAttendanceDate(DateTime? dateTime) {
        if (dateTime == null) return '-';
        return DateFormat('EEEE, dd MMM yyyy\nHH:mm', 'id_ID').format(dateTime);
      }

      // Cek apakah karyawan sudah check-in dan check-out
      bool isCheckedIn = checkInTime != null;
      bool isCheckedOut = checkOutTime != null;

      return DataRow(
        cells: [
          DataCell(Text(userName)),
          DataCell(Text(userAttendances[0]['office'] ?? 'Tidak tersedia')),
          DataCell(Text(formatAttendanceDate(checkInTime))),
          DataCell(Text(formatAttendanceDate(checkOutTime))),
          DataCell(
            Icon(
              (isCheckedIn && isCheckedOut)
                  ? Icons.check_circle_outline
                  : Icons.check_circle_outline_outlined,
              color: (isCheckedIn && isCheckedOut)
                  ? Colors.green
                  : const Color.fromARGB(255, 198, 198, 198),
            ),
          ),
        ],
      );
    }).toList();
  }
}
