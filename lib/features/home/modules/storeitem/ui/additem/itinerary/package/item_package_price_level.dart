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
import 'package:ptecpos_mobile/core/widget/app_radio_field.dart';
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/core/widget/simple_card.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/bloc/item_bloc.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/req_item_model.dart';
import 'package:rxdart/rxdart.dart';

class ItemPackagePriceLevel extends StatefulWidget {
  final ItemBloc itemBloc;

  const ItemPackagePriceLevel({super.key, required this.itemBloc});

  @override
  State<ItemPackagePriceLevel> createState() => _ItemPackagePriceLevelState();
}

class _ItemPackagePriceLevelState extends State<ItemPackagePriceLevel> {
  final _formKey = GlobalKey<FormState>();
  BehaviorSubject<bool> buildList = BehaviorSubject<bool>.seeded(false);

  @override
  void initState() {
    super.initState();
    RootBloc().changeBottomBarBehaviour(onTap: buttonTapBehaviour, bottomBarIconPath: icCheck);
  }

  void buttonTapBehaviour() {
    if (widget.itemBloc.itemStoreItemPriceLevelList.isNotEmpty) {
      TabNavigatorRouter(
        navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
        currentPageKey: AppRouteManager.currentPage,
      ).pop();
    } else {
      AppUtil.showSnackBar(label: "Please create a price level".i18n);
    }
  }

