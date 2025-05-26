import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:absensimagang/controller/map2.controller.dart';
import 'package:absensimagang/data/services/auth.service.dart';
import 'package:absensimagang/utils/time_utils.dart';

import '../../data/services/kantor.service.dart';

class MapPage extends StatefulWidget {
  final bool isCheckIn;

  const MapPage({Key? key, required this.isCheckIn}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final mapControllers = MapController();
  final AuthService service = AuthService();
  final MapController mapController = Get.put(MapController());
  final KantorService kantorService = KantorService();
  Map<String, LatLng> officeLocations = {};

  late GoogleMapController mapGController;
  late CameraPosition initialCameraPosition;
  final Location location = Location();
  LatLng? currentLocation;

  String selectedOffice = '';
  double radius = 40.0;
  MapType _currentMapType = MapType.normal;

  final markers = <MarkerId, Marker>{};
  final circles = <CircleId, Circle>{};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchOfficeData();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapGController = controller;
  }

  void _getCurrentLocation() async {
    var locData = await location.getLocation();
    final latLng = LatLng(locData.latitude!, locData.longitude!);

    setState(() {
      currentLocation = latLng;
      initialCameraPosition = CameraPosition(
        target: latLng,
        zoom: 13.5,
      );
    });
  }

  void _addMarkersAndCircles() {
    markers.clear();
    circles.clear();

    officeLocations.forEach((name, position) {
      markers[MarkerId(name)] = Marker(
        markerId: MarkerId(name),
        position: position,
        onTap: () => _showModalBottomSheet(context),
      );

      circles[CircleId('${name}Circle')] = Circle(
        circleId: CircleId('${name}Circle'),
        center: position,
        radius: radius,
        strokeColor: Colors.blue,
        strokeWidth: 2,
        fillColor: Colors.blue.withOpacity(0.1),
      );
    });

    setState(() {});
  }

  LatLng _getOfficeCoordinates(String name) => officeLocations[name]!;

  bool _isWithinRadius(LatLng current, LatLng target) {
    const double earthRadius = 6371000;
    final dLat = _degToRad(target.latitude - current.latitude);
    final dLng = _degToRad(target.longitude - current.longitude);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(current.latitude)) *
            cos(_degToRad(target.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c <= radius;
  }

  double _degToRad(double deg) => deg * pi / 180;

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: 230,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 235, 6, 6),
                Colors.white,
              ],
              stops: [0.06, 0.54],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Agar tombol full width
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    children: [
                      const TextSpan(text: 'Pilih Lokasi Kantor untuk '),
                      TextSpan(
                        text: widget.isCheckIn ? 'check-in' : 'check-out',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildOfficeDropdown(),
              const SizedBox(height: 16),
              _buildSubmitButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOfficeDropdown() {
    return DropdownButtonHideUnderline(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: DropdownButtonFormField<String>(
          value: selectedOffice.isNotEmpty ? selectedOffice : null,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          isExpanded: true,
          decoration: const InputDecoration.collapsed(
              hintText: ''), // remove default decoration
          hint: Center(
            child: Text(
              'Pilih Kantor',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          style: const TextStyle(fontSize: 16, color: Colors.black),
          items: officeLocations.keys.map((officeName) {
            return DropdownMenuItem(
              value: officeName,
              child: Text(
                officeName,
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedOffice = value;
              });

              final target = _getOfficeCoordinates(value);
              mapGController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: target, zoom: 16.5),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        'Selanjutnya',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.white,
        ),
      ),
      onPressed: () async {
        Navigator.pop(context);
        final now = DateTime.now();
        final isValidTime = widget.isCheckIn
            ? await TimeUtils.isCheckInTime(now)
            : await TimeUtils.isCheckOutTime(now);

        if (!isValidTime) {
          showInvalidTimeDialog(context, widget.isCheckIn);
          return;
        }

        final target = _getOfficeCoordinates(selectedOffice);
        if (currentLocation != null &&
            _isWithinRadius(currentLocation!, target)) {
          if (widget.isCheckIn) {
            mapController.checkIn(
                selectedOffice, target.latitude, target.longitude);
          } else {
            mapController.checkOut(
                selectedOffice, target.latitude, target.longitude);
          }
        } else {
          mapControllers.showOutOfRadiusModal(context);
        }
      },
    );
  }

  Future<void> showInvalidTimeDialog(
      BuildContext context, bool isCheckIn) async {
    final startTime = isCheckIn
        ? await TimeUtils.getCheckInStartTime()
        : await TimeUtils.getCheckOutStartTime();

    final endTime = isCheckIn
        ? await TimeUtils.getCheckInEndTime()
        : await TimeUtils.getCheckOutEndTime();

    final timeFormat = DateFormat('HH:mm');
    final message = isCheckIn
        ? 'Check-In hanya dapat dilakukan antara jam ${timeFormat.format(startTime)} - ${timeFormat.format(endTime)}.'
        : 'Check-Out hanya dapat dilakukan antara jam ${timeFormat.format(startTime)} - ${timeFormat.format(endTime)}.';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.access_time_filled,
            color: Colors.redAccent, size: 50),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Diluar Waktu yang Diizinkan",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("OK", style: TextStyle(color: Colors.blue)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchOfficeData() async {
    officeLocations = await kantorService.getOfficeLocations();
    _addMarkersAndCircles();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showModalBottomSheet(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.grey.withOpacity(0.5),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Pilih Lokasi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    PopupMenuButton<MapType>(
                      icon: Icon(Icons.layers, color: Colors.blueAccent),
                      onSelected: (MapType selectedType) {
                        setState(() {
                          _currentMapType = selectedType;
                        });
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<MapType>>[
                        PopupMenuItem<MapType>(
                          value: MapType.normal,
                          child: Row(
                            children: [
                              Icon(Icons.map, color: Colors.green),
                              const SizedBox(width: 8),
                              Text('Normal'),
                            ],
                          ),
                        ),
                        PopupMenuItem<MapType>(
                          value: MapType.satellite,
                          child: Row(
                            children: [
                              Icon(Icons.satellite_alt, color: Colors.orange),
                              const SizedBox(width: 8),
                              Text('Satellite'),
                            ],
                          ),
                        ),
                        PopupMenuItem<MapType>(
                          value: MapType.terrain,
                          child: Row(
                            children: [
                              Icon(Icons.terrain, color: Colors.brown),
                              const SizedBox(width: 8),
                              Text('Terrain'),
                            ],
                          ),
                        ),
                        PopupMenuItem<MapType>(
                          value: MapType.hybrid,
                          child: Row(
                            children: [
                              Icon(Icons.layers_outlined, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text('Hybrid'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              mapType: _currentMapType,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: markers.values.toSet(),
              circles: circles.values.toSet(),
              initialCameraPosition: initialCameraPosition,
            ),
    );
  }
}
