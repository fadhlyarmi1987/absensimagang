import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  final LatLng _center =
      const LatLng(-7.491926, 112.456411); // Koordinat Jakarta

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _add() {
    final marker1 = Marker(
        markerId: MarkerId('Meri'),
        position: LatLng(-7.482906085307217, 112.44929725580936),
        onTap: () {
          _showModalBottomSheet(context);
        });

    final marker2 = Marker(
        markerId: MarkerId('Graha'),
        position: LatLng(-7.491750, 112.461981),
        onTap: () {
          _showModalBottomSheet(context);
        });

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
        markers: markers.values.toSet(),
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15.0,
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
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
                        borderRadius: BorderRadius.circular(10)), //border raidius input
                    filled: true,
                    fillColor: const Color.fromARGB(255, 232, 242, 251),
                  ),
                  borderRadius: BorderRadius.circular(10),
                
                  hint: Text('Nama Kantor'),
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
                    if (value == 'Kantor Meri') {
                      mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(-7.482906085307217, 112.44929725580936),
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
                      onPressed: () {
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
}
