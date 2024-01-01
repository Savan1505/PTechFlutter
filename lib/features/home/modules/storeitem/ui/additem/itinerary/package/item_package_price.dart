import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/routes/tab_navigator.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_enum.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/utils/flavors.dart';
import 'package:ptecpos_mobile/core/utils/image_path.dart';
import 'package:ptecpos_mobile/core/widget/app_bottom_sheet.dart';
import 'package:ptecpos_mobile/core/widget/app_button.dart';
import 'package:ptecpos_mobile/core/widget/app_dropdown.dart';
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/core/widget/simple_card.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/bloc/item_bloc.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/req_item_model.dart';
import 'package:rxdart/rxdart.dart';

class ItemPackagePrice extends StatefulWidget {
  final ItemBloc itemBloc;

  const ItemPackagePrice({
    super.key,
    required this.itemBloc,
  });

  @override
  State<ItemPackagePrice> createState() => _ItemPackagePriceState();
}

class _ItemPackagePriceState extends State<ItemPackagePrice> {
  final _formKey = GlobalKey<FormState>();
  BehaviorSubject<bool> buildList = BehaviorSubject<bool>.seeded(false);

  @override
  void initState() {
    super.initState();
    RootBloc().changeBottomBarBehaviour(onTap: buttonTapBehaviour, bottomBarIconPath: icCheck);
  }

