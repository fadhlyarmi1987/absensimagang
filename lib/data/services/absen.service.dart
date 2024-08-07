import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import '../../utils/storage.dart';
import '../providers/api.provider.dart';


  Future<void> _sendDataToDatabaseMeri(BuildContext context) async {
    String? currentName = await Storage().getName(); 
    LatLng officeMeriPosition = LatLng(-7.482906085307217, 112.44929725580936);
    HttpClient httpClient = HttpClient();
    

    final dio = Dio();
    final String apiUrl = 'http://192.168.64.139:8001/api/absen'; // Ganti dengan URL API yang sesuai


    try {
      var response = await httpClient.post(apiUrl, data: {
        'name': currentName,
        'typetime': 'checkin',
        'latitude': officeMeriPosition.latitude,
        'longitude': officeMeriPosition.longitude,
        'kantorid' : 'Meri'
        
        
      });

      if (response.statusCode != 200) {
        print('Data berhasil dikirim ke database');
        _showSuccessDialog(context, currentName??"", officeMeriPosition);
      } else {
        print('Gagal mengirim data ke database');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

    Future<void> _sendDataToDatabaseGraha(BuildContext context) async {
    String? currentName = await Storage().getName(); 
    LatLng officeGrahaPosition = LatLng(-7.491750, 112.461981);
    HttpClient httpClient = HttpClient();

    final dio = Dio();
    final String apiUrl = 'http://192.168.64.139:8001/api/absen'; // Ganti dengan URL API yang sesuai


    try {
      var response = await httpClient.post(apiUrl, data: {
        'name': currentName,
        'typetime': 'checkin',
        'latitude': officeGrahaPosition.latitude,
        'longitude': officeGrahaPosition.longitude,
        'kantorid' : 'Graha'
        
        
      });

      if (response.statusCode == 200) {
        print('Data berhasil dikirim ke database');
        _showSuccessDialog(context, currentName??"", officeGrahaPosition);
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
