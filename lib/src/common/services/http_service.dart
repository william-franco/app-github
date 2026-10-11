import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app_github/src/common/constants/api_constant.dart';

typedef HttpResult = ({int? statusCode, dynamic data, String? error});

abstract interface class HttpService {
  Future<HttpResult> getData({
    required String path,
    Map<String, dynamic>? queryParameters,
  });
}

class HttpServiceImpl implements HttpService {
  final _httpClient = Dio(
    BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28',
      },
    ),
  );

  HttpServiceImpl() {
    _httpClient.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('➡️ Request to: ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('✅ Response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          debugPrint('❌ Dio error: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  @override
  Future<HttpResult> getData({
    required String path,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _httpClient.get(
        path,
        queryParameters: queryParameters,
      );
      return (
        statusCode: response.statusCode,
        data: response.data,
        error: null,
      );
    } on DioException catch (e) {
      return (statusCode: e.response?.statusCode, data: null, error: e.message);
    } catch (e) {
      return (statusCode: null, data: null, error: '$e');
    }
  }
}
