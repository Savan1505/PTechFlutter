// ignore_for_file: deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptecpos_mobile/core/base/base_bloc.dart';
import 'package:ptecpos_mobile/core/base/base_state.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/routes/tab_navigator.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/utils/image_path.dart';
import 'package:ptecpos_mobile/core/widget/app_dropdown.dart';
import 'package:ptecpos_mobile/core/widget/app_radio_field.dart';
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/core/widget/default_loading_widget.dart';
import 'package:ptecpos_mobile/core/widget/error_screen_widget.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_storeitem_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/bloc/add_tpr_bloc.dart';

class AddTprScreen extends StatefulWidget {
  final String? id;

  const AddTprScreen({super.key, this.id});

  @override
  State<AddTprScreen> createState() => _AddTprScreenState();
}

class _AddTprScreenState extends BaseState<AddTprScreen> {
  final AddTprBloc addTprBloc = AddTprBloc();

  @override
  void initState() {
    super.initState();
    RootBloc().changeBottomBarBehaviour(onTap: bottomBarTap, bottomBarIconPath: icCheck);
    addTprBloc.initData(id: widget.id);
  }

  void bottomBarTap() {
    addTprBloc.formKey.currentState!.validate();
    if (addTprBloc.checkValidation()) {
      addTprBloc.addTrigger();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
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
        centerTitle: true,
        title: Text(
          "Add Temporary Price Reduction".i18n,
          style: AppTextStyle().appBarTextStyle,
        ),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: addTprBloc.tprState,
        builder: (context, snapshot) {
          if (addTprBloc.tprState.value.isLoading()) {
            return const DefaultLoadingWidget();
          }
          if (addTprBloc.tprState.value.isError()) {
            return const ErrorWidgetScreen();
          }

          return SingleChildScrollView(
            child: Form(
              key: addTprBloc.formKey,
              child: Padding(
                padding: AppPaddingConstants().leftRight25,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    StreamBuilder(
                      stream: addTprBloc.storeItemValue,
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            StreamBuilder(
                              stream: addTprBloc.storeItemValueError,
                              builder: (context, snapshot) {
                                return AppDropdown(
                                  hintText: "Store Item".i18n,
                                  value: addTprBloc.storeItemValue.valueOrNull,
                                  borderColor: addTprBloc.storeItemValueError.value
                                      ? AppColors.redColor
                                      : AppColors.colorTransparent,
                                  items: addTprBloc.resStoreItemModel.data!.list!.map((e) {
                                    return DropdownMenuItem(
                                      value: e,
                                      child: Text(e.name!),
                                    );
                                  }).toList(),
                                  onChanged: (StoreItemElement? value) {
                                    addTprBloc.resetValue();
                                    addTprBloc.storeItemValueError.add(false);
                                    addTprBloc.trpTriggers.add(null);
                                    addTprBloc.storeItemValue.add(value!);

                                    addTprBloc.getPackageDetails(value.id!);
                                  },
                                );
                              },
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            StreamBuilder(
                              stream: addTprBloc.storeItemValueError,
                              builder: (context, snapshot) {
                                return Visibility(
                                  visible: addTprBloc.storeItemValueError.value,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Select the store item'.i18n,
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
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder(
                      stream: addTprBloc.trpTriggers,
                      builder: (context, snapshot) {
                        return StreamBuilder(
                          stream: addTprBloc.packageItemValueError,
                          builder: (context, snapshot) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTextField(
                                  isFocused: false,
                                  label: "Package".i18n,
                                  onTap: () {
                                    if (addTprBloc.storeItemValue.valueOrNull != null) {
                                      addTprBloc.storeItemValueError.add(false);
                                      showPackagesDialog();
                                    } else {
                                      addTprBloc.storeItemValueError.add(true);
                                    }
                                  },
                                  readOnly: true,
                                  textEditingController: addTprBloc.packageName,
                                  showError: addTprBloc.packageItemValueError.value,
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Visibility(
                                  visible: addTprBloc.packageItemValueError.value,
                                  child: Text(
                                    "Package is required".i18n,
                                    style: AppTextStyle().errorStyle,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: addTprBloc.trpTriggers,
                      builder: (context, snapshot) {
                        if (addTprBloc.trpTriggers.valueOrNull != null) {
                          return Text(
                            "Unit Cost: ${addTprBloc.trpTriggers.value!.unitCost.toString()} | Retail Price: ${addTprBloc.trpTriggers.value!.retailPrice.toString()}",
                            style: AppTextStyle().lightTextStyle,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder(
                      stream: addTprBloc.trpTriggersPackage,
                      builder: (context, snapshot) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StreamBuilder(
                              stream: addTprBloc.startDateError,
                              builder: (context, snapshot) {
                                return AppTextField(
                                  isFocused: false,
                                  label: "Start Date".i18n,
                                  readOnly: true,
                                  suffixIcon: GestureDetector(
                                    onTap: () async {
                                      DateTime? dateTime = await showDatePicker(
                                        context: context,
                                        initialDate: addTprBloc.trpTriggersPackage.valueOrNull != null
                                            ? addTprBloc.trpTriggersPackage.value!.startDate!
                                            : DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100),
                                        builder: (context, child) {
                                          return Theme(
                                            data: ThemeData.light().copyWith(
                                              colorScheme: const ColorScheme.light(
                                                primary: AppColors.colorPrimary,
                                              ),
                                            ),
                                            child: child ?? Container(),
                                          );
                                        },
                                      );

                                      if (dateTime != null) {
                                        addTprBloc.startDateError.add(false);
                                        addTprBloc.startDate = dateTime;
                                        String? formattedDate =
                                            AppUtil.displayDateFormat(dateTime: dateTime);
                                        addTprBloc.startDateController.text = formattedDate!;
                                        addTprBloc.endDateController.clear();
                                      }
                                    },
                                    child: SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: Padding(
                                        padding: AppPaddingConstants().employeePagePadding1,
                                        child: SvgPicture.asset(
                                          icCalendarIcon,
                                          color: AppColors.colorLightGrey100,
                                        ),
                                      ),
                                    ),
                                  ),
                                  textEditingController: addTprBloc.startDateController,
                                  showError: addTprBloc.startDateError.value,
                                );
                              },
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            StreamBuilder(
                              stream: addTprBloc.startDateError,
                              builder: (context, snapshot) {
                                if (addTprBloc.startDateError.value) {
                                  return Text(
                                    "Please add start date first".i18n,
                                    style: AppTextStyle().errorStyle,
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder(
                      stream: addTprBloc.endDateError,
                      builder: (context, snapshot) {
                        return AppTextField(
                          isFocused: false,
                          label: "End Date".i18n,
                          readOnly: true,
                          suffixIcon: GestureDetector(
                            onTap: () async {
                              if (addTprBloc.startDateController.text.isNotEmpty) {
                                DateTime? dateTime = await showDatePicker(
                                  context: context,
                                  initialDate: addTprBloc.trpTriggersPackage.valueOrNull != null
                                      ? addTprBloc.trpTriggersPackage.value!.endDate!
                                      : addTprBloc.startDate.add(const Duration(days: 1)),
                                  firstDate: addTprBloc.trpTriggersPackage.valueOrNull != null
                                      ? addTprBloc.trpTriggersPackage.value!.endDate!
                                      : addTprBloc.startDate.add(const Duration(days: 1)),
                                  lastDate: DateTime(2100),
                                  builder: (context, child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: AppColors.colorPrimary,
                                        ),
                                      ),
                                      child: child ?? Container(),
                                    );
                                  },
                                );

                                if (dateTime != null) {
                                  addTprBloc.startDateError.add(false);
                                  String formattedDate = AppUtil.displayDateFormat(dateTime: dateTime)!;
                                  addTprBloc.endDate = dateTime;
                                  addTprBloc.endDateController.text = formattedDate;
                                }
                              } else {
                                addTprBloc.startDateError.add(true);
                              }
                            },
                            child: SizedBox(
                              height: 16,
                              width: 16,
                              child: Padding(
                                padding: AppPaddingConstants().employeePagePadding1,
                                child: SvgPicture.asset(
                                  icCalendarIcon,
                                  color: AppColors.colorLightGrey100,
                                ),
                              ),
                            ),
                          ),
                          textEditingController: addTprBloc.endDateController,
                          showError: addTprBloc.endDateError.value,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    StreamBuilder(
                      stream: addTprBloc.endDateError,
                      builder: (context, snapshot) {
                        if (addTprBloc.endDateError.value) {
                          return Text(
                            "Please add end date".i18n,
                            style: AppTextStyle().errorStyle,
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder(
                      stream: addTprBloc.qtyTap,
                      builder: (context, snapshot) {
                        return Focus(
                          onFocusChange: (val) {
                            addTprBloc.qtyTap.add(val);
                          },
                          child: Column(
                            children: [
                              AppTextField(
                                isFocused: addTprBloc.qtyTap.value,
                                label: "Quantity".i18n,
                                textEditingController: addTprBloc.qtyController,
                                showError: addTprBloc.qtyError.value,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                validatorFunction: (value) {
                                  if (value == null || value.isEmpty) {
                                    addTprBloc.qtyTap.add(addTprBloc.qtyTap.value);
                                    addTprBloc.qtyError.add(true);
                                  } else {
                                    addTprBloc.qtyTap.add(addTprBloc.qtyTap.value);
                                    addTprBloc.qtyError.add(false);
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              StreamBuilder(
                                stream: addTprBloc.qtyError,
                                builder: (context, snapshot) {
                                  return Visibility(
                                    visible: addTprBloc.qtyError.value,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Quantity is required'.i18n,
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
                    StreamBuilder(
                      stream: addTprBloc.amtCalValue,
                      builder: (context, snapshot) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: addTprBloc.amtCal.map((e) {
                            return Padding(
                              padding: AppPaddingConstants().right8,
                              child: AppRadioOption(
                                groupValue: addTprBloc.amtCalValue.value,
                                value: e,
                                text: e,
                                onChanged: (val) {
                                  addTprBloc.amtCalValue.add(val);
                                  addTprBloc.amtCalController.clear();
                                },
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder(
                      stream: addTprBloc.amtCalTap,
                      builder: (context, snapshot) {
                        return Focus(
                          onFocusChange: (val) {
                            addTprBloc.amtCalTap.add(val);
                          },
                          child: StreamBuilder(
                            stream: addTprBloc.amtCalValue,
                            builder: (context, snapshot) {
                              return Column(
                                children: [
                                  AppTextField(
                                    isFocused: addTprBloc.amtCalTap.value,
                                    label:
                                        addTprBloc.amtCalValue.value.compareTo("By Percentages".i18n) ==
                                                0
                                            ? "By Percentages".i18n
                                            : "By Amount".i18n,
                                    textEditingController: addTprBloc.amtCalController,
                                    showError: addTprBloc.amtCalError.value,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(AppUtil.allowDecimal()),
                                    ],
                                    validatorFunction: (value) {
                                      if (value == null || value.isEmpty) {
                                        addTprBloc.amtCalTap.add(addTprBloc.amtCalTap.value);
                                        addTprBloc.amtCalError.add(true);
                                      } else {
                                        addTprBloc.amtCalTap.add(addTprBloc.amtCalTap.value);
                                        addTprBloc.amtCalError.add(false);
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  StreamBuilder(
                                    stream: addTprBloc.amtCalError,
                                    builder: (context, snapshot) {
                                      return Visibility(
                                        visible: addTprBloc.qtyError.value,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            addTprBloc.amtCalValue.value
                                                        .compareTo("By Percentages".i18n) ==
                                                    0
                                                ? 'Percentage is required'.i18n
                                                : 'Amount is required'.i18n,
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
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void showPackagesDialog() {
    showDialog(
      context: AppRouteManager.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: AppPaddingConstants().leftRight25,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Center(
                    child: Text(
                      "Packages",
                      style: AppTextStyle().appBarTextStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text("Primary Packages".i18n),
                  const SizedBox(
                    height: 12,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: addTprBloc.primaryPackages.length,
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: AppPaddingConstants().bottom8,
                        child: ListTile(
                          onTap: () {
                            addTprBloc.trpTriggers.add(addTprBloc.primaryPackages[index]);
                            addTprBloc.packageName.text = addTprBloc.trpTriggers.value!.packageName!;
                            addTprBloc.packageDetails(
                              storeItemId: addTprBloc.primaryPackages[index].storeItemId!,
                              packageId: addTprBloc.primaryPackages[index].packageId!,
                            );
                            AppRouteManager.pop();
                          },
                          style: ListTileStyle.list,
                          shape: const StadiumBorder(
                            side: BorderSide(color: AppColors.colorPrimary, width: 1),
                          ),
                          title: Text(addTprBloc.primaryPackages[index].packageName!),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Visibility(
                    visible: addTprBloc.secondaryPackages.isNotEmpty,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Secondary Packages".i18n),
                        const SizedBox(
                          height: 12,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: addTprBloc.secondaryPackages.length,
                          itemBuilder: (ctx, index) {
                            return Padding(
                              padding: AppPaddingConstants().bottom8,
                              child: ListTile(
                                onTap: () {
                                  addTprBloc.trpTriggers.add(addTprBloc.secondaryPackages[index]);
                                  addTprBloc.packageName.text =
                                      addTprBloc.trpTriggers.value!.packageName!;

                                  addTprBloc.packageDetails(
                                    storeItemId: addTprBloc.secondaryPackages[index].storeItemId!,
                                    packageId: addTprBloc.secondaryPackages[index].packageId!,
                                  );
                                  AppRouteManager.pop();
                                },
                                style: ListTileStyle.list,
                                shape: const StadiumBorder(
                                  side: BorderSide(color: AppColors.colorPrimary, width: 1),
                                ),
                                title: Text(addTprBloc.secondaryPackages[index].packageName!),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Visibility(
                    visible: addTprBloc.secondaryPackages.isNotEmpty,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tertiary Packages".i18n),
                        const SizedBox(
                          height: 12,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: addTprBloc.tertiaryPackages.length,
                          itemBuilder: (ctx, index) {
                            return Padding(
                              padding: AppPaddingConstants().bottom8,
                              child: ListTile(
                                onTap: () {
                                  addTprBloc.trpTriggers.add(addTprBloc.tertiaryPackages[index]);
                                  addTprBloc.packageName.text =
                                      addTprBloc.trpTriggers.value!.packageName!;

                                  addTprBloc.packageDetails(
                                    storeItemId: addTprBloc.tertiaryPackages[index].storeItemId!,
                                    packageId: addTprBloc.tertiaryPackages[index].packageId!,
                                  );
                                  AppRouteManager.pop();
                                },
                                style: ListTileStyle.list,
                                shape: const StadiumBorder(
                                  side: BorderSide(color: AppColors.colorPrimary, width: 1),
                                ),
                                title: Text(addTprBloc.tertiaryPackages[index].packageName!),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  BaseBloc? getBaseBloc() {
    return addTprBloc;
  }
}
