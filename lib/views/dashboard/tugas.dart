import 'package:absensimagang/utils/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/services/file.service.dart';
//import 'package:permission_handler/permission_handler.dart';

class TugasPage extends StatefulWidget {
  const TugasPage({super.key});

  @override
  State<TugasPage> createState() => _TugasPageState();
}

class _TugasPageState extends State<TugasPage> {
  late Future<List<Map<String, dynamic>>> _files;

  @override
  void initState() {
    super.initState();
    _files = FileService().fetchFiles();
//await Permission.storage.request();
  }

  Future<void> _downloadFile(int fileId) async {
    try {
      // Convert fileId to String if needed
      final String fileIdStr = fileId.toString();
      print('Attempting to download file with ID: $fileIdStr');
      await FileService().downloadFile(fileIdStr);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.green,
            content: Text('File downloaded successfully')),
      );
    } catch (e) {
      print('Error downloading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -1),
                  stops: [0.3, 0.7],
                  radius: 1.5,
                  colors: [
                    const Color.fromARGB(255, 193, 188, 188),
                    const Color.fromARGB(255, 14, 142, 197)
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(111, 255, 255, 255),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 0, 0)
                              .withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 7),
                        )
                      ]),
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.81,
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _files,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('Tidak Ada Tugas'));
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final file = snapshot.data![index];
                            final fileName = file['name'];
                            final fileId = file['id'];

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 0.2),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: ListTile(
                                  title: Text(
                                    fileName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.download),
                                    onPressed: () {
                                      _downloadFile(fileId);
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
