import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:ptecpos_mobile/core/preference/pref_constants.dart';
import 'package:ptecpos_mobile/core/preference/shared_preference.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_constants.dart';
import 'package:ptecpos_mobile/core/utils/image_path.dart';

class AppUtil {
  static late Authenticator authenticator;

  //Neu-morphic Widget
  static Widget neuMorphicWidget({
    NeumorphicBoxShape? boxShape,
    required Widget childWidget,
    Color? backgroundColor,
    Color? shadowColor,
    double? depth,
    double? topMargin,
    double? surfaceIntensity,
    NeumorphicBorder? border,
  }) {
    return Neumorphic(
      margin: EdgeInsets.only(
        top: topMargin ?? 0,
      ),
      style: neuMorphicStyle(
        boxShape: boxShape,
        backgroundColor: backgroundColor,
        depth: depth,
        surfaceIntensity: surfaceIntensity,
        shadowColor: shadowColor,
        border: border,
      ),
      child: childWidget,
    );
  }

  //Neu-morphic Style
  static NeumorphicStyle neuMorphicStyle({
    NeumorphicBoxShape? boxShape,
    Color? backgroundColor,
    Color? shadowColor,
    double? depth,
    double? surfaceIntensity,
    NeumorphicBorder? border,
  }) {
    return NeumorphicStyle(
      boxShape: boxShape ?? const NeumorphicBoxShape.circle(),
      depth: depth ?? 15,
      shape: NeumorphicShape.concave,
      shadowDarkColorEmboss: shadowColor ?? AppColors.colorSecondary,
      color: backgroundColor ?? AppColors.colorGray,
      surfaceIntensity: surfaceIntensity ?? 0.15,
      border: border ?? const NeumorphicBorder.none(),
    );
  }

  ///Give context whenever you want to use it on bottom sheet or any other fragmented widget
  static void showSnackBar({required String label, BuildContext? context}) {
    SnackBar snackBar = SnackBar(
      content: Text(
        label,
        style: const TextStyle(
          color: AppColors.colorWhite,
        ),
      ),
      backgroundColor: AppColors.colorPrimary,
      elevation: 10,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(5),
    );
    ScaffoldMessenger.of(context ?? AppRouteManager.navigatorKey.currentState!.context)
        .showSnackBar(snackBar);
  }

  static Uint8List? convertStringToUint8List(String? str) {
    if (str == null || (str.isEmpty)) return null;
    return const Base64Decoder().convert(str);
  }

