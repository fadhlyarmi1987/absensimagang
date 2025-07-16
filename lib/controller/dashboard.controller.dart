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
        } else {
        }
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

    // Query data absensi dari subkoleksi absensi sesuai user.email
    final snapshot = await firestore
        .collection('users')
        .doc(userEmail) // Ambil dokumen berdasarkan user.email
        .collection('absensi') // Subkoleksi absensi
        .orderBy('timestamp', descending: true) // Urutkan berdasarkan waktu (dari yang terbaru)
        .get();

    // Map untuk menyimpan data berdasarkan tanggal
    final Map<String, Map<String, String>> groupedData = {};

    // Proses dokumen dari Firestore
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final timestamp = (data['timestamp'] as Timestamp).toDate();
      final formattedDate = DateFormat("EEEE, dd MMMM yyyy", "id_ID").format(timestamp);
      final dateKey = "${formattedDate}";

      // Cek tipe absensi dan simpan di map
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

    // Konversi map ke list
    listhadir.value = groupedData.values.toList();
  } catch (e) {
    Get.snackbar('Error', 'Gagal mengambil data absensi: $e');
  }
}

}
