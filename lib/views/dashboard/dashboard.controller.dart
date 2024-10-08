import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../route/page.dart';
import '../../utils/api_constants.dart';
import '../../utils/storage.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
}

class DashboardController extends GetxController {
  final Storage storage = Storage();
  var name = ''.obs;
  var email = ''.obs;
  var id = ''.obs;
  var listhadir = <Map<String, dynamic>>[].obs; // RxList for attendance data
  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    fetchAttendance(); // Initial fetch
    // Optionally set up a periodic fetch if needed
    // Timer.periodic(Duration(minutes: 5), (_) => fetchAttendance());
    
    // Initialize user data
    name.value = storage.getName() ?? "";
    email.value = storage.getEmail() ?? "";
    id.value = storage.getId().toString();
    print(name);
  }

  void logout() {
    storage.logout();
    Get.offAllNamed(Routes.init); // Use Get.offAllNamed to clear navigation stack
  }

  Future<void> fetchAttendance() async {
    name.value = storage.getName() ?? "";
    try {
      final response = await _dio.get('${ApiConstants.baseUrl}${ApiConstants.listabsen2}/${name.value}');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        Map<String, Map<String, dynamic>> groupedData = {};

        for (var item in data) {
          String typetime = item['typetime'];
          DateTime time = DateTime.parse(item['time']);
          String dateKey = DateFormat('yyyy-MM-dd').format(time);

          if (!groupedData.containsKey(dateKey)) {
            groupedData[dateKey] = {'date': dateKey, 'check-in': null, 'check-out': null};
          }

          if (typetime == 'checkin') { 
            if (groupedData[dateKey]!['check-in'] == null ||
                time.isAfter(DateTime.parse(groupedData[dateKey]!['check-in']['time']))) {
              groupedData[dateKey]!['check-in'] = item;
            }
          } else if (typetime == 'checkout') { 
            if (groupedData[dateKey]!['check-out'] == null ||
                time.isAfter(DateTime.parse(groupedData[dateKey]!['check-out']['time']))) {
              groupedData[dateKey]!['check-out'] = item;
            }
          }
        }

        List<Map<String, dynamic>> attendanceList = groupedData.values.map((entry) {
          DateTime date = DateTime.parse(entry['date']);

          return {
            'date': DateFormat('EEEE, dd MMMM yyyy', 'id').format(date),
            'checkIn': entry['check-in'] != null
                ? DateFormat('HH:mm', 'id').format(DateTime.parse(entry['check-in']['time']))
                : '',
            'checkOut': entry['check-out'] != null
                ? DateFormat('HH:mm', 'id').format(DateTime.parse(entry['check-out']['time']))
                : '',
          };
        }).toList();

        attendanceList.sort((a, b) {
          DateTime dateA = DateFormat('EEEE, dd MMMM yyyy', 'id').parse(a['date']);
          DateTime dateB = DateFormat('EEEE, dd MMMM yyyy', 'id').parse(b['date']);
          return dateB.compareTo(dateA);
        });

        listhadir.value = attendanceList; // Update RxList
      } else {
        print('Failed to load attendance data');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }
}
