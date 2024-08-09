// lib/views/modals/maps_modal.dart

import 'package:absensimagang/data/services/auth.service.dart';
import 'package:absensimagang/data/services/map.service.dart';
import 'package:absensimagang/views/maps/map.controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
      const LatLng(-7.491926, 112.456411); // Koordinat Jakarta
  final MapViewModel mapViewModelInstance =
      MapViewModel(); // ViewModel instance

  Location location = Location();
  LatLng? currentLocation;
  double radius = 20.0; // radius dalam meter

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<CircleId, Circle> circles = <CircleId, Circle>{};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _add() {
    final marker1 = Marker(
      markerId: MarkerId('Meri'),
      position: LatLng(-7.482906085307217, 112.44929725580936),
      onTap: () {
        _showModalBottomSheet(context, 'Kantor Meri', isCheckIn: widget.isCheckIn);
      },
    );

    final marker2 = Marker(
      markerId: MarkerId('Graha'),
      position: LatLng(-7.491750, 112.461981),
      onTap: () {
        _showModalBottomSheet(context, 'Kantor Graha', isCheckIn: widget.isCheckIn);
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

  @override
  void initState() {
    super.initState();
    _add();
    _getCurrentLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showModalBottomSheet(context, selectedOffice, isCheckIn: widget.isCheckIn);
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

  void _showModalBottomSheet(BuildContext context, String officeName, {required bool isCheckIn}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 200,
        color: Colors.white,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                      borderRadius: BorderRadius.circular(10)
                    ),
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
                              )
                            )
                          ),
                          child: Text('Kantor Meri')
                        ),
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
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Container(
                          child: Text(
                            textAlign: TextAlign.center,
                            'Selanjutnya',
                            style: GoogleFonts.content(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white
                            ),
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
                            if (isCheckIn) {
                              await MapViewModel()
                                .sendDataToDatabaseMeri(context);
                            } else {
                              await MapViewModel()
                                .sendDataToDatabaseMeriCheckout(context);
                            }
                          } else if (selectedOffice == 'Kantor Graha') {
                            if (isCheckIn) {
                              await MapViewModel()
                                .sendDataToDatabaseGraha(context);
                            } else {
                              await MapViewModel()
                                .sendDataToDatabaseGrahaCheckout(context);
                            }
                          }
                        } else {
                          mapControllers.showOutOfRadiusModal(context);
                        }
                      },
                    ),
                  ),
                ),
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
