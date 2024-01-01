// ignore_for_file: deprecated_member_use

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
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
import 'package:ptecpos_mobile/core/widget/app_dropdown.dart';
import 'package:ptecpos_mobile/core/widget/arrow_card.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/bloc/item_bloc.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_suppliers_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_scandata_model.dart';

class AddItemV3 extends StatefulWidget {
  final ItemBloc itemBloc;
  final void Function() onTap;

  const AddItemV3({super.key, required this.itemBloc, required this.onTap});

  @override
  State<AddItemV3> createState() => _AddItemV3State();
}

class _AddItemV3State extends State<AddItemV3> {
  late final void Function() bottomButtonBehaviour = widget.onTap;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.itemBloc.rebuildPage3,
      builder: (context, snapshot) {
        return SingleChildScrollView(
          child: Padding(
            padding: AppPaddingConstants().leftRight25,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                ArrowCard(
                  label: Text(
                    widget.itemBloc.itemVintageValue.valueOrNull?.name ?? "Vintage".i18n,
                    style: TextStyle(
                      color: widget.itemBloc.itemVintageValue.valueOrNull != null
                          ? AppColors.colorBlack
                          : AppColors.colorLightGrey100,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    TabNavigatorRouter(
                      navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                      currentPageKey: AppRouteManager.currentPage,
                    ).pushNamed(
                      AppRouteConstants.addVintageScreen,
                      arguments: {"itemBloc": widget.itemBloc},
                    )?.then((value) {
                      RootBloc().changeBottomBarBehaviour(
                        onTap: bottomButtonBehaviour,
                        bottomBarIconPath: icCheck,
                      );
                      widget.itemBloc.rebuildPage3.add(true);
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                  stream: widget.itemBloc.itemSupplierValue,
                  builder: (context, snapshot) {
                    return AppDropdown(
                      hintText: "Supplier".i18n,
                      value: widget.itemBloc.itemSupplierValue.valueOrNull,
                      items: widget.itemBloc.resItemSuppliersModel.data!.list!.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e.name!),
                        );
                      }).toList(),
                      onChanged: (ItemSuppliers? value) {
                        widget.itemBloc.itemSupplierValue.add(value);
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                  stream: widget.itemBloc.scanDataAllowed,
                  builder: (context, snapshot) {
                    return AppCheckBox(
                      value: widget.itemBloc.scanDataAllowed.value,
                      onChanged: (value) {
                        widget.itemBloc.itemScanValue.add(null);
                        widget.itemBloc.scanDataAllowed.add(value);
                      },
                      label: "Scan Data",
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                  stream: widget.itemBloc.itemScanValue,
                  builder: (context, snapshot) {
                    return AppDropdown(
                      hintText: "Select Scan Data".i18n,
                      value: widget.itemBloc.itemScanValue.valueOrNull,
                      items: widget.itemBloc.resScanDataModel.data!.list!.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e.name!),
                        );
                      }).toList(),
                      onChanged: widget.itemBloc.scanDataAllowed.value
                          ? (Scan? value) {
                              widget.itemBloc.itemScanValue.add(value);
                            }
                          : null,
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ArrowCard(
                  label: Text(
                    "Tax".i18n,
                    style: const TextStyle(
                      color: AppColors.colorLightGrey100,
                      fontSize: 16,
                    ),
                  ),
                  trailing: getSelectedTax(),
                  onTap: () {
                    TabNavigatorRouter(
                      navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                      currentPageKey: AppRouteManager.currentPage,
                    ).pushNamed(
                      AppRouteConstants.addItemTaxSlabScreen,
                      arguments: {"itemBloc": widget.itemBloc},
                    )?.then((value) async {
                      RootBloc().changeBottomBarBehaviour(
                        onTap: bottomButtonBehaviour,
                        bottomBarIconPath: icCheck,
                      );
                      if (!widget.itemBloc.isTaxSavedBtn) {
                        await Future.delayed(const Duration(milliseconds: 300));
                        widget.itemBloc.itemTaxSlabs.clear();
                      }
                      widget.itemBloc.rebuildPage3.add(true);
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ArrowCard(
                  label: Text(
                    "Triggers".i18n,
                    style: const TextStyle(
                      color: AppColors.colorLightGrey100,
                      fontSize: 16,
                    ),
                  ),
                  trailing: getSelectedTrigger(),
                  onTap: () {
                    TabNavigatorRouter(
                      navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                      currentPageKey: AppRouteManager.currentPage,
                    ).pushNamed(
                      AppRouteConstants.itemTriggerScreen,
                      arguments: {"itemBloc": widget.itemBloc},
                    )?.then((value) async {
                      RootBloc().changeBottomBarBehaviour(
                        onTap: bottomButtonBehaviour,
                        bottomBarIconPath: icCheck,
                      );
                      widget.itemBloc.rebuildPage3.add(true);
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    //if (widget.itemBloc.itemTypeValue.value!.code!.compareTo("MP") == 0) {
                    TabNavigatorRouter(
                      navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                      currentPageKey: AppRouteManager.currentPage,
                    ).pushNamed(
                      AppRouteConstants.itemPackageScreen,
                      arguments: {"itemBloc": widget.itemBloc},
                    )?.then((value) async {
                      RootBloc().changeBottomBarBehaviour(
                        onTap: bottomButtonBehaviour,
                        bottomBarIconPath: icCheck,
                      );
                      widget.itemBloc.resetPackageValue();
                    });
                    // } else {
                    //   TabNavigatorRouter(
                    //     navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                    //     currentPageKey: AppRouteManager.currentPage,
                    //   ).pushNamed(
                    //     AppRouteConstants.itemRootPackageScreen,
                    //     arguments: {"itemBloc": widget.itemBloc, "isMultiPack": false},
                    //   )?.then((value) {
                    //     RootBloc().changeBottomBarBehaviour(
                    //       onTap: bottomButtonBehaviour,
                    //       bottomBarIconPath: icCheck,
                    //     );
                    //
                    //     widget.itemBloc.resetPackageValue();
                    //   });
                    // }
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
                            style: AppTextStyle().lightTextStyle.copyWith(
                                  color: AppColors.colorBlack,
                                ),
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
                GestureDetector(
                  onTap: () {
                    if (widget.itemBloc.itemPrimaryPackageList.isNotEmpty) {
                      TabNavigatorRouter(
                        navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                        currentPageKey: AppRouteManager.currentPage,
                      ).pushNamed(
                        AppRouteConstants.itemPackagePriceLevelScreen,
                        arguments: {"itemBloc": widget.itemBloc},
                      )?.then((value) async {
                        RootBloc().changeBottomBarBehaviour(
                          onTap: bottomButtonBehaviour,
                          bottomBarIconPath: icCheck,
                        );
                      });
                    } else {
                      AppUtil.showSnackBar(label: "Please add primary package first".i18n);
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
                            "Add Price Level".i18n,
                            style: AppTextStyle().lightTextStyle.copyWith(
                                  color: AppColors.colorBlack,
                                ),
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
                GestureDetector(
                  onTap: () {
                    if (widget.itemBloc.itemPrimaryPackageList.isNotEmpty) {
                      TabNavigatorRouter(
                        navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                        currentPageKey: AppRouteManager.currentPage,
                      ).pushNamed(
                        AppRouteConstants.itemPackagePriceScreen,
                        arguments: {"itemBloc": widget.itemBloc},
                      )?.then((value) async {
                        RootBloc().changeBottomBarBehaviour(
                          onTap: bottomButtonBehaviour,
                          bottomBarIconPath: icCheck,
                        );
                      });
                    } else {
                      AppUtil.showSnackBar(label: "Please add primary package first".i18n);
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
                            "Add Price".i18n,
                            style: AppTextStyle().lightTextStyle.copyWith(
                                  color: AppColors.colorBlack,
                                ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 130,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getSelectedTax() {
    if (!widget.itemBloc.isTaxSavedBtn) {
      return const SizedBox.shrink();
    }
    int selectedTax = 0;
    for (var element in widget.itemBloc.itemTaxSlabs) {
      if (element.value.isSelected) {
        ++selectedTax;
      }
    }
    if (selectedTax == 0) {
      return const SizedBox.shrink();
    }
    return Text(
      "$selectedTax  Tax slab selected",
      style: const TextStyle(color: AppColors.colorDarkPrimary),
    );
  }

  Widget getSelectedTrigger() {
    int selectedTax = 0;
    for (var element in widget.itemBloc.triggersValue) {
      if (element.value) {
        ++selectedTax;
      }
    }
    if (selectedTax == 0) {
      return const SizedBox.shrink();
    }
    return Text(
      "$selectedTax  Triggers selected",
      style: const TextStyle(color: AppColors.colorDarkPrimary),
    );
  }
}
