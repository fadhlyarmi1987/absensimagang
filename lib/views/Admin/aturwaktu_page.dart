import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/time_utils.dart';

class AturWaktu extends StatefulWidget {
  @override
  _AturWaktuState createState() => _AturWaktuState();
}

class _AturWaktuState extends State<AturWaktu> {
  TimeOfDay? _checkInStart;
  TimeOfDay? _checkInEnd;
  TimeOfDay? _checkOutStart;
  TimeOfDay? _checkOutEnd;

  @override
  void initState() {
    super.initState();
    _fetchWorkHours();
  }

  Future<void> _fetchWorkHours() async {
    final data = await TimeUtils.getAttendanceTimes();
    setState(() {
      _checkInStart = TimeOfDay.fromDateTime(data['checkInStart']!);
      _checkInEnd = TimeOfDay.fromDateTime(data['checkInEnd']!);
      _checkOutStart = TimeOfDay.fromDateTime(data['checkOutStart']!);
      _checkOutEnd = TimeOfDay.fromDateTime(data['checkOutEnd']!);
    });
  }

  Future<void> _selectTime(BuildContext context, TimeOfDay? current,
      Function(TimeOfDay) onConfirm) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: current ?? TimeOfDay.now(),
    );
    if (picked != null) {
      onConfirm(picked);
    }
  }

  DateTime _toDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  Future<void> _saveTimes() async {
    if (_checkInStart != null &&
        _checkInEnd != null &&
        _checkOutStart != null &&
        _checkOutEnd != null) {
      await TimeUtils.updateAttendanceTimes(
        checkInStart: _toDateTime(_checkInStart!),
        checkInEnd: _toDateTime(_checkInEnd!),
        checkOutStart: _toDateTime(_checkOutStart!),
        checkOutEnd: _toDateTime(_checkOutEnd!),
      );
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return "--:--";
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.Hm().format(dt); // Format 24 jam: "HH:mm"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Atur Waktu Presensi'),
          backgroundColor: Colors.red.shade700),
      body: Container(
        color: const Color.fromARGB(
            255, 193, 193, 193), // full background dark grey
        width: double.infinity,
        height: 1000,
        padding: const EdgeInsets.fromLTRB(16, 70, 16, 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card 1: Check-In
              Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Waktu Check-In",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                    SizedBox(height: 10),
                    _buildTimePickerTile("Check-In Start", _checkInStart,
                        (val) => setState(() => _checkInStart = val)),
                    _buildTimePickerTile("Check-In End", _checkInEnd,
                        (val) => setState(() => _checkInEnd = val)),
                  ],
                ),
              ),

              // Card 2: Check-Out
              Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Waktu Check-Out",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                    SizedBox(height: 10),
                    _buildTimePickerTile("Check-Out Start", _checkOutStart,
                        (val) => setState(() => _checkOutStart = val)),
                    _buildTimePickerTile("Check-Out End", _checkOutEnd,
                        (val) => setState(() => _checkOutEnd = val)),
                  ],
                ),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _saveTimes();
                  _showSuccessDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check),
                    SizedBox(width: 8),
                    Text('Simpan Waktu'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePickerTile(
      String label, TimeOfDay? time, Function(TimeOfDay) onPicked) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      title: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(_formatTime(time), style: TextStyle(fontSize: 16)),
      trailing: Icon(Icons.access_time),
      onTap: () => _selectTime(context, time, onPicked),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 12),
              Text('Berhasil Disimpan!'),
            ],
          ),
          content: Text(
            'Waktu presensi berhasil diperbarui.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup', style: TextStyle(fontSize: 16)),
            )
          ],
        );
      },
    );
  }
}
