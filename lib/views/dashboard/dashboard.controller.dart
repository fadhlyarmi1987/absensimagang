import 'package:absensimagang/route/page.dart';
import 'package:absensimagang/utils/storage.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../utils/api_constants.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
}

class DashboardController extends GetxController {
  final Storage _storage = Storage();
  var listhadir = <Map<String, dynamic>>[].obs;
  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    fetchAttendance();
  }

  void logout() {
    _storage.logout();
    Get.toNamed(Routes.init);
  }

  Future<void> fetchAttendance() async {
    try {
      final response =
          await _dio.get('${ApiConstants.baseUrl}${ApiConstants.listabsen}');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        // Mengelompokkan data berdasarkan userid dan memilih entri check-in dan check-out terbaru
        Map<String, Map<String, dynamic>> groupedData = {};

        for (var item in data) {
          String userid = item['userid'];
          String typetime = item['typetime'];
          DateTime time = DateTime.parse(item['time']);

          if (!groupedData.containsKey(userid)) {
            groupedData[userid] = {'check-in': null, 'check-out': null};
          }

          if (typetime == 'checkin') {
            if (groupedData[userid]!['checkin'] == null ||
                time.isAfter(
                    DateTime.parse(groupedData[userid]!['checkin']['time']))) {
              groupedData[userid]!['check-in'] = item;
            }
          } else if (typetime == 'checkout') {
            if (groupedData[userid]!['checkout'] == null ||
                time.isAfter(
                    DateTime.parse(groupedData[userid]!['checkout']['time']))) {
              groupedData[userid]!['check-out'] = item;
            }
          }
        }

        // Mengonversi hasil pengelompokan menjadi daftar
        List<Map<String, dynamic>> attendanceList =
            groupedData.values.map((entry) {
          DateTime date = entry['check-in'] != null
              ? DateTime.parse(entry['check-in']['time'])
              : DateTime.parse(entry['check-out']['time']);

          return {
            'date': DateFormat('EEEE, dd MMMM yyyy', 'id').format(date),
            'checkIn': entry['check-in'] != null
                ? DateFormat('HH:mm')
                    .format(DateTime.parse(entry['check-in']['time']))
                : '',
            'checkOut': entry['check-out'] != null
                ? DateFormat('HH:mm')
                    .format(DateTime.parse(entry['check-out']['time']))
                : '',
          };
        }).toList();

        // Mengurutkan data berdasarkan tanggal terbaru di bagian paling atas
        attendanceList.sort((a, b) {
          DateTime dateA =
              DateFormat('EEEE, dd MMMM yyyy', 'id').parse(a['date']);
          DateTime dateB =
              DateFormat('EEEE, dd MMMM yyyy', 'id').parse(b['date']);
          return dateB.compareTo(dateA); // Urutan menurun
        });

        listhadir.value = attendanceList;
      } else {
        // Menangani respons error
        print('Failed to load attendance data');
      }
    } catch (e) {
      // Menangani exception
      print('Exception occurred: $e');
    }
  }
}
