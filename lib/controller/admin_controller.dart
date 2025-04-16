import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxMap<String, List<Map<String, dynamic>>> attendanceData = RxMap();
  RxMap<String, List<Map<String, dynamic>>> filteredAttendanceData = RxMap();

  // Tanggal yang dipilih
  Rx<DateTime> selectedDate = DateTime.now().obs;

  get monthlyCheckIn => null;

  @override
  void onInit() {
    super.onInit();
    fetchAttendanceData();
    listenForNotifications();
  }

  void filterAttendanceByMonth() {
    // Ambil bulan dan tahun dari tanggal terpilih
    int selectedMonth = selectedDate.value.month;
    int selectedYear = selectedDate.value.year;

    // Filter data absensi berdasarkan bulan dan tahun
    Map<String, List<Map<String, dynamic>>> data = {};
    filteredAttendanceData.value = data.map((key, value) {
      List<Map<String, dynamic>> filtered = value.where((attendance) {
        DateTime timestamp = attendance['timestamp'];
        return timestamp.month == selectedMonth &&
            timestamp.year == selectedYear;
      }).toList();
      return MapEntry(key, filtered);
    });
  }

  Future<void> fetchAttendanceData() async {
    try {
      final usersSnapshot = await firestore.collection('users').get();

      for (var userDoc in usersSnapshot.docs) {
        final userEmail = userDoc['email'];
        final attendanceSnapshot = await firestore
            .collection('users')
            .doc(userEmail)
            .collection('absensi')
            .get();

        List<Map<String, dynamic>> userAttendances = [];
        for (var doc in attendanceSnapshot.docs) {
          final data = doc.data();
          final timestamp = data['timestamp'];

          if (timestamp != null && timestamp is Timestamp) {
            userAttendances.add({
              'name': userDoc['name'],
              'email': userEmail,
              'office': data['office'],
              'type': data['type'] ?? 'unknown',
              'timestamp': timestamp.toDate(),
            });
          }
        }

        if (attendanceData.containsKey(userDoc['name'])) {
          attendanceData[userDoc['name']]?.addAll(userAttendances);
        } else {
          attendanceData[userDoc['name']] = userAttendances;
        }
      }

      filterAttendanceByDate();
    } catch (e) {
      print('Error fetching attendance data: $e');
    }
  }

  void filterAttendanceByDate() {
    final date = selectedDate.value;
    filteredAttendanceData.clear();

    attendanceData.forEach((key, value) {
      final filtered = value.where((attendance) {
        final timestamp = attendance['timestamp'] as DateTime?;
        return timestamp != null &&
            timestamp.year == date.year &&
            timestamp.month == date.month &&
            timestamp.day == date.day;
      }).toList();

      if (filtered.isNotEmpty) {
        filteredAttendanceData[key] = filtered;
      }
    });

    calculateAttendanceCount();
    calculateAttendanceCount();
  }

  void calculateAttendanceCount() {
    filteredAttendanceData.forEach((key, value) {
      int attendanceCount = 0;
      for (var attendance in value) {
        if (attendance['type'] == 'check-in') {
          // Pastikan ada check-out yang berpasangan
          bool hasCheckOut = value.any((a) =>
              a['type'] == 'check-out' &&
              a['timestamp'].isAfter(attendance['timestamp']));
          if (hasCheckOut) {
            attendanceCount++;
          }
        }
      }
      filteredAttendanceData[key] = value.map((a) {
        a['attendanceCount'] = attendanceCount;
        return a;
      }).toList();
    });
  }

  void listenForNotifications() {
    FirebaseFirestore.instance
        .collection('notifications')
        .where('status',
            isEqualTo:
                'unread') // Hanya menampilkan notifikasi yang belum dibaca
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        String title = doc['title']; // Ambil judul notifikasi
        String body = doc['body']; // Ambil isi notifikasi
        String token =
            doc['token']; // Ambil token perangkat yang menerima notifikasi

        print("Admin received notification: $title - $body");

        // Menampilkan notifikasi di UI
        showNotification(title, body);

        // Setelah membaca, perbarui status notifikasi menjadi 'read'
        doc.reference.update({'status': 'read'});
      }
    });
  }

// Fungsi untuk menampilkan notifikasi (gunakan package lain seperti flutter_local_notifications)
  void showNotification(String title, String body) {
    // Implementasi menampilkan notifikasi lokal (gunakan flutter_local_notifications)
    print("Showing notification: $title - $body");
    // Anda bisa menambahkan kode untuk menggunakan flutter_local_notifications disini
  }
}
