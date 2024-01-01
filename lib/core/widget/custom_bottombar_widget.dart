// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/utils/image_path.dart';

class BottomBarWidget extends StatelessWidget {
  final void Function() onButtonPress;
  final void Function() onHomeBtnPress;
  final void Function() onReportsBtnPress;
  final void Function() onPosBtnPress;
  final void Function() onSettingsBtnPress;
  final BottomBarItem currentItem;
  final String? buttonIconPath;
  final double paddingButton;

  const BottomBarWidget({
    super.key,
    required this.onButtonPress,
    required this.onHomeBtnPress,
    required this.onReportsBtnPress,
    required this.onPosBtnPress,
    required this.onSettingsBtnPress,
    this.currentItem = BottomBarItem.home,
    this.buttonIconPath,
    this.paddingButton = 6,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.0,
      child: Stack(
        children: [
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 1.5,
                sigmaY: 1.5,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 1,
                    ),
                    child: /*Neumorphic(
                      style: NeumorphicStyle(
                        depth: -4,
                        color: AppColors.colorWhite,
                        shadowDarkColorEmboss:
                            AppColors.colorInnerShadowPrimary,
                        surfaceIntensity: 1,
                        intensity: 1,
                        boxShape: NeumorphicBoxShape.roundRect(
                          const BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                        ),
                      ),*/
                        AppUtil.neuMorphicWidget(
                      boxShape: NeumorphicBoxShape.roundRect(
                        const BorderRadius.only(
                          topRight: Radius.circular(
                            20,
                          ),
                          topLeft: Radius.circular(
                            20,
                          ),
                        ),
                      ),
                      depth: -5,
                      backgroundColor: AppColors.colorSecondary,
                      shadowColor: AppColors.colorInnerShadowPrimary,
                      surfaceIntensity: 1,
                      childWidget: Container(
                        height: 80,
                        decoration: AppUtil.containerDecoration(
                          borderColor: AppColors.colorLightGreen,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: onHomeBtnPress,
                              child: bottomMenuItem(
                                svgImage: icDashboard,
                                textName: "home".i18n,
                                selected: currentItem == BottomBarItem.home,
                              ),
                            ),
                            GestureDetector(
                              onTap: onReportsBtnPress,
                              child: bottomMenuItem(
                                svgImage: icReports,
                                textName: "reports".i18n,
                                selected: currentItem == BottomBarItem.reports,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: onPosBtnPress,
                              child: bottomMenuItem(
                                svgImage: icPOS,
                                textName: "pos".i18n,
                                selected: currentItem == BottomBarItem.pos,
                              ),
                            ),
                            GestureDetector(
                              onTap: onSettingsBtnPress,
                              child: bottomMenuItem(
                                svgImage: icSettings,
                                textName: "settings".i18n,
                                selected: currentItem == BottomBarItem.settings,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            top: 10,
            child: Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: onButtonPress,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: AppColors.colorSecondary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.colorShadowPrimary,
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.colorPrimary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.colorShadowPrimary,
                            blurRadius: 20,
                            offset: Offset(0, 20),
                          ),
                        ],
                      ),
                      child: Center(
                        child: buttonIconPath != null
                            ? Padding(
                                padding: EdgeInsets.all(paddingButton),
                                child: SvgPicture.asset(
                                  buttonIconPath!,
                                  color: AppColors.colorWhite,
                                ),
                              )
                            : const Icon(
                                Icons.arrow_forward,
                                color: AppColors.colorWhite,
                                size: 21,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomMenuItem({
    String? svgImage,
    String? textName,
    required bool selected,
  }) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svgImage!,
            height: 20,
            width: 20,
            color: selected ? AppColors.colorPrimary : AppColors.colorBlack,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            textName!,
            style: selected ? AppTextStyle.bottomSelectedTabTextStyle : AppTextStyle.bottomTabTextStyle,
          ),
        ],
      ),
    );
  }
}
