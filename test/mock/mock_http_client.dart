import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

// Mock HttpClient untuk Dio
class MockDio extends Mock implements Dio {}

// Mock HttpClient untuk HttpClient (http package)
class MockHttpClient extends Mock implements http.Client {}
