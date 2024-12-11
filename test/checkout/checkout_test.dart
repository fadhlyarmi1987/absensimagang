import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../lib/utils/api_constants.dart';
import 'dart:math';

void main() {
  group('Check-out API Test', () {
    double _toRadians(double degree) {
      return degree * pi / 180;
    }
    double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
      const radiusOfEarth = 6371;
      double dLat = _toRadians(lat2 - lat1);
      double dLon = _toRadians(lon2 - lon1);

      double a = sin(dLat / 2) * sin(dLat / 2) +
          cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
              sin(dLon / 2) * sin(dLon / 2);
      double c = 2 * atan2(sqrt(a), sqrt(1 - a));

      double distance = radiusOfEarth * c; 
      return distance;
    }

    // Test check-out sukses
    test('Check-out API Test Sukses', () async {
      final response = await http.post(
        Uri.parse(ApiConstants.absen),
        body: {
          "name": "Test checkout",
          "typetime": "checkout",
          "latitude": "-7.921121",
          "longitude": "112.599286",
          "kantorid": "Lab",
        },
      );

      expect(response.statusCode, 200); 
    });

    // Test apabila gps kita diluar radius
    test('Check-out jika diluar radius', () async {
      const officeLat = -7.921249;
      const officeLon = 112.599530;
      const userLat = -7.921121;
      const userLon = 112.599286;

      double distance = calculateDistance(userLat, userLon, officeLat, officeLon);


      const maxValidDistance = 0.05;

      if (distance > maxValidDistance) {
        final response = await http.post(
          Uri.parse(ApiConstants.absen),
          body: {
            "name": "Test checkout",
            "typetime": "checkout",
            "latitude": userLat.toString(),
            "longitude": userLon.toString(),
            "kantorid": "Lab",
          },
        );

        expect(response.statusCode, 400);  
        expect(response.body.contains('Location is out of allowed range'), isTrue); 
      } else {
        final response = await http.post(
          Uri.parse(ApiConstants.absen),
          body: {
            "name": "Test checkout",
            "typetime": "checkout",
            "latitude": userLat.toString(),
            "longitude": userLon.toString(),
            "kantorid": "Lab",
          },
        );

        expect(response.statusCode, 200); 
      }
    });
  });
}
