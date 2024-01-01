import 'package:ptecpos_mobile/features/authentication/datasource/auth_datasource.dart';
import 'package:ptecpos_mobile/features/authentication/model/response/auth_response_model.dart';

class AuthRepo {
  AuthDatasource authDatasource = AuthDatasource();

  Stream<AuthResponseModel> getAuthProfileUsersListAPI({
    required String authUserID,
  }) {
    return authDatasource.getAuthProfileUsersList(authUserID: authUserID);
  }
}