  static Widget circularImageWidget({
    String? icAssetsSVG,
    IconData? iconData,
    Uint8List? decodeLogo,
    double? height,
    double? depth,
    double? paddingAll,
    NeumorphicBorder? border,
  }) {
    return neuMorphicWidget(
      backgroundColor: AppColors.colorShadowWhite,
      depth: depth ?? 9,
      shadowColor: AppColors.colorInnerShadowPrimary,
      border: border,
      surfaceIntensity: 0,
      childWidget: icAssetsSVG?.isNotEmpty ?? false
          ? SvgPicture.asset(
              icAssetsSVG ?? "",
              height: height ?? 50,
            )
          : decodeLogo?.isNotEmpty ?? false
              ? Image.memory(
                  decodeLogo ?? Uint8List(-1),
                )
              : Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.colorLightGray,
                        AppColors.colorSecondary,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [-10, 0.5],
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(
                      paddingAll ?? 0,
                    ),
                    child: NeumorphicIcon(
                      iconData ?? Icons.notifications,
                      style: neuMorphicStyle(
                        backgroundColor: AppColors.colorBlack,
                        depth: depth ?? 9,
                      ),
                      size: height ?? 50,
                    ),
                  ),
                ),
    );
  }

  static Widget circularProfileNameWidget({
    String? profileName,
  }) {
    return neuMorphicWidget(
      depth: -3,
      backgroundColor: AppColors.colorSecondary,
      shadowColor: AppColors.colorInnerShadowPrimary,
      border: const NeumorphicBorder(
        width: 2,
        color: AppColors.colorSecondary,
      ),
      childWidget: Center(
        child: Text(
          profileName?.toUpperCase() ?? "",
          textAlign: TextAlign.center,
          style: AppTextStyle.storeProfileTextStyle,
        ),
      ),
    );
  }

  Widget drawerButton() {
    return NeumorphicButton(
      style: NeumorphicStyle(
        shape: NeumorphicShape.concave,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(4)),
        color: AppColors.colorWhite,
      ),
      padding: const EdgeInsets.only(left: 11, right: 11, top: 11, bottom: 11),
      onPressed: () {
        RootBloc().openDrawer();
      },
      child: SvgPicture.asset(
        icMenu,
        height: 16,
        width: 21,
      ),
    );
  }

  //app container decoration
  static BoxDecoration containerDecoration({
    Color? borderColor,
    double? radiusTopLeft,
    double? radiusTopRight,
    double? radiusBottomLeft,
    double? radiusBottomRight,
  }) {
    return BoxDecoration(
      border: Border.all(
        color: borderColor ?? AppColors.colorTransparent,
      ),
      color: AppColors.colorSecondary,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radiusTopLeft ?? 0),
        topRight: Radius.circular(radiusTopRight ?? 0),
        bottomLeft: Radius.circular(radiusBottomLeft ?? 0),
        bottomRight: Radius.circular(radiusBottomRight ?? 0),
      ),
    );
  }

  //Hide keyboard
  static hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(
      FocusNode(),
    );
  }

  //Text Style
  static textStyle({
    double? letterSpacing,
    FontWeight? fontWeight,
    double? fontSize,
    Color? textColor,
    TextDecoration? textDecoration,
  }) {
    return TextStyle(
      letterSpacing: letterSpacing ?? -1,
      fontSize: fontSize ?? 16,
      fontFamily: AppConstants.fontFamily,
      fontWeight: fontWeight ?? FontWeight.w400,
      decoration: textDecoration ?? TextDecoration.none,
      color: textColor,
    );
  }

  //Margin
  static EdgeInsets allMargin({
    double? top,
    double? bottom,
    double? left,
    double? right,
    bool isAll = false,
    double? allMargin,
  }) {
    return isAll
        ? EdgeInsets.all(
            allMargin ?? 0,
          )
        : EdgeInsets.only(
            top: top ?? 0,
            bottom: bottom ?? 0,
            left: left ?? 0,
            right: right ?? 0,
          );
  }

  //Padding
  static EdgeInsets allPadding({
    double? left,
    double? right,
    double? top,
    double? bottom,
    bool isAll = false,
    double? allPadding,
  }) {
    return isAll
        ? EdgeInsets.all(
            allPadding ?? 0,
          )
        : EdgeInsets.only(
            top: top ?? 0,
            bottom: bottom ?? 0,
            left: left ?? 0,
            right: right ?? 0,
          );
  }

  ///Give context whenever you want to use it on bottom sheet or any other fragmented widget
  static void showLoader({BuildContext? context}) {
    showDialog(
      context: AppRouteManager.navigatorKey.currentState!.context,
      barrierDismissible: false,
      builder: (builder) {
        return WillPopScope(
          onWillPop: () async {
            await Future.delayed(Duration.zero);
            return false;
          },
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  bool isEmailValid(String email) {
    RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
    );

    return emailRegex.hasMatch(email);
  }

  //Hide Loader
  ///Give context whenever you want to use it on bottom sheet or any other fragmented widget
  static void hideLoader({BuildContext? context}) {
    Navigator.pop(context ?? AppRouteManager.getCurrentContext());
  }

  static void hideMainContextLoader({BuildContext? context}) {
    AppRouteManager.pop();
  }

  static String? displayDateFormat({required DateTime? dateTime}) {
    if (dateTime == null) {
      return null;
    }
    return DateFormat("MM-dd-yyyy").format(dateTime);
  }

  static String? backendDateFormat({required DateTime? dateTime}) {
    if (dateTime == null) {
      return null;
    }
    return DateFormat("yyyy-MM-dd").format(dateTime);
  }

  /// Allow decimal places up to 15 places
  static Pattern allowDecimal() {
    return RegExp(r'^\d*\.?\d{0,15}$');
  }

  static String getOpenIdAccessToken() {
    return SharedPreferencesUtils().getString(PrefConstants.openIdAccessToken);
  }

  static String getOpenIdUserId() {
    return SharedPreferencesUtils().getString(PrefConstants.userId);
  }

  static String getOpenIdFamilyName() {
    return SharedPreferencesUtils().getString(PrefConstants.familyName);
  }

  static String getOpenIdTenant() {
    return SharedPreferencesUtils().getString(PrefConstants.tenant);
  }

  //Rich text for the some text style change
  static Widget richText({
    String? startText,
    String? centerText,
    String? lastText,
  }) {
    return RichText(
      text: TextSpan(
        text: startText,
        style: richTextStyle(),
        children: <TextSpan>[
          TextSpan(
            text: centerText ?? "",
            style: richTextStyle(
              textColor: AppColors.colorPrimary,
            ),
          ),
          TextSpan(
            text: lastText ?? "",
            style: richTextStyle(),
          ),
        ],
      ),
    );
  }

  static TextStyle richTextStyle({Color? textColor}) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      color: textColor ?? AppColors.colorBlack,
      fontFamily: AppConstants.fontFamily,
      fontSize: 35,
      letterSpacing: 0.5,
      height: 1.5,
    );
  }

  static Widget circularTextAndImageWidget({required Widget childWidget}) {
    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.only(
        left: 15,
      ),
      child: childWidget,
    );
  }
}
