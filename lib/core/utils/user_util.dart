import 'dart:convert';

import 'package:ptecpos_mobile/core/preference/pref_constants.dart';
import 'package:ptecpos_mobile/core/preference/shared_preference.dart';
import 'package:ptecpos_mobile/features/authentication/model/response/auth_response_model.dart';

class UserUtil {
  static late ProfileModel profileModel;

  UserUtil() {
    profileModel = ProfileModel.fromJson(
      jsonDecode(
        SharedPreferencesUtils().getString(
          PrefConstants.profileModel,
        ),
      ),
    );
  }
}
