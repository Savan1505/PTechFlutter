import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/utils/image_path.dart';
import 'package:ptecpos_mobile/core/widget/app_bottom_sheet.dart';
import 'package:ptecpos_mobile/core/widget/app_button.dart';
import 'package:ptecpos_mobile/core/widget/app_toggle_switch.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/model/req_employee_access_model.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/model/res_employee_model.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/repo/employee_repo.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/state/employee_state.dart';
import 'package:rxdart/rxdart.dart';

class EmployeeCard extends StatelessWidget {
  final String employeeName;
  final String role;
  final String? logo;

  final bool isWebUser;
  final bool isWebUserExist;
  final bool isPosUser;

  final Employee employee;
  final BehaviorSubject<EmployeeState> employeeState;
  final void Function()? onEditTap;
  final void Function()? onDeleteTap;

  const EmployeeCard({
    super.key,
    required this.employeeName,
    this.logo,
    required this.onEditTap,
    required this.role,
    required this.isWebUser,
    required this.isPosUser,
    required this.isWebUserExist,
    required this.employee,
    required this.employeeState,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    BehaviorSubject<bool> isExpanded = BehaviorSubject<bool>.seeded(false);

    return StreamBuilder(
      stream: isExpanded,
      builder: (context, snapshot) {
        return AppUtil.neuMorphicWidget(
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(
              12,
            ),
          ),
          border: NeumorphicBorder(
            color: isExpanded.value ? AppColors.colorPrimary : AppColors.colorTransparent,
            width: 0.5,
          ),
          depth: 9,
          topMargin: 7,
          backgroundColor: AppColors.colorSecondary,
          childWidget: Container(
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
            child: ExpansionTileCard(
              onExpansionChanged: (val) {
                isExpanded.add(val);
              },
              baseColor: AppColors.colorSecondary,
              expandedColor: AppColors.colorLightGreen,
              shadowColor: AppColors.colorTransparent,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              finalPadding: EdgeInsets.zero,
              trailing: const SizedBox.shrink(),
              leading: logo?.isNotEmpty ?? false
                  ? AppUtil.circularTextAndImageWidget(
                      childWidget: AppUtil.circularImageWidget(
                        decodeLogo: AppUtil.convertStringToUint8List(
                              logo?.split(",").last,
                            ) ??
                            Uint8List(-1),
                        depth: -5,
                      ),
                    )
                  : AppUtil.circularTextAndImageWidget(
                      childWidget: AppUtil.circularProfileNameWidget(
                        profileName: employeeName[0],
                      ),
                    ),
              title: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            employeeName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.storeHeaderTextStyle,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            role,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15, color: AppColors.colorHint),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Neumorphic(
                          style: NeumorphicStyle(
                            color: AppColors.colorLightGreen,
                            boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(
                                100,
                              ),
                            ),
                            depth: NeumorphicTheme.embossDepth(context),
                            border: const NeumorphicBorder.none(),
                            shadowDarkColorEmboss: const Color.fromRGBO(0, 0, 0, 0.30196078431372547),
                            shadowLightColorEmboss: AppColors.colorWhite,
                          ),
                          child: Center(
                            child: Padding(
                              padding: AppPaddingConstants().employeeCardPadding,
                              child: Text(
                                (isPosUser) ? "POS" : "No Pos Access",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: (isPosUser) ? AppColors.colorBlack : AppColors.redColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Neumorphic(
                          style: NeumorphicStyle(
                            color: AppColors.colorWhite,
                            boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(
                                100,
                              ),
                            ),
                            depth: NeumorphicTheme.embossDepth(context),
                            border: const NeumorphicBorder.none(),
                            shadowDarkColorEmboss: const Color.fromRGBO(0, 0, 0, 0.30196078431372547),
                            shadowLightColorEmboss: AppColors.colorWhite,
                          ),
                          child: Center(
                            child: Padding(
                              padding: AppPaddingConstants().employeeCardPadding,
                              child: Text(
                                (isWebUser) ? "WEB" : "No Web Access",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: (isWebUser) ? AppColors.colorBlack : AppColors.redColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: const Divider(
                    color: AppColors.colorInnerShadowPrimary,
                    thickness: 0.5,
                  ),
                ),
                // Padding(
                //   padding: AppPaddingConstants().leftRight20,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       GestureDetector(
                //         onTap: onEditTap,
                //         child: Row(
                //           children: [
                //             AppUtil.svgAssetsColorWidget(
                //               icAssetsSVG: icEditIcon,
                //               height: 20,
                //             ),
                //             const SizedBox(
                //               width: 10,
                //             ),
                //             Text(
                //               "Edit".i18n,
                //               style: AppTextStyle.storeListItemTextStyle,
                //             ),
                //             const SizedBox(
                //               width: 17,
                //             ),
                //             Container(
                //               height: 60,
                //               color: AppColors.colorInnerShadowPrimary,
                //               width: 0.5,
                //             ),
                //           ],
                //         ),
                //       ),
                //       // GestureDetector(
                //       //   onTap: onDeleteTap,
                //       //   child: Row(
                //       //     children: [
                //       //       AppUtil.svgAssetsColorWidget(
                //       //         icAssetsSVG: icTrashIcon,
                //       //         height: 20,
                //       //       ),
                //       //       const SizedBox(
                //       //         width: 10,
                //       //       ),
                //       //       Text(
                //       //         "Delete".i18n,
                //       //         style: AppTextStyle.storeListItemTextStyle,
                //       //       ),
                //       //       const SizedBox(
                //       //         width: 17,
                //       //       ),
                //       //       Container(
                //       //         height: 60,
                //       //         color: AppColors.colorInnerShadowPrimary,
                //       //         width: 0.5,
                //       //       ),
                //       //     ],
                //       //   ),
                //       // ),
                //       GestureDetector(
                //         onTap: () {
                //           if (isWebUserExist || isPosUser) {
                //             accessBottomSheet(AppRouteManager.navigatorKey.currentContext!);
                //           }
                //         },
                //         child: Row(
                //           children: [
                //             SvgPicture.asset(
                //               icAccessIcon,
                //               // ignore: deprecated_member_use
                //               color:  AppColors.colorPrimary,
                //             ),
                //             const SizedBox(
                //               width: 10,
                //             ),
                //             Text(
                //               "Access".i18n,
                //               style: (isWebUserExist || isPosUser)
                //                   ? AppTextStyle.storeListItemTextStyle
                //                   : const TextStyle(
                //                       letterSpacing: 0.5,
                //                       decoration: TextDecoration.none,
                //                       fontSize: 14,
                //                       fontWeight: FontWeight.w500,
                //                       color: AppColors.colorGrey,
                //                     ),
                //             ),
                //             const SizedBox(
                //               width: 17,
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: onEditTap,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              icEditIcon,
                              height: 20,
                              width: 50,
                              // ignore: deprecated_member_use
                              color: AppColors.colorPrimary,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Edit".i18n,
                              style: AppTextStyle.storeListItemTextStyle,
                            ),
                            const SizedBox(
                              width: 17,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 60,
                        color: AppColors.colorInnerShadowPrimary,
                        width: 0.5,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (isWebUserExist || isPosUser) {
                            accessBottomSheet(AppRouteManager.navigatorKey.currentContext!);
                          }
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              icAccessIcon,
                              // ignore: deprecated_member_use
                              color: AppColors.colorPrimary,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Access".i18n,
                              style: (isWebUserExist || isPosUser)
                                  ? AppTextStyle.storeListItemTextStyle
                                  : const TextStyle(
                                      letterSpacing: 0.5,
                                      decoration: TextDecoration.none,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.colorGrey,
                                    ),
                            ),
                            const SizedBox(
                              width: 17,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void accessBottomSheet(BuildContext context) {
    BehaviorSubject<bool> isWebUser = BehaviorSubject<bool>.seeded(this.isWebUser);
    BehaviorSubject<bool> isPosUser = BehaviorSubject<bool>.seeded(this.isPosUser);

    AppBottomSheet(
      child: Column(
        children: [
          const SizedBox(
            height: 85,
          ),
          Visibility(
            visible: isWebUserExist,
            child: StreamBuilder(
              stream: isWebUser,
              builder: (context, snapshot) {
                return AppToggleSwitch(
                  value: isWebUser.value,
                  title: "Web User".i18n,
                  onChange: (val) {
                    isWebUser.add(val);
                  },
                );
              },
            ),
          ),
          const SizedBox(
            height: 17,
          ),
          Visibility(
            visible: this.isPosUser,
            child: StreamBuilder(
              stream: isPosUser,
              builder: (context, snapshot) {
                return AppToggleSwitch(
                  value: isPosUser.value,
                  title: "Pos User".i18n,
                  onChange: (val) {
                    isPosUser.add(val);
                  },
                );
              },
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          AppButton(
            label: "APPLY".i18n,
            onPressed: () {
              List<ReqEmployeeAccessModel> data = [
                ReqEmployeeAccessModel(
                  path: "/PosUser",
                  value: isPosUser.value.toString(),
                ),
                ReqEmployeeAccessModel(
                  path: "/WebUser",
                  value: isWebUser.value.toString(),
                ),
              ];
              AppUtil.showLoader(context: context);
              EmployeeRepo().updateEmployeeAccess(data, employee.id!).map((event) {
                if (!(event.error ?? true)) {
                  employee.webUser = isWebUser.value;
                  employee.posUser = isPosUser.value;
                  employeeState.add(EmployeeState.completed(true));
                  AppUtil.hideLoader(context: context);
                  Navigator.pop(context);
                } else {
                  AppUtil.hideLoader(context: context);
                  AppUtil.showSnackBar(
                    label: "Error while updating the employee access".i18n,
                  );
                }
              }).onErrorReturnWith((error, stackTrace) {
                debugPrint(error.toString());
                debugPrint(stackTrace.toString());
                AppUtil.hideLoader(context: context);
                AppUtil.showSnackBar(
                  label: "Error while updating the employee access".i18n,
                );
              }).listen((event) {});
            },
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    ).showBottomSheet();
  }
}