  @override
  void dispose() {
    buildList.close();
    super.dispose();
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
              "Add Price Level".i18n,
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
                  await showAddPriceLevelBottomSheet();
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
                    itemCount: widget.itemBloc.itemStoreItemPriceLevelList.length,
                    itemBuilder: (ctx, index) {
                      var t = widget.itemBloc.itemStoreItemPriceLevelList[index];
                      return SimpleCard(
                        name: t.name!,
                        trailing: GestureDetector(
                          onTap: () {
                            widget.itemBloc.itemStoreItemPriceLevelList.removeAt(index);
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

  Future<void> showAddPriceLevelBottomSheet() async {
    BehaviorSubject<PrimaryPackageListModel?> packageName = BehaviorSubject<PrimaryPackageListModel?>();
    BehaviorSubject<bool> packageNameError = BehaviorSubject<bool>.seeded(false);

    BehaviorSubject<bool> nameTap = BehaviorSubject<bool>.seeded(false);
    BehaviorSubject<bool> nameError = BehaviorSubject<bool>.seeded(false);

    BehaviorSubject<bool> amtTap = BehaviorSubject<bool>.seeded(false);
    BehaviorSubject<bool> amtError = BehaviorSubject<bool>.seeded(false);

    TextEditingController nameController = TextEditingController();
    TextEditingController amtController = TextEditingController();
    List<String> rateType = ["Percentage".i18n, "Amount".i18n];
    BehaviorSubject<String> rateTypeValue = BehaviorSubject<String>.seeded("Percentage".i18n);

    List<String> addDeduct = ["Add".i18n, "Deduct".i18n];
    BehaviorSubject<String> addDeductValue = BehaviorSubject<String>.seeded("Add".i18n);

    String perErrorMessage = "Percentage is required".i18n;
    String amtErrorMessage = "Amount is required".i18n;

    AppBottomSheet(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              "Add Price Level".i18n,
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
                nameTap.add(val);
              },
              child: StreamBuilder(
                stream: nameTap,
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      AppTextField(
                        textEditingController: nameController,
                        label: "Name".i18n,
                        isFocused: nameTap.value,
                        showError: nameError.value,
                        validatorFunction: (value) {
                          if (value == null || value.isEmpty) {
                            nameTap.add(nameTap.value);
                            nameError.add(true);
                          } else {
                            nameTap.add(nameTap.value);
                            nameError.add(false);
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      StreamBuilder(
                        stream: nameError,
                        builder: (context, snapshot) {
                          return Visibility(
                            visible: nameError.value,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Name is required".i18n,
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
              stream: rateTypeValue,
              builder: (context, snapshot) {
                return Row(
                  children: rateType.map((e) {
                    return Padding(
                      padding: AppPaddingConstants().right8,
                      child: AppRadioOption(
                        groupValue: rateTypeValue.value,
                        value: e,
                        text: e,
                        onChanged: (val) {
                          rateTypeValue.add(val);
                          amtController.clear();
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Focus(
              onFocusChange: (val) {
                amtTap.add(val);
              },
              child: StreamBuilder(
                stream: amtTap,
                builder: (context, snapshot) {
                  return StreamBuilder(
                    stream: rateTypeValue,
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          AppTextField(
                            textEditingController: amtController,
                            label: rateTypeValue.value.compareTo("Percentage".i18n) == 0
                                ? "By Percentage".i18n
                                : "By Amount".i18n,
                            isFocused: amtTap.value,
                            showError: amtError.value,
                            suffixIcon: rateTypeValue.value.compareTo("Percentage".i18n) == 0
                                ? const Icon(Icons.percent)
                                : const Icon(Icons.currency_rupee),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(AppUtil.allowDecimal())],
                            validatorFunction: (value) {
                              if (value == null || value.isEmpty) {
                                amtTap.add(amtTap.value);
                                amtError.add(true);
                              } else {
                                if (rateTypeValue.value.compareTo("Percentage".i18n) == 0) {
                                  if (double.parse(amtController.text) > 100) {
                                    perErrorMessage = "Percentage cannot be greater than 100".i18n;
                                    amtTap.add(amtTap.value);
                                    amtError.add(true);
                                  } else {
                                    perErrorMessage = "Percentage is required".i18n;
                                    amtTap.add(amtTap.value);
                                    amtError.add(false);
                                  }
                                } else {
                                  if (amtController.text.length > 10) {
                                    amtErrorMessage = "Amount cannot be greater than zero".i18n;
                                    amtTap.add(amtTap.value);
                                    amtError.add(true);
                                  } else {
                                    amtErrorMessage = "Amount is required".i18n;
                                  }
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          StreamBuilder(
                            stream: amtError,
                            builder: (context, snapshot) {
                              return Visibility(
                                visible: amtError.value,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    rateTypeValue.value.compareTo("Percentage".i18n) == 0
                                        ? perErrorMessage
                                        : amtErrorMessage,
                                    style: AppTextStyle().errorStyle,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            StreamBuilder(
              stream: addDeductValue,
              builder: (context, snapshot) {
                return Row(
                  children: addDeduct.map((e) {
                    return Padding(
                      padding: AppPaddingConstants().right8,
                      child: AppRadioOption(
                        groupValue: addDeductValue.value,
                        value: e,
                        text: e,
                        onChanged: (val) {
                          addDeductValue.add(val);
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            AppButton(
              label: "Save".i18n,
              onPressed: () {
                _formKey.currentState!.validate();
                if ((!nameError.value && nameController.text.isNotEmpty) &&
                    (!amtError.value && amtController.text.isNotEmpty)) {
                  if (packageName.valueOrNull == null) {
                    packageNameError.add(true);
                  } else {
                    ///Valid form
                    packageNameError.add(false);
                    StoreItemPriceLevelListModel priceLevel = StoreItemPriceLevelListModel(
                      tempPackId: "",
                      packReferenceType: 1,
                      packReferenceId: Flavors.getGuid(),
                      id: Flavors.getGuid(),
                      actionFlag: ActionFlagEnum.insert,
                      name: nameController.text,
                      rate: double.parse(amtController.text),
                      rateAdd: addDeductValue.value.compareTo("Add".i18n) == 0,
                      rateType: rateTypeValue.value.compareTo("Percentage".i18n) == 0 ? "1" : "2",
                      packageName: packageName.value!.packageName!,
                      packCheck: true,
                      type: rateTypeValue.value.compareTo("Percentage".i18n) == 0 ? 1 : 2,
                    );
                    widget.itemBloc.itemStoreItemPriceLevelList.add(priceLevel);
                    Navigator.pop(AppRouteManager.navigatorKey.currentContext!);
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
