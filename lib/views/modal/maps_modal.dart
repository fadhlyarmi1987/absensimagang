import 'package:absensimagang/data/services/auth.service.dart';
import 'package:absensimagang/utils/api_constants.dart';
import 'package:absensimagang/utils/storage.dart'; // Import storage.dart
import 'package:absensimagang/views/modal/map.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart'; // Import dio
import '../../data/providers/api.provider.dart';
import 'map.controller.dart'; // Import the controller

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  AuthService service = AuthService();
  late GoogleMapController mapController;
  String selectedOffice = '';
  final LatLng _center =
      const LatLng(-7.491926, 112.456411); // Koordinat Jakarta
  final MapController mapControllerInstance =
      MapController(); // Controller instance

  MapController controller = MapController();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _add() {
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

    setState(() {
      markers[MarkerId('Meri')] = marker1;
      markers[MarkerId('Graha')] = marker2;
    });
  }

  @override
  void initState() {
    super.initState();
    _add();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Lokasi'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: markers.values.toSet(),
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15.0,
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
                  hint: Text('Nama Kantor'),
                  value: officeName,
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
                            target:
                                LatLng(-7.482906085307217, 112.44929725580936),
                            zoom: 17.0,
                          ),
                        ),
                      );
                    } else if (value == 'Kantor Graha') {
                      mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(-7.491750, 112.461981),
                            zoom: 17.0,
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
                        padding: EdgeInsets.fromLTRB(100, 15, 100, 15),
                        child: Text(
                          'Selanjutnya',
                          style: GoogleFonts.content(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context); // Menutup modal bottom sheet setelah data dikirim
                        await _sendDataToDatabase(context);
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

  Future<void> _sendDataToDatabase(BuildContext context) async {
    String? currentUserName = await Storage().getName(); 
    LatLng officeMeriPosition = LatLng(-7.482906085307217, 112.44929725580936);
    HttpClient httpClient = HttpClient();

    final dio = Dio();
    final String apiUrl = ApiConstants.baseUrl;

    try {
      var response = await httpClient.post(apiUrl, data: {
        'name': 'flt7', //currentUserName,
        'typetime': 'checkin',
        'latitude': '8372893',//officeMeriPosition.latitude,
        'longitude': '26131746',//officeMeriPosition.longitude,
        'kantorid' : 'Meri'
        
        
      });

      if (response.statusCode == 200) {
        print('Data berhasil dikirim ke database');
        _showSuccessDialog(context, currentUserName??"", officeMeriPosition);
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
          title: Text('Informasi Kantor Meri'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Name: $name'),
              Text('Longitude: ${position.longitude}'),
              Text('Latitude: ${position.latitude}'),
              Text('Type Time: Checkin'),
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
