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
      final response = await _dio.get('${ApiConstants.baseUrl}${ApiConstants.listabsen}');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        listhadir.value = data.map((item) {
          return {
            'date': DateFormat('EEEE, dd MMMM yyyy', 'id').format(DateTime.parse(item['time'])),
            'checkIn': item['typetime'] == 'check-in' ? DateFormat('HH:mm').format(DateTime.parse(item['time'])) : '',
            'checkOut': item['typetime'] == 'check-out' ? DateFormat('HH:mm').format(DateTime.parse(item['time'])) : '',
          };
        }).toList();
      } else {
        // Handle error response
        print('Failed to load attendance data');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception occurred: $e');
    }
  }
}