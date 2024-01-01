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
import 'package:ptecpos_mobile/core/widget/app_bottom_sheet.dart';
import 'package:ptecpos_mobile/core/widget/app_button.dart';
import 'package:ptecpos_mobile/core/widget/app_checkbox.dart';
import 'package:ptecpos_mobile/core/widget/app_circle_radio_field.dart';
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/core/widget/arrow_card.dart';
import 'package:ptecpos_mobile/core/widget/default_loading_widget.dart';
import 'package:ptecpos_mobile/core/widget/error_screen_widget.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/bloc/item_bloc.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/department/model/req_item_dept_model.dart';
import 'package:rxdart/rxdart.dart';

class AddItemDepartmentScreen extends StatefulWidget {
  final ItemBloc itemBloc;

  const AddItemDepartmentScreen({
    super.key,
    required this.itemBloc,
  });

  @override
  State<AddItemDepartmentScreen> createState() => _AddItemDepartmentScreenState();
}

class _AddItemDepartmentScreenState extends State<AddItemDepartmentScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.itemBloc.taxSlabs.clear();
    RootBloc().changeBottomBarBehaviour(onTap: buttonTapBehaviour, bottomBarIconPath: icCheck);
    widget.itemBloc.getItemDepartment();
  }

  void buttonTapBehaviour() {
    if (widget.itemBloc.departmentValue.valueOrNull != null) {
      TabNavigatorRouter(
        navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
        currentPageKey: AppRouteManager.currentPage,
      ).pop();
    } else {
      AppUtil.showSnackBar(label: "Please select a department".i18n);
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
              "Select Department".i18n,
              style: AppTextStyle().darkTextStyle,
            ),
          ],
        ),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: widget.itemBloc.itemDepartmentState,
        builder: (context, snapshot) {
          if (widget.itemBloc.itemDepartmentState.value.isLoading()) {
            return const DefaultLoadingWidget();
          } else if (widget.itemBloc.itemDepartmentState.value.isLoading()) {
            return const ErrorWidgetScreen();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: AppPaddingConstants().leftRight25,
              child: Column(
                children: [
                  const SizedBox(
                    height: 33,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await addDepartmentBottomSheet();
                    },
                    child: Neumorphic(
                      padding: AppPaddingConstants().itineraryPadding,
                      style: NeumorphicStyle(
                        surfaceIntensity: 0.15,
                        color: AppColors.colorWhite,
                        depth: 8,
                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add),
                          const SizedBox(
                            width: 13,
                          ),
                          Text(
                            "Add Department".i18n,
                            style: AppTextStyle().darkTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 33,
                  ),
                  StreamBuilder(
                    stream: widget.itemBloc.departmentValue,
                    builder: (context, snapshot) {
                      return ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: widget.itemBloc.resItemDepartmentModel.data!.list!.map((e) {
                          return Padding(
                            padding: AppPaddingConstants().bottom25,
                            child: AppCircleRadioOption(
                              value: e,
                              groupValue: widget.itemBloc.departmentValue.valueOrNull,
                              text: e.name!,
                              onChanged: (val) {
                                widget.itemBloc.departmentValue.add(val);
                              },
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> addDepartmentBottomSheet({
    String? name,
    String? surChargeText,
    String? mValueText,
    bool foodStampValue = false,
    bool marginValueCheck = true,
    bool ageCheckValue = false,
    bool accessCheckValue = false,
  }) async {
    TextEditingController nameController = TextEditingController();
    nameController.text = name ?? "";

    TextEditingController surChargeController = TextEditingController();
    surChargeController.text = surChargeText ?? "";

    TextEditingController mValueController = TextEditingController();
    mValueController.text = mValueText ?? "";

    BehaviorSubject<bool> nameTap = BehaviorSubject<bool>.seeded(false);
    BehaviorSubject<bool> nameError = BehaviorSubject<bool>.seeded(false);

    BehaviorSubject<bool> surChargeTap = BehaviorSubject<bool>.seeded(false);
    BehaviorSubject<bool> surChargeError = BehaviorSubject<bool>.seeded(false);
    String surChargeErrorMessage = "The value should be equal or less than 999.99".i18n;

    BehaviorSubject<bool> foodStamp = BehaviorSubject<bool>.seeded(foodStampValue);

    BehaviorSubject<bool> marginValue = BehaviorSubject<bool>.seeded(marginValueCheck);

    BehaviorSubject<bool> mValueTap = BehaviorSubject<bool>.seeded(false);
    BehaviorSubject<bool> mValueError = BehaviorSubject<bool>.seeded(false);

    BehaviorSubject<bool> ageCheck = BehaviorSubject<bool>.seeded(ageCheckValue);
    BehaviorSubject<bool> accessCheck = BehaviorSubject<bool>.seeded(accessCheckValue);

    // final formKey = GlobalKey<FormState>();

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
              "Add Department".i18n,
              style: AppTextStyle().darkTextStyle,
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
                                "Please enter department name".i18n,
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
                Navigator.pop(AppRouteManager.navigatorKey.currentContext!);
                TabNavigatorRouter(
                  navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                  currentPageKey: AppRouteManager.currentPage,
                ).pushNamed(
                  AppRouteConstants.addTax,
                  arguments: {"itemBloc": widget.itemBloc},
                )?.then((value) async {
                  RootBloc().changeBottomBarBehaviour(
                    onTap: buttonTapBehaviour,
                    bottomBarIconPath: null,
                  );
                  await addDepartmentBottomSheet(
                    name: nameController.text,
                    surChargeText: surChargeController.text,
                    foodStampValue: foodStamp.value,
                    marginValueCheck: marginValue.value,
                    accessCheckValue: accessCheck.value,
                    ageCheckValue: ageCheck.value,
                    mValueText: mValueController.text,
                  );
                });
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Focus(
              onFocusChange: (val) {
                surChargeTap.add(val);
              },
              child: StreamBuilder(
                stream: surChargeTap,
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      AppTextField(
                        textEditingController: surChargeController,
                        label: "Surcharge".i18n,
                        isFocused: surChargeTap.value,
                        showError: surChargeError.value,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validatorFunction: (val) {
                          if (val?.isNotEmpty ?? false) {
                            if (RegExp(r'^(999(\.0{1,2})?|\d{0,2}(\.\d{1,2})?)$').hasMatch(val!)) {
                              surChargeTap.add(nameTap.value);
                              surChargeError.add(false);
                            } else {
                              surChargeTap.add(nameTap.value);
                              surChargeError.add(true);
                            }
                          } else {
                            surChargeTap.add(nameTap.value);
                            surChargeError.add(false);
                          }
                          return null;
                        },
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(
                        //       RegExp(r'^(999(\.0{1,2})?|\d{0,2}(\.\d{1,2})?)$'))
                        // ],
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      StreamBuilder(
                        stream: surChargeError,
                        builder: (context, snapshot) {
                          return Visibility(
                            visible: surChargeError.value,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                surChargeErrorMessage,
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
              height: 16,
            ),
            StreamBuilder(
              stream: foodStamp,
              builder: (context, snapshot) {
                return AppCheckBox(
                  value: foodStamp.value,
                  onChanged: (value) {
                    foodStamp.add(value);
                  },
                  label: "Allow Food Stamp".i18n,
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            StreamBuilder(
              stream: marginValue,
              builder: (context, snapshot) {
                return Row(
                  children: [
                    AppCircleRadioOption(
                      groupValue: marginValue.value,
                      value: true,
                      text: "Margin".i18n,
                      onChanged: (val) {
                        marginValue.add(val);
                      },
                    ),
                    const SizedBox(
                      width: 27,
                    ),
                    AppCircleRadioOption(
                      groupValue: marginValue.value,
                      value: false,
                      text: "Markup".i18n,
                      onChanged: (val) {
                        marginValue.add(val);
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Focus(
              onFocusChange: (val) {
                mValueTap.add(val);
              },
              child: StreamBuilder(
                stream: mValueTap,
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      AppTextField(
                        textEditingController: mValueController,
                        label: "0.00",
                        isFocused: mValueTap.value,
                        showError: mValueError.value,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validatorFunction: (val) {
                          if (val?.isNotEmpty ?? false) {
                            if (RegExp(r'^(999(\.0{1,2})?|\d{0,2}(\.\d{1,2})?)$').hasMatch(val!)) {
                              mValueTap.add(nameTap.value);
                              mValueError.add(false);
                            } else {
                              mValueTap.add(nameTap.value);
                              mValueError.add(true);
                            }
                          } else {
                            mValueTap.add(nameTap.value);
                            mValueError.add(false);
                          }
                          return null;
                        },
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(
                        //       RegExp(r'^-?\d{1,3}(\.\d{1,2})?$')),
                        // ],
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      StreamBuilder(
                        stream: mValueError,
                        builder: (context, snapshot) {
                          return Visibility(
                            visible: mValueError.value,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                surChargeErrorMessage,
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
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    StreamBuilder(
                      stream: ageCheck,
                      builder: (context, snapshot) {
                        return NeumorphicSwitch(
                          value: ageCheck.value,
                          height: 20,
                          style: const NeumorphicSwitchStyle(
                            inactiveThumbColor: AppColors.colorShadowPrimary,
                            inactiveTrackColor: AppColors.colorWhite,
                            activeThumbColor: AppColors.colorPrimary,
                            activeTrackColor: AppColors.colorWhite,
                          ),
                          onChanged: (val) {
                            ageCheck.add(val);
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Text("Age Check".i18n),
                  ],
                ),
                Row(
                  children: [
                    StreamBuilder(
                      stream: accessCheck,
                      builder: (context, snapshot) {
                        return NeumorphicSwitch(
                          value: accessCheck.value,
                          height: 20,
                          style: const NeumorphicSwitchStyle(
                            inactiveThumbColor: AppColors.colorShadowPrimary,
                            inactiveTrackColor: AppColors.colorWhite,
                            activeThumbColor: AppColors.colorPrimary,
                            activeTrackColor: AppColors.colorWhite,
                          ),
                          onChanged: (val) {
                            accessCheck.add(val);
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Text("Access".i18n),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 27,
            ),
            AppButton(
              label: "ADD".i18n,
              onPressed: () {
                _formKey.currentState!.validate();
                if ((!nameError.value && nameController.text.isNotEmpty)) {
                  ReqItemDeptModel reqItemDeptModel = ReqItemDeptModel(
                    name: nameController.text,
                    storeId: RootBloc.store?.id,
                    ageCheck: ageCheck.value,
                    id: "",
                    mValue: mValueController.text.isEmpty ? "0" : mValueController.text,
                    allowFoodStamp: foodStamp.value,
                    taxSlabIdList: widget.itemBloc.taxSlabs.isNotEmpty
                        ? widget.itemBloc.taxSlabs
                            .where((element) => element.value.isSelected)
                            .map((e) => e.value.taxSlab.id!)
                            .toList()
                        : [],
                    surcharge: surChargeController.text.isNotEmpty
                        ? double.tryParse(surChargeController.text)
                        : 0,
                    marginMarkup: marginValue.value ? 1 : 2,
                    favorite: true,
                  );
                  Navigator.pop(AppRouteManager.navigatorKey.currentContext!);

                  widget.itemBloc.postDepartment(reqItemDeptModel);
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

  Widget getSelectedTax() {
    int selectedTax = 0;
    for (var element in widget.itemBloc.taxSlabs) {
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
}
