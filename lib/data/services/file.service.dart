import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';  // Paket izin akses
import 'dart:io';

import '../../utils/api_constants.dart';

class FileService {
  final Dio _dio = Dio();

  Future<List<Map<String, dynamic>>> fetchFiles() async {
    final String apiUrl = '${ApiConstants.baseUrl}${ApiConstants.file}';
    final response = await _dio.get(apiUrl);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Failed to load files');
    }
  }

  Future<void> downloadFile(String fileId) async {
  final String apiUrl = '${ApiConstants.baseUrl}${ApiConstants.fileDownload(fileId)}';

  try {
    // Periksa dan minta izin penyimpanan
    if (await _requestPermission(Permission.storage)) {
      final response = await _dio.get(
        apiUrl,
        options: Options(
          responseType: ResponseType.stream,
        ),
      );

      print('Response headers: ${response.headers}');
      print('Response status code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final directory = Directory('/storage/emulated/0/Download');
        final filePath = '${directory.path}/$fileId';

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        final file = File(filePath);

        final raf = file.openSync(mode: FileMode.write);

        await for (var chunk in response.data.stream) {
          raf.writeFromSync(chunk);
        }

        raf.close();

        print('File downloaded to $filePath');
      } else {
        throw Exception('Failed to download file');
      }
    } else {
      throw Exception('Storage permission denied');
    }
  } catch (e) {
    print('Error downloading file: $e');
    throw Exception('Error downloading file: $e');
  }
}

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      final result = await permission.request();
      return result == PermissionStatus.granted;
    }
  }
}
