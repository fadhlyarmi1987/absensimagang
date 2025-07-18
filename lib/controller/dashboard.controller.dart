import 'package:absensimagang/route/page.dart';
import 'package:absensimagang/utils/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
}

class DashboardController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final Storage storage = Storage();
  var name = ''.obs;
  var email = ''.obs;
  var id = ''.obs;
  var listhadir = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    fetchAttendance();
  }

  void logout() {
    storage.logout();
    Get.offAllNamed(Routes.init);
  }

  Future<void> fetchUserData() async {
    try {
      // Ambil UID pengguna yang sedang login
      final User? user = auth.currentUser;
      if (user != null) {
        id.value = user.uid;

        // Ambil data pengguna dari Firestore
        final DocumentSnapshot userDoc =
            await firestore.collection('users').doc(user.email).get();

        if (userDoc.exists) {
          // Ambil nama dan email dari Firestore
          name.value = userDoc['name'] ?? 'Unknown';
          email.value = userDoc['email'] ?? 'Unknown';

          // Simpan ke local storage (opsional)
          storage.name(name.value);
          storage.email(email.value);
        } else {}
      } else {
        print('No user is currently logged in.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchAttendance() async {
    try {
      final userEmail = FirebaseAuth.instance.currentUser?.email;

      if (userEmail == null) {
        throw Exception("Pengguna tidak terdeteksi");
      }

      final snapshot = await firestore
          .collection('users')
          .doc(userEmail)
          .collection('absensi')
          .orderBy('timestamp', descending: true)
          .get();

      final Map<String, Map<String, String>> groupedData = {};

      for (var doc in snapshot.docs) {
        final docId = doc.id.toLowerCase();

        if (docId.contains("izin")) {
          final izinDate =
              docId.replaceAll("izin ", ""); 
          final date = DateFormat("dd-MM-yyyy").parse(izinDate);
          final formattedDate =
              DateFormat("EEEE, dd MMMM yyyy", "id_ID").format(date);

          groupedData[formattedDate] = {
            'checkIn': 'Izin',
            'checkOut': 'Izin',
            'date': formattedDate,
            'isIzin': 'true', // tambahkan flag khusus
          };
          continue;
        }

        final data = doc.data();
        if (data['timestamp'] == null || data['type'] == null) continue;

        final timestamp = (data['timestamp'] as Timestamp).toDate();
        final formattedDate =
            DateFormat("EEEE, dd MMMM yyyy", "id_ID").format(timestamp);
        final dateKey = formattedDate;

        if (!groupedData.containsKey(dateKey)) {
          groupedData[dateKey] = {
            'checkIn': '-',
            'checkOut': '-',
            'date': dateKey,
          };
        }

        if (data['type'] == 'check-in') {
          groupedData[dateKey]!['checkIn'] =
              "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
        } else if (data['type'] == 'check-out') {
          groupedData[dateKey]!['checkOut'] =
              "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
        }
      }

      listhadir.value = groupedData.values.toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil data absensi: $e');
    }
  }
}
