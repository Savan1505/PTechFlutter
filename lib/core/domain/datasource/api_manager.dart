import 'package:dio/dio.dart';
import 'package:ptecpos_mobile/core/preference/pref_constants.dart';
import 'package:ptecpos_mobile/core/preference/shared_preference.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/utils/flavors.dart';

class ApiManager {
  static final _instance = ApiManager._internal();

  Dio? _dio;

  ApiManager._internal() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(
          seconds: 20,
        ),
        receiveTimeout: const Duration(
          seconds: 20,
        ),
        sendTimeout: const Duration(
          seconds: 20,
        ),
        baseUrl: Flavors.getBaseUrl()!,
      ),
    );

    _dio!.options.contentType = Headers.jsonContentType;

    _dio!.interceptors.addAll(
      [
        LogInterceptor(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
        ),
      ],
    );
  }

  factory ApiManager() {
    return _instance;
  }

  Dio? dio({bool useHeader = true}) {
    if (useHeader) {
      _dio?.options.headers['Authorization'] =
          "Bearer ${SharedPreferencesUtils().getString(PrefConstants.openIdAccessToken)}";
      _dio?.options.headers['Companyid'] = SharedPreferencesUtils().getString(PrefConstants.tenant);
      if (RootBloc.store != null) {
        _dio?.options.headers['Storeid'] = RootBloc.store?.id;
      }
      return _dio?..options.contentType = Headers.jsonContentType;
    }

    return _dio?..options.contentType = Headers.jsonContentType;
  }

  Dio? dioByContentType(String contentType) => dio()!..options.contentType = contentType;
}