  void buttonTapBehaviour() {
    if (widget.itemBloc.itemStoreItemPriceList.isNotEmpty) {
      TabNavigatorRouter(
        navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
        currentPageKey: AppRouteManager.currentPage,
      ).pop();
    } else {
      AppUtil.showSnackBar(label: "Please create a price".i18n);
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
          onPressed: () {
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
              "Add Price".i18n,
              style: AppTextStyle().appBarTextStyle,
            ),
          ],
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPaddingConstants().leftRight25,
          child: Column(
            children: [
              const SizedBox(
                height: 33,
              ),
              GestureDetector(
                onTap: () async {
                  await showAddPriceBottomSheet();
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
                          style: const TextStyle(
                            color: AppColors.colorBlack,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 33,
              ),
              StreamBuilder(
                stream: buildList,
                builder: (context, snapshot) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.itemBloc.itemStoreItemPriceList.length,
                    itemBuilder: (ctx, index) {
                      var t = widget.itemBloc.itemStoreItemPriceList[index];
                      return SimpleCard(
                        name: t.packageName!,
                        trailing: GestureDetector(
                          onTap: () {
                            widget.itemBloc.itemStoreItemPriceList.removeAt(index);
                            buildList.add(true);
                          },
                          child: Padding(
                            padding: AppPaddingConstants().right8,
                            child: SvgPicture.asset(
                              icTrashIcon,
                              // ignore: deprecated_member_use
                              color: AppColors.redColor,
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
      ),
    );
  }

  Future<void> showAddPriceBottomSheet() async {
    BehaviorSubject<PrimaryPackageListModel?> packageName = BehaviorSubject<PrimaryPackageListModel?>();
    BehaviorSubject<bool> packageNameError = BehaviorSubject<bool>.seeded(false);

    BehaviorSubject<bool> qtyTap = BehaviorSubject<bool>.seeded(false);
    BehaviorSubject<bool> qtyError = BehaviorSubject<bool>.seeded(false);

    BehaviorSubject<bool> priceTap = BehaviorSubject<bool>.seeded(false);
    BehaviorSubject<bool> priceError = BehaviorSubject<bool>.seeded(false);

    TextEditingController qtyController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController priceAmtController = TextEditingController();

    String errMessage = "";
    BehaviorSubject<bool> showErrMessage = BehaviorSubject<bool>.seeded(false);

    await AppBottomSheet(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              "Add Price".i18n,
              style: AppTextStyle().darkTextStyle,
            ),
            const SizedBox(
              height: 25,
            ),
            Column(
              children: [
                StreamBuilder(
                  stream: packageName,
                  builder: (context, snapshot) {
                    return AppDropdown(
                      hintText: "Package".i18n,
                      value: packageName.valueOrNull,
                      items: widget.itemBloc.itemPrimaryPackageList.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e.packageName!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        packageName.add(value);
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 3,
                ),
                StreamBuilder(
                  stream: packageNameError,
                  builder: (context, snapshot) {
                    return Visibility(
                      visible: packageNameError.value,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Select the package'.i18n,
                          style: AppTextStyle().errorStyle,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Focus(
              onFocusChange: (val) {
                qtyTap.add(val);
              },
              child: StreamBuilder(
                stream: qtyTap,
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      AppTextField(
                        textEditingController: qtyController,
                        label: "Qty".i18n,
                        isFocused: qtyTap.value,
                        showError: qtyError.value,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChangeFunction: (value) {
                          if (value?.isNotEmpty ?? false) {
                            double qty = double.parse(
                              qtyController.text.isEmpty ? "0.0" : qtyController.text,
                            );
                            double price = double.parse(
                              priceController.text.isEmpty ? "0.0" : priceController.text,
                            );
                            priceAmtController.text = (qty * price).toString();
                            priceTap.add(priceTap.value);
                          }
                          return null;
                        },
                        validatorFunction: (value) {
                          if (value == null || value.isEmpty) {
                            qtyTap.add(qtyTap.value);
                            qtyError.add(true);
                          } else {
                            qtyTap.add(qtyTap.value);
                            qtyError.add(false);
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      StreamBuilder(
                        stream: qtyError,
                        builder: (context, snapshot) {
                          return Visibility(
                            visible: qtyError.value,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Qty is required".i18n,
                                style: AppTextStyle().errorStyle,
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
              height: 16,
            ),
            Focus(
              onFocusChange: (val) {
                priceTap.add(val);
              },
              child: StreamBuilder(
                stream: priceTap,
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      AppTextField(
                        textEditingController: priceController,
                        label: "Price per unit".i18n,
                        isFocused: priceTap.value,
                        showError: priceError.value,
                        suffixIcon: const Icon(Icons.currency_rupee),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(AppUtil.allowDecimal())],
                        onChangeFunction: (value) {
                          if (value?.isNotEmpty ?? false) {
                            double qty = double.parse(
                              qtyController.text.isEmpty ? "0.0" : qtyController.text,
                            );
                            double price = double.parse(
                              priceController.text.isEmpty ? "0.0" : priceController.text,
                            );
                            priceAmtController.text = (qty * price).toString();
                            priceTap.add(priceTap.value);
                          }
                          return null;
                        },
                        validatorFunction: (value) {
                          if (value == null || value.isEmpty) {
                            priceTap.add(priceTap.value);
                            priceError.add(true);
                          } else {
                            priceError.add(false);
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      StreamBuilder(
                        stream: priceError,
                        builder: (context, snapshot) {
                          return Visibility(
                            visible: qtyError.value,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Price per unit is required".i18n,
                                style: AppTextStyle().errorStyle,
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
              height: 16,
            ),
            StreamBuilder(
              stream: showErrMessage,
              builder: (context, snapshot) {
                return Visibility(
                  visible: showErrMessage.value,
                  child: Column(
                    children: [
                      Text(
                        errMessage,
                        style: const TextStyle(
                          color: AppColors.redColor,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                );
              },
            ),
            AppTextField(
              textEditingController: priceAmtController,
              label: "Price",
              isFocused: false,
              showError: false,
              suffixIcon: const Icon(Icons.currency_rupee),
              enabled: false,
            ),
            const SizedBox(
              height: 16,
            ),
            AppButton(
              label: "Save".i18n,
              onPressed: () {
                _formKey.currentState!.validate();
                if ((!qtyError.value && qtyController.text.isNotEmpty) &&
                    (!priceError.value && priceController.text.isNotEmpty)) {
                  if (packageName.valueOrNull == null) {
                    packageNameError.add(true);
                  } else {
                    packageNameError.add(false);
                    double unitCost = double.parse(
                          packageName.value!.unitCost!.isEmpty ? "0.0" : packageName.value!.unitCost!,
                        ) -
                        (packageName.value?.downBy ?? 0.0);
                    if (unitCost >
                        double.parse(
                          priceController.text.isEmpty ? "0.0" : priceController.text,
                        )) {
                      errMessage = "'Price Per Unit' Cannot be less than 'Unit Cost (-) Down By'".i18n;
                      showErrMessage.add(true);
                    } else if (double.parse(
                          packageName.value!.retailPrice!.isEmpty
                              ? "0.0"
                              : packageName.value!.retailPrice!,
                        ) <
                        double.parse(
                          priceController.text.isEmpty ? "0.0" : priceController.text,
                        )) {
                      errMessage = "'Price Per Unit' Cannot be greater than 'Retail Price'".i18n;
                      showErrMessage.add(true);
                    } else {
                      ///Valid form
                      showErrMessage.add(false);
                      StoreItemPriceByQuantityListModel model = StoreItemPriceByQuantityListModel(
                        packageName: packageName.value?.packageName,
                        actionFlag: ActionFlagEnum.insert,
                        id: Flavors.getGuid(),
                        packReferenceId: Flavors.getGuid(),
                        packReferenceType: 1,
                        tempPackId: packageName.value!.tempPackId!,
                        packCheck: true,
                        price: priceAmtController.text,
                        pricePerUnit: priceController.text,
                        qty: int.parse(qtyController.text),
                      );

                      widget.itemBloc.itemStoreItemPriceList.add(model);
                      Navigator.pop(AppRouteManager.navigatorKey.currentContext!);
                    }
                  }
                } else {
                  if (packageName.valueOrNull == null) {
                    packageNameError.add(true);
                  } else {
                    packageNameError.add(false);
                  }
                }
              },
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    ).showBottomSheet();
  }
}
