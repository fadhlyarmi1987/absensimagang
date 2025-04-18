// lib/views/modals/maps_modal.dart

import 'package:absensimagang/data/services/auth.service.dart';
import 'package:absensimagang/data/services/map.service.dart';
import 'package:absensimagang/views/maps/map.controller.dart';
import 'package:absensimagang/controller/map2.controller.dart';
import 'package:absensimagang/utils/time_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  final bool isCheckIn;

  const MapPage({Key? key, required this.isCheckIn}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController mapControllers = MapController();
  AuthService service = AuthService();
  late GoogleMapController mapController;
  String selectedOffice = '';
  final LatLng _center =
      const LatLng(-7.921048, 112.597329); // Koordinat Kampus
  final MapViewModel mapViewModelInstance =
      MapViewModel(); // ViewModel instance

  Location location = Location();
  LatLng? currentLocation;
  double radius = 40.0; // radius dalam meter

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<CircleId, Circle> circles = <CircleId, Circle>{};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _add() {
    final marker1 = Marker(
      markerId: MarkerId('Lab'),
      position: LatLng(-7.921121, 112.599286),
      onTap: () {
        _showModalBottomSheet(context, 'Lab', isCheckIn: widget.isCheckIn);
      },
    );

    final marker2 = Marker(
      markerId: MarkerId('Kontrakan'),
      position: LatLng(-7.931133, 112.591202),
      onTap: () {
        _showModalBottomSheet(context, 'Kontrakan',
            isCheckIn: widget.isCheckIn);
      },
    );

    final circle1 = Circle(
      circleId: CircleId('MeriCircle'),
      center: LatLng(-7.921121, 112.599286),
      radius: radius,
      strokeColor: Colors.blue,
      strokeWidth: 2,
      fillColor: Colors.blue.withOpacity(0.1),
    );

    final circle2 = Circle(
      circleId: CircleId('GrahaCircle'),
      center: LatLng(-7.931133, 112.591202),
      radius: radius,
      strokeColor: Colors.blue,
      strokeWidth: 2,
      fillColor: Colors.blue.withOpacity(0.1),
    );

    setState(() {
      markers[MarkerId('Lab')] = marker1;
      markers[MarkerId('Perpustakaan')] = marker2;
      circles[CircleId('MeriCircle')] = circle1;
      circles[CircleId('GrahaCircle')] = circle2;
    });
  }

  @override
  void initState() {
    super.initState();
    _add();
    _getCurrentLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showModalBottomSheet(context, selectedOffice,
          isCheckIn: widget.isCheckIn);
    });
  }

  void _getCurrentLocation() async {
    var locData = await location.getLocation();
    setState(() {
      currentLocation = LatLng(locData.latitude!, locData.longitude!);
    });
  }

  // panggil class Map2Controller yang menggunakan extends getxcontroler dengan Get.put(...);
  Map2Controller map2Controller = Get.put(Map2Controller());

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

  void _showModalBottomSheet(BuildContext context, String officeName,
      {required bool isCheckIn}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Card(
            elevation: 4,
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
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 232, 242, 251),
                    ),
                    borderRadius: BorderRadius.circular(10),
                    hint: Text('Pilih Kantor'),
                    value: selectedOffice.isNotEmpty ? selectedOffice : null,
                    items: [
                      DropdownMenuItem(value: 'Lab', child: Text('Lab')),
                      DropdownMenuItem(
                          value: 'Kontrakan', child: Text('Kontrakan')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedOffice = value!;
                      });
                      LatLng newTarget = value == 'Lab'
                          ? LatLng(-7.921121, 112.599286)
                          : LatLng(-7.931133, 112.591202);
                      mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(target: newTarget, zoom: 19.0),
                        ),
                      );
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
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Selanjutnya',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);

                          final now = DateTime.now();
                          final bool isValidTime = isCheckIn
                              ? isCheckInTime(now)
                              : isCheckOutTime(now);

                          if (!isValidTime) {
                            showInvalidTimeDialog(context, isCheckIn);
                            return;
                          }

                          if (currentLocation != null &&
                              _isWithinRadius(
                                currentLocation!,
                                selectedOffice == 'Lab'
                                    ? LatLng(-7.921121, 112.599286)
                                    : LatLng(-7.931133, 112.591202),
                              )) {
                            final LatLng officePosition =
                                selectedOffice == 'Lab'
                                    ? LatLng(-7.921121, 112.599286)
                                    : LatLng(-7.931133, 112.591202);

                            if (isCheckIn) {
                              map2Controller.checkIn(
                                selectedOffice,
                                officePosition.latitude,
                                officePosition.longitude,
                              );
                            } else {
                              map2Controller.checkOut(
                                  selectedOffice,
                                  officePosition.latitude,
                                  officePosition.longitude);
                            }
                          } else {
                            mapControllers.showOutOfRadiusModal(context);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // bool isCheckInTime(DateTime now) {
  //   final start = TimeOfDay(hour: 0, minute: 0);
  //   final end = TimeOfDay(hour: 8, minute: 0);
  //   return _isWithinTimeRange(now, start, end);
  // }

  // bool isCheckOutTime(DateTime now) {
  //   final start = TimeOfDay(hour: 1, minute: 30);
  //   final end = TimeOfDay(hour: 17, minute: 0);
  //   return _isWithinTimeRange(now, start, end);
  // }

  bool _isWithinTimeRange(DateTime now, TimeOfDay start, TimeOfDay end) {
    final nowTime = TimeOfDay(hour: now.hour, minute: now.minute);
    final nowMinutes = nowTime.hour * 60 + nowTime.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
  }

  void showInvalidTimeDialog(BuildContext context, bool isCheckIn) {
  final DateFormat timeFormat = DateFormat('HH:mm');
  
  final startTime = isCheckIn ? getCheckInStartTime() : getCheckOutStartTime();
  final endTime = isCheckIn ? getCheckInEndTime() : getCheckOutEndTime();

  final formattedStart = timeFormat.format(startTime);
  final formattedEnd = timeFormat.format(endTime);

  final message = isCheckIn
      ? 'Check-In hanya dapat dilakukan antara jam $formattedStart - $formattedEnd.'
      : 'Check-Out hanya dapat dilakukan antara jam $formattedStart - $formattedEnd.';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time_filled,
                    color: Colors.redAccent, size: 50),
                SizedBox(height: 15),
                Text(
                  "Diluar Waktu yang Diizinkan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("OK", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
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
}
