// utils/time_utils.dart
DateTime getCheckInStartTime() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, 7, 0, 0);
}

DateTime getCheckInEndTime() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, 8, 0, 0);
}

DateTime getCheckOutStartTime() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, 17, 0, 0);
}

DateTime getCheckOutEndTime() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, 17, 30, 0);
}

bool isCheckInTime(DateTime now) {
  return now.isAfter(getCheckInStartTime()) && now.isBefore(getCheckInEndTime());
}

bool isCheckOutTime(DateTime now) {
  return now.isAfter(getCheckOutStartTime()) && now.isBefore(getCheckOutEndTime());
}
