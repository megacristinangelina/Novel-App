import 'package:dio/dio.dart';

class DioClient {
  late Dio dio;

  DioClient() {
    dio = Dio();
    dio.options.baseUrl = "http://192.168.94.80:5000/";
    dio.options.contentType = "application/json";
  }
}
