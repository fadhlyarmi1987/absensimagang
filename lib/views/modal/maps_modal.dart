import 'dart:math';
import 'dart:io'; // Ganti dengan import sesuai kebutuhan

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:absensimagang/data/services/auth.service.dart';
import 'package:absensimagang/utils/api_constants.dart';
import 'package:absensimagang/data/providers/api.provider.dart';
import 'package:absensimagang/utils/storage.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  AuthService service = AuthService();
  late GoogleMapController mapController;
  String selectedOffice = '';
  final LatLng _center = const LatLng(-7.491926, 112.456411); // Koordinat Jakarta
  final Location location = Location();
  LatLng? currentLocation;
  double radius = 20.0; // radius dalam meter

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<CircleId, Circle> circles = <CircleId, Circle>{};

  @override
  void initState() {
    super.initState();
    _addMarkersAndCircles();
    _getCurrentLocation();

    // Menampilkan bottom sheet setelah frame pertama selesai dibangun
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showModalBottomSheet(context, 'Pilih Lokasi Kantor');
    });
  }

  void _addMarkersAndCircles() {
    final marker1 = Marker(
      markerId: MarkerId('Meri'),
      position: LatLng(-7.482906085307217, 112.44929725580936),
      onTap: () {
        _showModalBottomSheet(context, 'Kantor Meri');
      },
    );

    final marker2 = Marker(
      markerId: MarkerId('Graha'),
      position: LatLng(-7.491750, 112.461981),
      onTap: () {
        _showModalBottomSheet(context, 'Kantor Graha');
      },
    );

    final circle1 = Circle(
      circleId: CircleId('MeriCircle'),
      center: LatLng(-7.482906085307217, 112.44929725580936),
      radius: radius,
      strokeColor: Colors.blue,
      strokeWidth: 2,
      fillColor: Colors.blue.withOpacity(0.1),
    );

    final circle2 = Circle(
      circleId: CircleId('GrahaCircle'),
      center: LatLng(-7.491750, 112.461981),
      radius: radius,
      strokeColor: Colors.blue,
      strokeWidth: 2,
      fillColor: Colors.blue.withOpacity(0.1),
    );

    setState(() {
      markers[MarkerId('Meri')] = marker1;
      markers[MarkerId('Graha')] = marker2;
      circles[CircleId('MeriCircle')] = circle1;
      circles[CircleId('GrahaCircle')] = circle2;
    });
  }

  void _getCurrentLocation() async {
    var locData = await location.getLocation();
    setState(() {
      currentLocation = LatLng(locData.latitude!, locData.longitude!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Lokasi'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: markers.values.toSet(),
        circles: circles.values.toSet(),
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 14.0,
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context, String officeName) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(40, 20, 50, 0),
                child: Text(
                  'Pilih Lokasi Kantor',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10)), //border radius input
                    filled: true,
                    fillColor: const Color.fromARGB(255, 232, 242, 251),
                  ),
                  borderRadius: BorderRadius.circular(10),
                  hint: Text('Pilih Kantor'),
                  items: [
                    DropdownMenuItem(
                      value: 'Kantor Meri',
                      child: Center(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ))),
                            child: Text('Kantor Meri')),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Kantor Graha',
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text('Kantor Graha'),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedOffice = value!;
                    });
                    if (value == 'Kantor Meri') {
                      mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(-7.482906085307217, 112.44929725580936),
                            zoom: 19.0,
                          ),
                        ),
                      );
                    } else if (value == 'Kantor Graha') {
                      mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(-7.491750, 112.461981),
                            zoom: 19.0,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 18, 173, 164),
                        Colors.blue
                      ], // Warna gradien
                    ),
                    borderRadius: BorderRadius.circular(12), // Border radius
                  ),
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(90, 10, 90, 10),
                        child: Container(
                          //color: Colors.black,
                          width: 90,
                          child: Text(
                            'Selanjutnya',
                            style: GoogleFonts.content(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        if (currentLocation != null &&
                            _isWithinRadius(
                                currentLocation!,
                                selectedOffice == 'Kantor Meri'
                                    ? LatLng(
                                        -7.482906085307217, 112.44929725580936)
                                    : LatLng(-7.491750, 112.461981))) {
                          if (selectedOffice == 'Kantor Meri') {
                            await MapController().sendDataToDatabaseMeri(context);
                          } else if (selectedOffice == 'Kantor Graha') {
                            await MapController().sendDataToDatabaseGraha(context);
                          }
                        } else {
                          _showOutOfRadiusModal(context);
                        }
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  bool _isWithinRadius(LatLng currentLocation, LatLng markerLocation) {
    double distance = _calculateDistance(
        currentLocation.latitude,
        currentLocation.longitude,
        markerLocation.latitude,
        markerLocation.longitude);
    return distance <= radius;
  }

  double _calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    const double earthRadius = 6371000; // meters
    double dLat = _degreeToRadian(endLatitude - startLatitude);
    double dLon = _degreeToRadian(endLongitude - startLongitude);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreeToRadian(startLatitude)) *
            cos(_degreeToRadian(endLatitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreeToRadian(double degree) {
    return degree * (pi / 180);
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
}

class MapController {
  final Dio _dio = Dio();

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
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Tutup'),
              onPressed: () {
              Navigator.of(context).pop(); // Menutup dialog
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/dashboard', // Gantilah '/home' dengan nama rute Anda
                (Route<dynamic> route) => false,
              );
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


