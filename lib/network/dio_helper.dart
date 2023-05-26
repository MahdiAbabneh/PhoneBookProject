import 'package:dio/dio.dart';

class DioHelper {
  static Dio dio=Dio();

  static init()
  {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost/phpproject/contactInformation.php',
        receiveDataWhenStatusError: true,

      ),
    );
  }


  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
  }) async
  {
    dio.options.headers =
    {
      'Content-Type': 'application/json',
    };

    return await dio.post(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async
  {
    dio.options.headers =
    {
      'Content-Type': 'application/json',
    };

    return await dio.get(
      url,
      queryParameters: query,
    );
  }
}
