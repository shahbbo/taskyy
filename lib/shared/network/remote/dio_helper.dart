import 'package:dio/dio.dart';
import '../local/cache_helper.dart';
import '../../resources/string_manager.dart';
import 'package:taskyy/layout/components/constants.dart';

class DioHelper
{
  static late Dio dio ;

  static inti()
  {
    dio = Dio(
      BaseOptions(
        baseUrl: AppStrings.baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );
  }


  static Future<Response> getDate({
  required String url,
   Map<String,dynamic>? query ,
    dynamic data,
    String tokenVerify = ''
  }) async
  {
    tokenId = CacheHelper.getData(key: 'TokenId');
    dio.options.headers = {
      'Authorization':'Bearer ${tokenVerify.isEmpty ? tokenId : tokenVerify}',
    };
    return await dio.get(
      url ,
      data: data,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    Map<String,dynamic>? query ,
    required dynamic data ,
  }) async
  {
    tokenId = CacheHelper.getData(key: 'TokenId');
    dio.options.headers = {
      'Authorization':'Bearer $tokenId',
    };
     return dio.post(
       url ,
       queryParameters: query,
       data: data,
     );
  }

  static Future<Response> putData({
    required String url,
    Map<String,dynamic>? query ,
    required dynamic data ,
  }) async
  {
    tokenId = CacheHelper.getData(key: 'TokenId');
    dio.options.headers = {
      'Authorization':'Bearer $tokenId',
      'Content-Type' : 'application/json',
    };
    return dio.put(
      url ,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> deleteData({
    required String url,
    dynamic data,
  }) async
  {
    tokenId = CacheHelper.getData(key: 'TokenId');
    dio.options.headers = {
      'Authorization':'Bearer $tokenId',
    };
    return dio.delete(
      url ,
      data: data,
    );
  }
}