import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controller/map2.controller.dart';
import '../../utils/storage.dart';
import '../../views/maps/map.controller.dart';

class MapViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendDataToFirestore(BuildContext context, LatLng position, String kantorId, String typetime) async {
    String? currentName = await Storage().getName();

    try {
      // Menyimpan data ke Firestore
      await _firestore.collection('absensi').add({
        'name': currentName,
        'typetime': typetime,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'kantorid': kantorId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> sendDataToDatabaseMeri(BuildContext context) async {
    LatLng officeMeriPosition = LatLng(-7.921121, 112.599286);
    await sendDataToFirestore(context, officeMeriPosition, 'Lab', 'checkin');
  }

  Future<void> sendDataToDatabaseGraha(BuildContext context) async {
    LatLng officeGrahaPosition = LatLng(-7.473407301068347, 112.43637440525373);
    await sendDataToFirestore(context, officeGrahaPosition, 'Perpustakaan', 'checkin');
  }

  Future<void> sendDataToDatabaseMeriCheckout(BuildContext context) async {
    LatLng officeMeriPosition = LatLng(-7.921121, 112.599286);
    await sendDataToFirestore(context, officeMeriPosition, 'Lab', 'checkout');
  }

  Future<void> sendDataToDatabaseGrahaCheckout(BuildContext context) async {
    LatLng officeGrahaPosition = LatLng(-7.473407301068347, 112.43637440525373);
    await sendDataToFirestore(context, officeGrahaPosition, 'Perpustakaan', 'checkout');
  }
}
