import 'package:flutter/material.dart';
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
        markerId: MarkerId('place_name1'),
        position: LatLng(-7.482906085307217, 112.44929725580936),
        onTap: () {
          _showModalBottomSheet(context);
        });

    final marker2 = Marker(
      markerId: MarkerId('place_name2'),
      position: LatLng(-7.491750, 112.461981),
      infoWindow: InfoWindow(
        title: 'Place Name 2',
      ),
    );

    setState(() {
      markers[MarkerId('place_name1')] = marker1;
      markers[MarkerId('place_name2')] = marker2;
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
              Text(
                'Pilih Lokasi Kantor',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.blue[50],
                ),
                hint: Text('Nama Kantor'),
                items: [
                  DropdownMenuItem(
                      value: 'Kantor Meri', child: Text('Kantor Meri')),
                  DropdownMenuItem(
                      value: 'Kantor Graha', child: Text('Kantor Meri')),
                ],
                onChanged: (value) {
                // Handle change
              },
              ),
            ],
          ),
        );
      },
    );
  }
}
