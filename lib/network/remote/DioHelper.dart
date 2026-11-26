import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(BaseOptions(
        baseUrl:
            'https://fcm.googleapis.com/v1/projects/chat-7539a/messages:send',
        receiveDataWhenStatusError: true));
  }

  static Future<void> postDate(
      String accessToken, Map<String, dynamic> data) async {
    dio?.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    final response = await dio!.post('', data: data);
    if (response.statusCode != null &&
        (response.statusCode! < 200 || response.statusCode! >= 300)) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }
}
