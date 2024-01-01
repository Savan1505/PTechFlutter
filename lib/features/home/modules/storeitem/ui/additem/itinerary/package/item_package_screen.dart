// ignore_for_file: deprecated_member_use

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/routes/tab_navigator.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/utils/image_path.dart';
import 'package:ptecpos_mobile/core/utils/route_constants.dart';
import 'package:ptecpos_mobile/core/widget/app_checkbox.dart';
import 'package:ptecpos_mobile/core/widget/simple_card.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/bloc/item_bloc.dart';
import 'package:rxdart/rxdart.dart';

class ItemPackageScreen extends StatefulWidget {
  final ItemBloc itemBloc;

  const ItemPackageScreen({super.key, required this.itemBloc});

  @override
  State<ItemPackageScreen> createState() => _ItemPackageScreenState();
}

class _ItemPackageScreenState extends State<ItemPackageScreen> {
  BehaviorSubject<bool> buildPackageList = BehaviorSubject<bool>.seeded(false);

  @override
  void initState() {
    super.initState();
    RootBloc().changeBottomBarBehaviour(onTap: buttonTapBehaviour, bottomBarIconPath: icCheck);
  }

  @override
  void dispose() {
    buildPackageList.close();
    super.dispose();
  }

  void buttonTapBehaviour() {
    // bool isSelected = false;
    // for (var ele in widget.itemBloc.triggersValue) {
    //   if (ele.value) {
    //     isSelected = true;
    //     break;
    //   }
    // }
    // if (isSelected) {
    //   TabNavigatorRouter(
    //     navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
    //     currentPageKey: AppRouteManager.currentPage,
    //   ).pop();
    // } else {
    //   AppUtil.showSnackBar(label: "Please select a trigger".i18n);
    // }
    if(widget.itemBloc.itemPrimaryPackageList.isNotEmpty) {
      TabNavigatorRouter(
        navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
        currentPageKey: AppRouteManager.currentPage,
      ).pop();
    }
    else {
      AppUtil.showSnackBar(label: "Please add at least one package".i18n);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppColors.colorWhite,
        leading: NeumorphicButton(
          margin: const EdgeInsets.all(8),
          padding: EdgeInsets.zero,
          onPressed: () async {
            TabNavigatorRouter(
              navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
              currentPageKey: AppRouteManager.currentPage,
            ).pop();
          },
          style: const NeumorphicStyle(
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.circle(),
            color: AppColors.colorWhite,
          ),
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.colorBlack,
            size: 19,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Packages".i18n,
              style: AppTextStyle().appBarTextStyle,
            ),
          ],
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: AppPaddingConstants().topBottom27,
              decoration: BoxDecoration(
                color: AppColors.colorLightGreen,
                border: Border.all(
                  color: AppColors.colorPrimary,
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder(
                    stream: widget.itemBloc.ringUpValue,
                    builder: (context, snapshot) {
                      return AppCheckBox(
                        label: "Hide Selection On The Ring Up".i18n,
                        value: widget.itemBloc.ringUpValue.value,
                        onChanged: (value) {
                          widget.itemBloc.ringUpValue.add(value);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: AppPaddingConstants().leftRight25,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      ///
                      if (widget.itemBloc.itemTypeValue.value!.code!.compareTo("MP") == 0) {
                        TabNavigatorRouter(
                          navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                          currentPageKey: AppRouteManager.currentPage,
                        ).pushNamed(
                          AppRouteConstants.itemRootPackageScreen,
                          arguments: {"itemBloc": widget.itemBloc, "isMultiPack": true},
                        )?.then((value) {
                          RootBloc().changeBottomBarBehaviour(
                            onTap: buttonTapBehaviour,
                            bottomBarIconPath: icCheck,
                          );
                          //widget.itemBloc.rebuildPage3.add(true);
                        });
                      } else {
                        if (widget.itemBloc.itemPrimaryPackageList.isEmpty) {
                          TabNavigatorRouter(
                            navigatorKey:
                                AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                            currentPageKey: AppRouteManager.currentPage,
                          ).pushNamed(
                            AppRouteConstants.itemRootPackageScreen,
                            arguments: {"itemBloc": widget.itemBloc, "isMultiPack": false},
                          )?.then((value) {
                            RootBloc().changeBottomBarBehaviour(
                              onTap: buttonTapBehaviour,
                              bottomBarIconPath: icCheck,
                            );
                          });
                        } else {
                          AppUtil.showSnackBar(
                            label:
                                "The selected package type is not of Multi pack therefore you can create only a single primary package"
                                    .i18n,
                          );
                        }
                      }
                    },
                    child: Neumorphic(
                      style: const NeumorphicStyle(
                        shape: NeumorphicShape.concave,
                        color: AppColors.colorWhite,
                        surfaceIntensity: 0.02,
                        intensity: 0.43,
                      ),
                      child: Container(
                        height: 52,
                        color: AppColors.colorWhite,
                        child: Row(
                          children: [
                            Padding(
                              padding: AppPaddingConstants().symmetricH10,
                              child: const Icon(
                                Icons.add,
                                size: 35,
                                color: AppColors.colorBlack,
                              ),
                            ),
                            Text(
                              "Add Packages".i18n,
                              style: AppTextStyle().darkTextStyle,
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder(
                    stream: buildPackageList,
                    builder: (context, snapshot) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.itemBloc.itemPrimaryPackageList.length,
                        itemBuilder: (ctx, index) {
                          var package = widget.itemBloc.itemPrimaryPackageList[index];
                          return SimpleCard(
                            name: package.packageName ?? "",
                            trailing: GestureDetector(
                              onTap: () {
                                if (index != 0) {
                                  widget.itemBloc.itemPrimaryPackageList.removeAt(index);
                                  buildPackageList.add(true);
                                  if (widget.itemBloc.itemStoreItemPriceList.isNotEmpty) {
                                    widget.itemBloc.itemStoreItemPriceList.clear();
                                  }
                                  if (widget.itemBloc.itemStoreItemPriceLevelList.isNotEmpty) {
                                    widget.itemBloc.itemStoreItemPriceLevelList.clear();
                                  }
                                }
                              },
                              child: Padding(
                                padding: AppPaddingConstants().right8,
                                child: SvgPicture.asset(
                                  icTrashIcon,
                                  color: index == 0 ? AppColors.defaultGreyColor : AppColors.redColor,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
