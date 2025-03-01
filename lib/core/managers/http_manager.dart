// ignore_for_file: avoid_dynamic_calls

import 'package:dio/dio.dart';
import 'package:pay_zilla/core/core.dart';
import 'package:pay_zilla/functional_utils/functional_utils.dart';
import 'package:requests_inspector/requests_inspector.dart';

enum RequestType { get, post, put, patch, delete }

const successCodes = [200, 201, 203, 204];

enum Version {
  v1,
  v2,
}

class HttpManager {
  HttpManager({
    Dio? dio1,
    Dio? dio2,
    required ILocalCache cache,
    required String baseUrl,
    required this.enableLogging,
  }) {
    _dio1 = dio1 ?? Dio();
    _dio1.options.baseUrl = baseUrl;
    _dio1.options.connectTimeout = 30000;
    _dio1.options.receiveTimeout = 30000;
    _dio1.interceptors.add(
      AuthAndRefreshTokenInterceptor(cache: cache, baseUrl: baseUrl),
    );
    _dio1.interceptors.add(
      RequestsInspectorInterceptor(),
    );

    _dio2 = dio2 ?? Dio();
    _dio2.options.baseUrl = 'https://wow.davenportmfb.com';
    _dio2.options.connectTimeout = 30000;
    _dio2.options.receiveTimeout = 30000;

    _dio2.interceptors.add(
      RequestsInspectorInterceptor(),
    );
  }
  late Dio _dio1, _dio2;
  bool enableLogging;

  Future get(
    String endpoint, {
    Map<String, dynamic>? data,
    Version version = Version.v1,
  }) async {
    return _makeRequest(
      RequestType.get,
      endpoint,
      data,
      version: version,
    );
  }

  Future post(
    String endpoint,
    Map<String, dynamic> data,
  ) {
    return _makeRequest(
      RequestType.post,
      endpoint,
      data,
    );
  }

  Future patch(
    String endpoint,
    dynamic data,
  ) {
    return _makeRequest(
      RequestType.patch,
      endpoint,
      data,
    );
  }

  Future put(
    String endpoint,
    Map<String, dynamic> data,
  ) {
    return _makeRequest(
      RequestType.put,
      endpoint,
      data,
    );
  }

  Future delete(String endpoint) {
    return _makeRequest(
      RequestType.delete,
      endpoint,
      {},
    );
  }

  //Data parameter should be dynamic because it may accept
  //other variables other than map
  Future _makeRequest(
    RequestType type,
    String endpoint,
    dynamic data, {
    Version version = Version.v1,
  }) async {
    try {
      late Response response;
      switch (type) {
        case RequestType.get:
          response = version == Version.v1
              ? await _dio1.get(endpoint)
              : await _dio2.get(endpoint);

          break;
        case RequestType.post:
          response = await _dio1.post(endpoint, data: data);
          break;
        case RequestType.put:
          response = await _dio1.put(endpoint, data: data);
          break;
        case RequestType.patch:
          response = await _dio1.patch(endpoint, data: data);
          break;
        case RequestType.delete:
          response = await _dio1.delete(endpoint);
          break;
        // ignore: no_default_cases
        default:
          throw InvalidArgOrDataException();
      }
      if (successCodes.contains(response.statusCode)) {
        if (enableLogging) {
          Log().jsonLog(
            '$endpoint JSON res ',
            response.data as Map<String, dynamic>,
          );
        }
        return response.data;
      }

      throw AppServerException(_handleException(response.data));
    } catch (e) {
      Log().debug(
        'the _makeRequest exception caught ${AppConfig.baseUrl}$endpoint',
        [data, e.toString()],
      );
      if (e is ServerException) {
        rethrow;
      }
      if (e is DioError) {
        if (e.error is SessionExpiredServerException) {
          throw SessionExpiredServerException();
        }
        if (e.type == DioErrorType.connectTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          throw TimeoutServerException();
        }
        if (e is FormatException) {
          throw InvalidArgOrDataException();
        }
        if (e.response != null) {
          throw AppServerException(_handleException(e.response?.data));
        }
      }
      throw UnexpectedServerException();
    }
  }

  String _handleException(dynamic err) {
    Log().error('Exception handler logger', err.toString());
    if (enableLogging) Log().error('Exception handler logger', err.toString());
    if (err != null && err.toString().isNotEmpty) {
      if (err['errors'] != null) {
        return err['errors'].toString();
      } else if (err['message'] != null) {
        return err['message'].toString();
      }
    }
    // this colon at the end of the string is used to identify the error in the logs which means that
    // the server returned an error but we couldn't parse it.
    return 'An unexpected error occurred:';
  }
}
