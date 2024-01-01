import 'package:flutter/services.dart';
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
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/bloc/item_bloc.dart';

class AddItemPackageV2 extends StatefulWidget {
  final ItemBloc itemBloc;
  final bool isMultiPack;
  final void Function() onTap;

  const AddItemPackageV2({
    super.key,
    required this.itemBloc,
    required this.onTap,
    required this.isMultiPack,
  });

  @override
  State<AddItemPackageV2> createState() => _AddItemPackageV2State();
}

class _AddItemPackageV2State extends State<AddItemPackageV2> {
  late final void Function() bottomButtonBehaviour = widget.onTap;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.itemBloc.formPackageKeyV2,
      child: StreamBuilder(
        stream: widget.itemBloc.rebuildPackagePage2,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Padding(
              padding: AppPaddingConstants().leftRight25,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  StreamBuilder(
                    stream: widget.itemBloc.itemDownByTap.stream,
                    builder: (context, snapshot) {
                      return Focus(
                        onFocusChange: (val) {
                          widget.itemBloc.itemDownByTap.add(val);
                          if (!val && widget.itemBloc.itemDownByController.text.isNotEmpty) {
                            double downByValue = double.parse(
                              double.parse(widget.itemBloc.itemDownByController.text)
                                  .toStringAsFixed(2),
                            );
                            double unitCost = double.parse(
                              widget.itemBloc.itemPackageUnitCostController.text.isEmpty
                                  ? "0.0"
                                  : double.parse(
                                widget.itemBloc.itemPackageUnitCostController.text,
                              ).toStringAsFixed(2),
                            );
                            if (unitCost < downByValue) {
                              AppUtil.showSnackBar(
                                label:
                                "Down by price can not be greater than the 'Unit cost'".i18n,
                              );
                            }
                          }
                        },
                        child: AppTextField(
                          isFocused: widget.itemBloc.itemDownByTap.value,
                          label: "Down By".i18n,
                          textEditingController: widget.itemBloc.itemDownByController,
                          showError: false,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChangeFunction: (value) {
                            if (value?.isNotEmpty ?? false) {
                              /// Calculation
                              if (double.parse(value!) != 0) {
                                widget.itemBloc.marginMarkupCalculation();
                                widget.itemBloc.retailMarginCalculation();
                                widget.itemBloc.retailMarkupCalculation();
                              }
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(AppUtil.allowDecimal()),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: widget.itemBloc.itemPackageForValue.value!.code.compareTo("Prse") != 0,
                    child: Column(
                      children: [
                        StreamBuilder(
                          stream: widget.itemBloc.itemRetailPriceTap.stream,
                          builder: (context, snapshot) {
                            return Focus(
                              onFocusChange: (val) {
                                widget.itemBloc.itemRetailPriceTap.add(val);
                                if (!val &&
                                    widget.itemBloc.itemRetailPriceController.text.isNotEmpty) {
                                  double unitCost = double.parse(
                                    widget.itemBloc.itemPackageUnitCostController.text.isEmpty
                                        ? "0.0"
                                        : double.parse(
                                      widget.itemBloc.itemPackageUnitCostController.text,
                                    ).toStringAsFixed(2),
                                  );
                                  double retailPrice = double.parse(
                                    widget.itemBloc.itemRetailPriceController.text.isEmpty
                                        ? "0.0"
                                        : double.parse(
                                      widget.itemBloc.itemRetailPriceController.text,
                                    ).toStringAsFixed(2),
                                  );
                                  double mergePrice = unitCost -
                                      double.parse(
                                        widget.itemBloc.itemDownByController.text.isEmpty
                                            ? "0.0"
                                            : double.parse(
                                          widget.itemBloc.itemDownByController.text,
                                        ).toStringAsFixed(2),
                                      );
                                  if (retailPrice > 0) {
                                    if (mergePrice > retailPrice) {
                                      AppUtil.showSnackBar(
                                        label:
                                        "The 'Retail Price' can not be less than the 'Unit Cost'"
                                            .i18n,
                                      );
                                    }
                                  }
                                  widget.itemBloc.itemWarmPriceController.clear();
                                  widget.itemBloc.itemColdPriceController.clear();
                                }
                              },
                              child: Column(
                                children: [
                                  AppTextField(
                                    isFocused: widget.itemBloc.itemRetailPriceTap.value,
                                    label: "Retail Price".i18n,
                                    textEditingController:
                                    widget.itemBloc.itemRetailPriceController,
                                    showError: widget.itemBloc.itemRetailPriceShowError.value,
                                    keyboardType:
                                    const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(AppUtil.allowDecimal()),
                                    ],
                                    onChangeFunction: (value) {
                                      if (value?.isNotEmpty ?? false) {
                                        if (double.parse(value!) != 0 &&
                                            double.parse(value) >
                                                double.parse(
                                                  widget.itemBloc.itemPackageUnitCostController
                                                      .text.isEmpty
                                                      ? "0.0"
                                                      : double.parse(
                                                    widget.itemBloc
                                                        .itemPackageUnitCostController.text,
                                                  ).toStringAsFixed(2),
                                                )) {
                                          widget.itemBloc.marginMarkupCalculation();
                                        }
                                      }
                                      return null;
                                    },
                                    validatorFunction: (value) {
                                      if (value == null || value.isEmpty) {
                                        widget.itemBloc.itemRetailPriceTap
                                            .add(widget.itemBloc.itemRetailPriceTap.value);
                                        widget.itemBloc.itemRetailPriceShowError.add(true);
                                      } else {
                                        widget.itemBloc.itemRetailPriceTap
                                            .add(widget.itemBloc.itemRetailPriceTap.value);
                                        widget.itemBloc.itemRetailPriceShowError.add(false);
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  StreamBuilder(
                                    stream: widget.itemBloc.itemRetailPriceShowError,
                                    builder: (context, snapshot) {
                                      return Visibility(
                                        visible: widget.itemBloc.itemRetailPriceShowError.value,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Please enter retail price'.i18n,
                                            style: AppTextStyle().errorStyle,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Focus(
                          onFocusChange: (val) {
                            widget.itemBloc.itemMarkupTap.add(val);
                          },
                          child: StreamBuilder(
                            stream: widget.itemBloc.itemMarkupTap,
                            builder: (context, snapshot) {
                              return Column(
                                children: [
                                  AppTextField(
                                    textEditingController: widget.itemBloc.itemMarkUpController,
                                    label: "Markup".i18n,
                                    isFocused: widget.itemBloc.itemMarkupTap.value,
                                    suffixIcon: const Icon(
                                      Icons.percent,
                                      color: AppColors.colorDarkPrimary,
                                    ),
                                    showError: widget.itemBloc.itemMarkupShowError.value,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(AppUtil.allowDecimal()),
                                    ],
                                    onChangeFunction: (value) {
                                      if (value?.isNotEmpty ?? false) {
                                        if (double.parse(value!) != 0) {
                                          widget.itemBloc.retailMarginCalculation();
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  StreamBuilder(
                                    stream: widget.itemBloc.itemMarkupShowError,
                                    builder: (context, snapshot) {
                                      return Visibility(
                                        visible: widget.itemBloc.itemMarkupShowError.value,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "The value should be equal or less than 999.99".i18n,
                                            style: const TextStyle(
                                              color: AppColors.colorError,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Focus(
                          onFocusChange: (val) {
                            widget.itemBloc.itemMarginTap.add(val);
                          },
                          child: StreamBuilder(
                            stream: widget.itemBloc.itemMarginTap,
                            builder: (context, snapshot) {
                              return Column(
                                children: [
                                  AppTextField(
                                    textEditingController: widget.itemBloc.itemMarginController,
                                    label: "Margin".i18n,
                                    suffixIcon: const Icon(
                                      Icons.percent,
                                      color: AppColors.colorDarkPrimary,
                                    ),
                                    isFocused: widget.itemBloc.itemMarginTap.value,
                                    showError: widget.itemBloc.itemMarginShowError.value,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    onChangeFunction: (value) {
                                      if (value?.isNotEmpty ?? false) {
                                        if (double.parse(value!) != 0) {
                                          widget.itemBloc.retailMarkupCalculation();
                                        }
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(AppUtil.allowDecimal()),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  StreamBuilder(
                                    stream: widget.itemBloc.itemMarginShowError,
                                    builder: (context, snapshot) {
                                      return Visibility(
                                        visible: widget.itemBloc.itemMarginShowError.value,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "The value should be equal or less than 999.99".i18n,
                                            style: const TextStyle(
                                              color: AppColors.colorError,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        StreamBuilder(
                          stream: widget.itemBloc.coldPriceTap.stream,
                          builder: (context, snapshot) {
                            return Focus(
                              onFocusChange: (val) {
                                widget.itemBloc.coldPriceTap.add(val);
                                if (!val &&
                                    widget.itemBloc.itemColdPriceController.text.isNotEmpty) {
                                  double retailPrice = double.parse(
                                    widget.itemBloc.itemRetailPriceController.text.isEmpty
                                        ? "0.0"
                                        : double.parse(
                                      widget.itemBloc.itemRetailPriceController.text,
                                    ).toStringAsFixed(2),
                                  );
                                  double coldPrice = double.parse(
                                    double.parse(widget.itemBloc.itemColdPriceController.text)
                                        .toStringAsFixed(2),
                                  );
                                  if (retailPrice >= coldPrice) {
                                    if (coldPrice > 0) {
                                      AppUtil.showSnackBar(
                                        label:
                                        ("The 'Cold Price' can not be less than the 'Retail Price'"
                                            .i18n),
                                      );
                                    }
                                  }
                                }
                              },
                              child: AppTextField(
                                isFocused: widget.itemBloc.coldPriceTap.value,
                                label: "Cold Price".i18n,
                                textEditingController: widget.itemBloc.itemColdPriceController,
                                showError: false,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(AppUtil.allowDecimal()),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        StreamBuilder(
                          stream: widget.itemBloc.warmPriceTap.stream,
                          builder: (context, snapshot) {
                            return Focus(
                              onFocusChange: (val) {
                                widget.itemBloc.warmPriceTap.add(val);
                                if (!val &&
                                    widget.itemBloc.itemWarmPriceController.text.isNotEmpty) {
                                  double retailPrice = double.parse(
                                    widget.itemBloc.itemRetailPriceController.text.isEmpty
                                        ? "0.0"
                                        : double.parse(
                                      widget.itemBloc.itemRetailPriceController.text,
                                    ).toStringAsFixed(2),
                                  );
                                  double warmPrice = double.parse(
                                    double.parse(widget.itemBloc.itemWarmPriceController.text)
                                        .toStringAsFixed(2),
                                  );
                                  if (retailPrice >= warmPrice) {
                                    if (warmPrice > 0) {
                                      widget.itemBloc.itemWarmPriceController.text = "0";
                                      AppUtil.showSnackBar(
                                        label:
                                        "The 'Warm Price' can not be less than the 'Retail Price'"
                                            .i18n,
                                      );
                                    }
                                  }
                                }
                              },
                              child: AppTextField(
                                isFocused: widget.itemBloc.warmPriceTap.value,
                                label: "Warm Price".i18n,
                                textEditingController: widget.itemBloc.itemWarmPriceController,
                                showError: false,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(AppUtil.allowDecimal()),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      TabNavigatorRouter(
                        navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                        currentPageKey: AppRouteManager.currentPage,
                      ).pushNamed(
                        AppRouteConstants.itemPackUpcScreen,
                        arguments: {"itemBloc": widget.itemBloc},
                      )?.then((value) async {
                        RootBloc().changeBottomBarBehaviour(
                          onTap: bottomButtonBehaviour,
                          bottomBarIconPath: icCheck,
                        );
                        widget.itemBloc.rebuildPackagePage2.add(true);
                      });
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
                              padding: AppPaddingConstants().left25,
                              child: Text(
                                "Pack UPC".i18n,
                                style: AppTextStyle().darkTextStyle,
                              ),
                            ),
                            const Spacer(),
                            getUpcText(),
                            const Padding(
                              padding: EdgeInsets.only(left: 7, right: 10.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: AppColors.colorLightGrey100,
                              ),
                            ),
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
      ),
    );
  }

  getUpcText() {
    return widget.itemBloc.itemPackUpcList.isNotEmpty
        ? Text(
            "${widget.itemBloc.itemPackUpcList.length} Generated",
            style: const TextStyle(color: AppColors.colorDarkPrimary),
          )
        : const SizedBox.shrink();
  }
}
