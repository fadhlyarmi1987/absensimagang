import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
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
    final response = await _dio.get(
      apiUrl,
      options: Options(
        responseType: ResponseType.stream,
      ),
    );

    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileId';
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
  } catch (e) {
    print('Error downloading file: $e');
    throw Exception('Error downloading file: $e');
  }
}
}
