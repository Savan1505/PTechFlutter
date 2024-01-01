import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:ptecpos_mobile/core/base/base_bloc.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/preference/pref_constants.dart';
import 'package:ptecpos_mobile/core/preference/shared_preference.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/utils/flavors.dart';
import 'package:ptecpos_mobile/core/utils/route_constants.dart';
import 'package:ptecpos_mobile/features/authentication/model/response/auth_response_model.dart';
import 'package:ptecpos_mobile/features/authentication/repository/auth_repo.dart';
import 'package:ptecpos_mobile/features/authentication/ui/bloc/authentication_state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthenticationBloc extends BaseBloc {
  late AnimationController controller;
  late Animation<double> animation;
  late AuthResponseModel authResponseModel;
  AuthRepo authRepo = AuthRepo();

  //Login
  bool obscureText = true;

  //Open id client
  late Client client;
  Credential? credential;
  String? authUserID;

  //State
  BehaviorSubject<AuthenticationState> authenticateState = BehaviorSubject<AuthenticationState>();

  //Open Id Client Connect
  // Future<void> openIdClient() async {
  //   client = await AppUtil.getClient();
  // }

  //Open Id return Auth User Id
  getOpenIdAuthUserId() {
    authUserID = AppUtil.getOpenIdUserId();
  }

  //Login page
  loginRedirection() {
    AppRouteManager.pushNamed(
      AppRouteConstants.login,
    );
  }

  void getAuthProfileUsersListAPI() {
    subscription.add(
      authRepo
          .getAuthProfileUsersListAPI(
        authUserID: authUserID ?? "0",
      )
          .map((event) {
        authResponseModel = event;
        SharedPreferencesUtils().setString(
          PrefConstants.profileModel,
          jsonEncode(
            authResponseModel.list?[0].profileModel?.toJson(),
          ),
        );
        SharedPreferencesUtils().setString(
          PrefConstants.permissionList,
          PermissionList.encode(authResponseModel.list?[0].permissionList ?? []),
        );

        AppRouteManager.pushNamedAndRemoveUntil(
          AppRouteConstants.store,
          (route) => false,
        );
      }).onErrorReturnWith((error, stackTrace) {
        AppUtil.hideLoader();
        AppUtil.showSnackBar(label: "Something went wrong while logging you in");
      }).listen((event) {}),
    );
  }

  // Future<Client> getClient() async {
  //   var uri = Uri.parse(Flavors.getKeyCloakUrl()!);
  //   Issuer? issuer;
  //   await Issuer.discover(uri).then((value) {
  //     issuer = value;
  //   }).onError((error, stackTrace) {
  //     debugPrint(error.toString());
  //   });
  //   client = Client(
  //     issuer!,
  //     Flavors.getClientId()!,
  //     clientSecret: Flavors.getClientSecret(),
  //   );
  //   return client;
  // }

  Future<bool> getClient() async {
    AppUtil.showLoader();
    try {
      var uri = Uri.parse(Flavors.getKeyCloakUrl()!);
      Issuer? issuer;
      await Issuer.discover(uri).then((value) {
        issuer = value;
      });
      client = Client(
        issuer!,
        Flavors.getClientId()!,
        clientSecret: Flavors.getClientSecret(),
      );
      AppUtil.hideLoader();
      return true;
    } catch (e) {
      if (e is SocketException) {
        AppUtil.showSnackBar(label: "Please check your network".i18n);
      } else {
        AppUtil.showSnackBar(label: "Something went wrong".i18n);
      }
    }
    AppUtil.hideLoader();
    return false;
  }

  Future<void> authenticate() async {
    urlLauncher(String url) async {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView);
      } else {
        throw 'Could not launch $url';
      }
    }

    var authenticator = Authenticator(
      client,
      scopes: Flavors.getScopes()!,
      port: Flavors.getOpenIdPortPort()!,
      urlLancher: urlLauncher,
      redirectUri: Uri.parse(Flavors.getRedirectUrl()!),
      redirectMessage: "fetchingYourData".i18n,
    );
    var credential = await authenticator.authorize();
    await credential.getTokenResponse().then((tokenResponse) async {
      await SharedPreferencesUtils().setString(
        PrefConstants.openIdAccessToken,
        tokenResponse.accessToken ?? "",
      );
      await SharedPreferencesUtils().setString(
        PrefConstants.userId,
        tokenResponse['userid'],
      );
      await SharedPreferencesUtils().setString(
        PrefConstants.familyName,
        tokenResponse['family_name'],
      );
      await SharedPreferencesUtils().setString(
        PrefConstants.tenant,
        tokenResponse['tenant'],
      );
      await SharedPreferencesUtils().setString(
        PrefConstants.userLogOutUrl,
        client.issuer.metadata.endSessionEndpoint.toString(),
      );
      AppUtil.authenticator = authenticator;
      closeInAppWebView();
    }).onError((error, stackTrace) async {
      debugPrint(error.toString());
      await closeInAppWebView();
      AppUtil.showSnackBar(
        label: "Please try to login after some time there happens to be some issue while logging you in",
      );
    });
  }
}
