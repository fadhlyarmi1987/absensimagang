import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
//import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class AbsenceCalendarPage extends StatefulWidget {
  final String userId;
  final String userName;

  const AbsenceCalendarPage(
      {Key? key, required this.userId, required this.userName})
      : super(key: key);

  @override
  State<AbsenceCalendarPage> createState() => _AbsenceCalendarPageState();
}

class _AbsenceCalendarPageState extends State<AbsenceCalendarPage> {
  Map<DateTime, String> absences = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Amankan layar setelah frame pertama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      secureScreen();
    });

    fetchAbsences();
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  Future<void> secureScreen() async {
  }

  Future<void> fetchAbsences() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('absensi')
        .get();

    Map<DateTime, String> temp = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final timestamp = data['timestamp'];
      final type = data['type'];

      if (timestamp is Timestamp && type is String) {
        final date = DateTime(timestamp.toDate().year, timestamp.toDate().month,
            timestamp.toDate().day);
        temp[date] = type;
      }
    }

    setState(() {
      absences = temp;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kalender Absensi\n${widget.userName}",
          style: const TextStyle(fontSize: 18),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        backgroundColor: Colors.red.shade700,
        toolbarHeight: 72,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    focusedDay: DateTime.now(),
                    selectedDayPredicate: (day) => false,
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.red.shade100,
                        shape: BoxShape.circle,
                      ),
                      weekendTextStyle: const TextStyle(color: Colors.red),
                      defaultTextStyle: const TextStyle(color: Colors.black87),
                      outsideDaysVisible: false,
                      markersAlignment: Alignment.bottomCenter,
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      leftChevronIcon:
                          Icon(Icons.chevron_left, color: Colors.red.shade700),
                      rightChevronIcon:
                          Icon(Icons.chevron_right, color: Colors.red.shade700),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
                      weekendStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        return _buildCustomDay(day);
                      },
                      todayBuilder: (context, day, focusedDay) {
                        return _buildCustomDay(day);
                      },
                      outsideBuilder: (context, day, focusedDay) {
                        return _buildCustomDay(day);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegend(Colors.green, "Check-in"),
                      const SizedBox(width: 16),
                      _buildLegend(Colors.orange, "Izin"),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }

  Widget? _buildCustomDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    final type = absences[normalizedDay];

    if (type != null) {
      Color bgColor = Colors.green;
      Color textColor = Colors.black;
      String label = "check-in";

      if (type == 'izin') {
        bgColor = Colors.orange;
        textColor = const Color.fromARGB(255, 16, 14, 14);
        label = "Izin";
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.black),
          ),
          const SizedBox(height: 2),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }

    return null;
  }
}
