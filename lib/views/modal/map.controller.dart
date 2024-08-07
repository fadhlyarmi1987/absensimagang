import 'package:dio/dio.dart';
import 'package:absensimagang/utils/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/providers/api.provider.dart';
import '../../utils/storage.dart';

class MapController {

  Future<void> sendDataToDatabaseMeri(BuildContext context) async {
    String? currentName = await Storage().getName();
    LatLng officeMeriPosition = LatLng(-7.482906085307217, 112.44929725580936);
    HttpClient httpClient = HttpClient();

    final dio = Dio();
    final String apiUrl =
        '${ApiConstants.baseUrl}${ApiConstants.absen}'; // Ganti dengan URL API yang sesuai

    try {
      var response = await httpClient.post(apiUrl, data: {
        'name': currentName,
        'typetime': 'checkin',
        'latitude': officeMeriPosition.latitude,
        'longitude': officeMeriPosition.longitude,
        'kantorid': 'Meri'
      });

      if (response.statusCode != 200) {
        print('Data berhasil dikirim ke database');
        _showSuccessDialog(context, currentName ?? "", officeMeriPosition);
      } else {
        print('Gagal mengirim data ke database');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> sendDataToDatabaseGraha(BuildContext context) async {
    String? currentName = await Storage().getName();
    LatLng officeGrahaPosition = LatLng(-7.491750, 112.461981);
    HttpClient httpClient = HttpClient();

    final dio = Dio();
    final String apiUrl = '${ApiConstants.baseUrl}${ApiConstants.absen}';

    try {
      var response = await httpClient.post(apiUrl, data: {
        'name': currentName,
        'typetime': 'checkin',
        'latitude': officeGrahaPosition.latitude,
        'longitude': officeGrahaPosition.longitude,
        'kantorid': 'Graha'
      });

      if (response.statusCode == 200) {
        print('Data berhasil dikirim ke database');
        _showSuccessDialog(context, currentName ?? "", officeGrahaPosition);
      } else {
        print('Gagal mengirim data ke database');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showOutOfRadiusModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Column(
              children: [
                FadeInXMark(),
                SizedBox(height: 10),
                Text(
                  'Di Luar Radius',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Anda berada di luar radius yang ditentukan.'),
              SizedBox(height: 20),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _showSuccessDialog(BuildContext context, String name, LatLng position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Column(
              children: [
                AnimatedCheckmark(),
                SizedBox(height: 10),
                Text(
                  'BERHASIL',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Natusi $name Absen Masuk'),
              SizedBox(height: 10),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class AnimatedCheckmark extends StatefulWidget {
  @override
  _AnimatedCheckmarkState createState() => _AnimatedCheckmarkState();
}

class _AnimatedCheckmarkState extends State<AnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: _animation.value,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            if (_animation.value == 1)
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              ),
          ],
        );
      },
    );
  }
}

class FadeInXMark extends StatefulWidget {
  @override
  _FadeInXMarkState createState() => _FadeInXMarkState();
}

class _FadeInXMarkState extends State<FadeInXMark> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Icon(
        Icons.cancel,
        color: Colors.red,
        size: 50,
      ),
    );
  }
}