import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TimeUtils {
  static final _firestore = FirebaseFirestore.instance;
  static final _docRef = _firestore.collection('settings').doc('attendance_time');

  static Future<Map<String, DateTime>> getAttendanceTimes() async {
    final doc = await _docRef.get();
    final data = doc.data();
    if (data == null) throw Exception("Attendance time data not found.");
    return {
      'checkInStart': (data['checkInStart'] as Timestamp).toDate(),
      'checkInEnd': (data['checkInEnd'] as Timestamp).toDate(),
      'checkOutStart': (data['checkOutStart'] as Timestamp).toDate(),
      'checkOutEnd': (data['checkOutEnd'] as Timestamp).toDate(),
    };
  }

  static Future<void> updateAttendanceTimes({
    required DateTime checkInStart,
    required DateTime checkInEnd,
    required DateTime checkOutStart,
    required DateTime checkOutEnd,
  }) async {
    await _docRef.set({
      'checkInStart': Timestamp.fromDate(checkInStart),
      'checkInEnd': Timestamp.fromDate(checkInEnd),
      'checkOutStart': Timestamp.fromDate(checkOutStart),
      'checkOutEnd': Timestamp.fromDate(checkOutEnd),
    });
  }


  static Future<DateTime> getCheckInStartTime() async {
    final times = await getAttendanceTimes();
    return times['checkInStart']!;
  }

  static Future<DateTime> getCheckInEndTime() async {
    final times = await getAttendanceTimes();
    return times['checkInEnd']!;
  }

  static Future<DateTime> getCheckOutStartTime() async {
    final times = await getAttendanceTimes();
    return times['checkOutStart']!;
  }

  static Future<DateTime> getCheckOutEndTime() async {
    final times = await getAttendanceTimes();
    return times['checkOutEnd']!;
  }

  static bool _isNowWithinTimeRange(DateTime now, DateTime start, DateTime end) {
  final nowTime = TimeOfDay(hour: now.hour, minute: now.minute);
  final startTime = TimeOfDay(hour: start.hour, minute: start.minute);
  final endTime = TimeOfDay(hour: end.hour, minute: end.minute);

  final nowMinutes = nowTime.hour * 60 + nowTime.minute;
  final startMinutes = startTime.hour * 60 + startTime.minute;
  final endMinutes = endTime.hour * 60 + endTime.minute;

  return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
}

static Future<bool> isCheckInTime(DateTime now) async {
  final start = await getCheckInStartTime();
  final end = await getCheckInEndTime();
  return _isNowWithinTimeRange(now, start, end);
}

static Future<bool> isCheckOutTime(DateTime now) async {
  final start = await getCheckOutStartTime();
  final end = await getCheckOutEndTime();
  return _isNowWithinTimeRange(now, start, end);
}

}
