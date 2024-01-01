import 'package:dio/dio.dart';
import 'package:ptecpos_mobile/core/domain/model/response_model.dart';
import 'package:ptecpos_mobile/core/utils/api_constants.dart';
import 'package:ptecpos_mobile/core/utils/flavors.dart';
import 'package:ptecpos_mobile/features/authentication/model/response/auth_response_model.dart';

class AuthDatasource {
  late Dio dio;

  AuthDatasource() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        baseUrl: Flavors.getBaseUrl()!,
      ),
    );

    dio.interceptors.addAll([
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
      ),
    ]);
  }

  Stream<AuthResponseModel> getAuthProfileUsersList({
    required String authUserID,
  }) {
    return Stream.fromFuture(
      dio.get(
        ApiConstants.getAuthProfileUsers,
        queryParameters: {
          "WithPermission": true,
          "AuthUserID": authUserID,
        },
      ),
    ).map((event) {
      ResponseModel responseModel = ResponseModel.fromJson(event.data);
      return AuthResponseModel.fromJson(responseModel.data);
    });
  }
}
