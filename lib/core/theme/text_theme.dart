import 'package:flutter/cupertino.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';

class AppTextStyle {
  static TextStyle defaultTextStyle = const TextStyle(
    letterSpacing: 0.5,
    fontSize: 16,
    color: AppColors.colorBlack,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.none,
  );

  static TextStyle storeListItemTextStyle = const TextStyle(
    letterSpacing: 0.5,
    decoration: TextDecoration.none,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.colorBlack,
  );

  static TextStyle storeHeaderTextStyle = const TextStyle(
    letterSpacing: 0.5,
    decoration: TextDecoration.none,
    fontSize: 14,
    color: AppColors.colorBlack,
    fontWeight: FontWeight.w400,
  );

  static TextStyle storeTextStyle = const TextStyle(
    color: AppColors.colorPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    overflow: TextOverflow.ellipsis,
    letterSpacing: 0.5,
    decoration: TextDecoration.none,
  );

  static TextStyle storeListTextStyle = const TextStyle(
    letterSpacing: 0.5,
    decoration: TextDecoration.none,
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: AppColors.colorHint,
  );

  static TextStyle storeProfileTextStyle = const TextStyle(
    letterSpacing: 0.5,
    color: AppColors.colorBlack,
    decoration: TextDecoration.none,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static TextStyle bottomTabTextStyle = const TextStyle(
    letterSpacing: 0.5,
    color: AppColors.colorBlack,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.none,
    fontSize: 10,
  );

  static TextStyle bottomSelectedTabTextStyle = const TextStyle(
    letterSpacing: 0.5,
    color: AppColors.colorPrimary,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.none,
    fontSize: 10,
  );

  TextStyle sideMenuHeaderStyle = const TextStyle(
    letterSpacing: 1.44,
    color: AppColors.colorWhite,
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );
  TextStyle sideMenuStoreNameStyle = const TextStyle(
    color: AppColors.colorWhite,
    fontSize: 13,
  );
  TextStyle sideMenuItemStyle = const TextStyle(
    color: AppColors.colorWhite,
    fontSize: 14,
  );

  TextStyle homeStyle = const TextStyle(
    fontSize: 12,
    color: AppColors.colorBlack,
  );
  TextStyle homeStyle2 = const TextStyle(
    color: AppColors.colorBlack,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  TextStyle errorStyle = const TextStyle(
    color: AppColors.colorError,
    fontSize: 11,
  );
  TextStyle lightTextStyle = const TextStyle(
    color: AppColors.colorHint,
    fontSize: 16,
  );

  TextStyle lightTextStyle100 = const TextStyle(
    fontSize: 16,
    color: AppColors.colorLightGrey100,
  );

  TextStyle darkTextStyle = const TextStyle(
    color: AppColors.colorBlack,
    fontSize: 16,
  );
  TextStyle employeeTextStyle = const TextStyle(
    color: AppColors.colorBlack,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  TextStyle lightPrimaryStyle = const TextStyle(
    color: AppColors.colorPrimary,
    fontWeight: FontWeight.w600,
  );

  TextStyle appBarTextStyle = const TextStyle(
    fontSize: 16,
    color: AppColors.colorBlack,
    fontWeight: FontWeight.bold,
  );
}
