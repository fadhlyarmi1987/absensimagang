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
  var name = ''.obs;
  var listhadir = <Map<String, dynamic>>[].obs;
  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    fetchAttendance();
    name.value = _storage.getName()??"";

    print(name);
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

        Map<String, Map<String, dynamic>> groupedData = {};

        for (var item in data) {
          String typetime = item['typetime'];
          DateTime time = DateTime.parse(item['created_at']);
          String dateKey = DateFormat('yyyy-MM-dd').format(time);

          if (!groupedData.containsKey(dateKey)) {
            groupedData[dateKey] = {'date': dateKey, 'check-in': null, 'check-out': null};
          }

          if (typetime == 'checkin') { 
            if (groupedData[dateKey]!['check-in'] == null ||
                time.isAfter(
                    DateTime.parse(groupedData[dateKey]!['check-in']['created_at']))) {
              groupedData[dateKey]!['check-in'] = item;
            }
          } else if (typetime == 'checkout') { 
            if (groupedData[dateKey]!['check-out'] == null ||
                time.isAfter(
                    DateTime.parse(groupedData[dateKey]!['check-out']['created_at']))) {
              groupedData[dateKey]!['check-out'] = item;
            }
          }
        }

        List<Map<String, dynamic>> attendanceList =
            groupedData.values.map((entry) {
          DateTime date = DateTime.parse(entry['date']);

          return {
            'date': DateFormat('EEEE, dd MMMM yyyy', 'id').format(date),
            'checkIn': entry['check-in'] != null
                ? DateFormat('HH:mm')
                    .format(DateTime.parse(entry['check-in']['created_at']))
                : '',
            'checkOut': entry['check-out'] != null
                ? DateFormat('HH:mm')
                    .format(DateTime.parse(entry['check-out']['created_at']))
                : '',
          };
        }).toList();

        attendanceList.sort((a, b) {
          DateTime dateA =
              DateFormat('EEEE, dd MMMM yyyy', 'id').parse(a['date']);
          DateTime dateB =
              DateFormat('EEEE, dd MMMM yyyy', 'id').parse(b['date']);
          return dateB.compareTo(dateA); // Urutan menurun
        });

        listhadir.value = attendanceList;
      } else {
        print('Failed to load attendance data');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  void setName(String userName) {
    name.value = userName;
  }
}
