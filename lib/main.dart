import 'package:absensimagang/route/page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;

void main () async {
  tz.initializeTimeZones();
  initializeDateFormatting('id', null);
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Natusi Login/Registration',
      locale: Locale('id','ID'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      
      initialRoute: '/Login',
      getPages: pages,
    );
  }
}
