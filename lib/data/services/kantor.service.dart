import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class KantorService {
  final CollectionReference kantorRef = FirebaseFirestore.instance.collection('kantor');

  Future<Map<String, LatLng>> getOfficeLocations() async {
    final snapshot = await kantorRef.get();
    final officeMap = <String, LatLng>{};

    for (var doc in snapshot.docs) {
      final name = doc['name'];
      final geo = doc['location'] as GeoPoint;
      officeMap[name] = LatLng(geo.latitude, geo.longitude);
    }

    return officeMap;
  }
}
