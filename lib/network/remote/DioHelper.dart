import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(BaseOptions(
        baseUrl:
        'https://fcm.googleapis.com/v1/projects/chat-7539a/messages:send',
        receiveDataWhenStatusError: true));
  }

  static Future<void> postDate(String accessToken,
      Map<String, dynamic> data) async {
    dio?.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    try {
      await dio?.post('', data: data);
    }catch(e){
      print('Error on dio Helper Post : $e');
    }
  }
}
