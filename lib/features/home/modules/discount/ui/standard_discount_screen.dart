import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/base/base_bloc.dart';
import 'package:ptecpos_mobile/core/base/base_state.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/utils/image_path.dart';
import 'package:ptecpos_mobile/core/widget/app_bottom_sheet.dart';
import 'package:ptecpos_mobile/core/widget/app_button.dart';
import 'package:ptecpos_mobile/core/widget/app_radio_field.dart';
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/core/widget/custom_textfield_widget.dart';
import 'package:ptecpos_mobile/core/widget/default_loading_widget.dart';
import 'package:ptecpos_mobile/core/widget/discount_tile.dart';
import 'package:ptecpos_mobile/core/widget/error_screen_widget.dart';
import 'package:ptecpos_mobile/core/widget/multi_select_widget/dialog/multi_select_dialog_field.dart';
import 'package:ptecpos_mobile/core/widget/multi_select_widget/multi_select_flutter.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/bloc/standard_discount_bloc.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/model/res_standard_store_model.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/state/standard_discount_state.dart';

class StandardDiscountScreen extends StatefulWidget {
  const StandardDiscountScreen({super.key});

  @override
  State<StandardDiscountScreen> createState() => _StandardDiscountScreenState();
}

class _StandardDiscountScreenState extends BaseState<StandardDiscountScreen> {
  final StandardDiscountBloc standardDiscountBloc = StandardDiscountBloc();

  @override
  void initState() {
    super.initState();
    buttonBehaviour();
    standardDiscountBloc.initData();
    standardDiscountBloc.searchController.addListener(standardDiscountBloc.scrollListener);
  }

  void buttonBehaviour() {
    RootBloc().changeBottomBarBehaviour(
      onTap: buttonTap,
      bottomBarIconPath: icPlusIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: standardDiscountBloc.discountState,
        builder: (context, snapshot) {
          if (standardDiscountBloc.discountState.value.isLoading()) {
            return const DefaultLoadingWidget();
          }
          if (standardDiscountBloc.discountState.value.isError()) {
            return const ErrorWidgetScreen();
          }
          return SingleChildScrollView(
            controller: standardDiscountBloc.scrollController,
            child: Padding(
              padding: AppPaddingConstants().leftRight25,
              child: Column(
                children: [
                  const SizedBox(
                    height: 32,
                  ),

                  /// App bar
                  buildAppBar(),

                  StreamBuilder(
                    stream: standardDiscountBloc.filterDiscountState,
                    builder: (context, snapshot) {
                      if (standardDiscountBloc.filterDiscountState.value.isLoading()) {
                        return const DefaultLoadingWidget();
                      }
                      if (standardDiscountBloc.filterDiscountState.value.isError()) {
                        return const ErrorWidgetScreen();
                      }
                      if (standardDiscountBloc.resStandardDiscountModel.data?.list?.isEmpty ?? true) {
                        return Text("No standard discount found".i18n);
                      }
                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: standardDiscountBloc.resStandardDiscountModel.data!.list!.length,
                            itemBuilder: (ctx, index) {
                              var item =
                                  standardDiscountBloc.resStandardDiscountModel.data!.list![index];
                              return DiscountTile(
                                name: item.name!,
                                percentage: item.percentage!.toString(),
                                onEditTap: () {
                                  editStandard(item.id!);
                                },
                                onDeleteTap: () {
                                  alertBox(context: context, id: item.id!);
                                },
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          StreamBuilder(
                            stream: standardDiscountBloc.loadingState,
                            builder: (context, snapshot) {
                              if (standardDiscountBloc.loadingState.value) {
                                return const CircularProgressIndicator();
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
                    height: 150,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildAppBar() {
    return StreamBuilder(
      stream: standardDiscountBloc.isSearchEnabled,
      builder: (context, snapshot) {
        if (standardDiscountBloc.isSearchEnabled.value) {
          return ListTile(
            leading: InkWell(
              onTap: () {
                standardDiscountBloc.searchController.clear();
                standardDiscountBloc.isSearchEnabled.add(!standardDiscountBloc.isSearchEnabled.value);
                standardDiscountBloc.searchedData();
              },
              child: Container(
                margin: const EdgeInsets.only(
                  left: 15,
                  right: 10,
                ),
                child: AppUtil.circularImageWidget(
                  iconData: Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios_new_rounded,
                  height: 20,
                  paddingAll: 10,
                  depth: 2,
                ),
              ),
            ),
            horizontalTitleGap: -20,
            contentPadding: const EdgeInsets.all(
              -20,
            ),
            title: CustomTextFieldWidget(
              left: 20,
              right: 10,
              hint: "searchHere".i18n,
              textEditingController: standardDiscountBloc.searchController,
              textInputAction: TextInputAction.search,
              onChangedMethod: (value) {
                standardDiscountBloc.searchedData();
              },
              suffixIcon: InkWell(
                onTap: () {
                  standardDiscountBloc.searchController.clear();
                  standardDiscountBloc.isSearchEnabled.add(!standardDiscountBloc.isSearchEnabled.value);
                  standardDiscountBloc.searchedData();
                },
                child: AppUtil.circularImageWidget(
                  iconData: Icons.close,
                  height: 20,
                  paddingAll: 10,
                  depth: 0,
                ),
              ),
            ),
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Standard Discounts".i18n,
              style: AppTextStyle().employeeTextStyle,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    standardDiscountBloc.isSearchEnabled.add(true);
                  },
                  child: AppUtil.circularImageWidget(
                    iconData: Icons.search,
                    height: 18,
                    paddingAll: 10,
                    depth: 0.1,
                  ),
                ),
                const SizedBox(
                  width: 7,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  BaseBloc? getBaseBloc() {
    return standardDiscountBloc;
  }

  void buttonTap() {
    AppBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "Add Standard discount".i18n,
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.colorBlack,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder(
            stream: standardDiscountBloc.addTypeValue,
            builder: (context, snapshot) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: standardDiscountBloc.addType.map((e) {
                  return Padding(
                    padding: AppPaddingConstants().right8,
                    child: AppRadioOption(
                      groupValue: standardDiscountBloc.addTypeValue.value,
                      value: e,
                      text: e,
                      onChanged: (val) {
                        standardDiscountBloc.addTypeValue.add(val);
                        standardDiscountBloc.addReset();
                        if (standardDiscountBloc.addTypeValue.value
                                .compareTo(standardDiscountBloc.addType.first) !=
                            0) {
                          standardDiscountBloc.addInitData();
                        }
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
            stream: standardDiscountBloc.addTypeValue,
            builder: (context, snapshot) {
              if (standardDiscountBloc.addTypeValue.value
                      .compareTo(standardDiscountBloc.addType.first) ==
                  0) {
                return addTypeMethod();
              }
              return addMultiTypeMethod();
            },
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder(
            stream: standardDiscountBloc.addState,
            builder: (context, snapshot) {
              return Visibility(
                visible: standardDiscountBloc.addState.valueOrNull?.isCompleted() ?? true,
                child: AppButton(
                  label: "Save".i18n,
                  onPressed: () {
                    standardDiscountBloc.addFormKey.currentState?.validate();
                    standardDiscountBloc.addMultiFormKey.currentState?.validate();

                    if (standardDiscountBloc.checkValidation()) {
                      Navigator.pop(context);
                      standardDiscountBloc.postStandard();
                    }
                  },
                ),
              );
            },
          ),
          const SizedBox(
            height: 85,
          ),
        ],
      ),
    ).showBottomSheet().then((value) {
      standardDiscountBloc.addTypeValue.add(standardDiscountBloc.addType.first);
      standardDiscountBloc.addReset();
    });
  }

  StreamBuilder<StandardDiscountState> addMultiTypeMethod() {
    return StreamBuilder(
      stream: standardDiscountBloc.addState,
      builder: (context, snapshot) {
        if (standardDiscountBloc.addState.value.isLoading()) {
          return const Center(child: CircularProgressIndicator());
        }
        if (standardDiscountBloc.addState.value.isError()) {
          return const ErrorWidgetScreen();
        }
        return Form(
          key: standardDiscountBloc.addMultiFormKey,
          child: Column(
            children: [
              StreamBuilder(
                stream: standardDiscountBloc.standardStoresValue,
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      MultiSelectDialogField<StandardStores>(
                        items: standardDiscountBloc.standardStores,
                        title: Text("Select Stores".i18n),
                        initialValue: standardDiscountBloc.standardStoresValue.value,
                        onConfirm: (value) {
                          standardDiscountBloc.standardStoresValue.add(value);
                        },
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Visibility(
                        visible: standardDiscountBloc.standardStoresValue.value.isEmpty,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Store is required'.i18n,
                            style: AppTextStyle().errorStyle,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: standardDiscountBloc.discountTap,
                builder: (context, snapshot) {
                  return Focus(
                    onFocusChange: (val) {
                      standardDiscountBloc.discountTap.add(val);
                    },
                    child: Column(
                      children: [
                        AppTextField(
                          isFocused: standardDiscountBloc.discountTap.value,
                          label: "Discount Name".i18n,
                          textEditingController: standardDiscountBloc.discountNameController,
                          showError: standardDiscountBloc.discountError.value,
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              standardDiscountBloc.discountTap
                                  .add(standardDiscountBloc.discountTap.value);
                              standardDiscountBloc.discountError.add(true);
                            } else {
                              standardDiscountBloc.discountTap
                                  .add(standardDiscountBloc.discountTap.value);
                              standardDiscountBloc.discountError.add(false);
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        StreamBuilder(
                          stream: standardDiscountBloc.discountError,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: standardDiscountBloc.discountError.value,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Discount name is required'.i18n,
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
                stream: standardDiscountBloc.percentageTap,
                builder: (context, snapshot) {
                  return Focus(
                    onFocusChange: (val) {
                      standardDiscountBloc.percentageTap.add(val);
                    },
                    child: Column(
                      children: [
                        AppTextField(
                          isFocused: standardDiscountBloc.percentageTap.value,
                          label: "Percentages".i18n,
                          textEditingController: standardDiscountBloc.percentageNameController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(AppUtil.allowDecimal())],
                          showError: standardDiscountBloc.percentageError.value,
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              standardDiscountBloc.percentageTap
                                  .add(standardDiscountBloc.percentageTap.value);
                              standardDiscountBloc.percentageError.add(true);
                            } else {
                              standardDiscountBloc.percentageTap
                                  .add(standardDiscountBloc.percentageTap.value);
                              standardDiscountBloc.percentageError.add(false);
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        StreamBuilder(
                          stream: standardDiscountBloc.percentageError,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: standardDiscountBloc.percentageError.value,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  standardDiscountBloc.percentageErrorMsg,
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
            ],
          ),
        );
      },
    );
  }

  Form addTypeMethod() {
    return Form(
      key: standardDiscountBloc.addFormKey,
      child: Column(
        children: [
          StreamBuilder(
            stream: standardDiscountBloc.discountTap,
            builder: (context, snapshot) {
              return Focus(
                onFocusChange: (val) {
                  standardDiscountBloc.discountTap.add(val);
                },
                child: Column(
                  children: [
                    AppTextField(
                      isFocused: standardDiscountBloc.discountTap.value,
                      label: "Discount Name".i18n,
                      textEditingController: standardDiscountBloc.discountNameController,
                      showError: standardDiscountBloc.discountError.value,
                      validatorFunction: (value) {
                        if (value == null || value.isEmpty) {
                          standardDiscountBloc.discountTap.add(standardDiscountBloc.discountTap.value);
                          standardDiscountBloc.discountError.add(true);
                        } else {
                          standardDiscountBloc.discountTap.add(standardDiscountBloc.discountTap.value);
                          standardDiscountBloc.discountError.add(false);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    StreamBuilder(
                      stream: standardDiscountBloc.discountError,
                      builder: (context, snapshot) {
                        return Visibility(
                          visible: standardDiscountBloc.discountError.value,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Discount name is required'.i18n,
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
            stream: standardDiscountBloc.percentageTap,
            builder: (context, snapshot) {
              return Focus(
                onFocusChange: (val) {
                  standardDiscountBloc.percentageTap.add(val);
                },
                child: Column(
                  children: [
                    AppTextField(
                      isFocused: standardDiscountBloc.percentageTap.value,
                      label: "Percentages".i18n,
                      textEditingController: standardDiscountBloc.percentageNameController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(AppUtil.allowDecimal())],
                      showError: standardDiscountBloc.percentageError.value,
                      validatorFunction: (value) {
                        if (value == null || value.isEmpty) {
                          standardDiscountBloc.percentageTap
                              .add(standardDiscountBloc.percentageTap.value);
                          standardDiscountBloc.percentageError.add(true);
                        } else {
                          standardDiscountBloc.percentageTap
                              .add(standardDiscountBloc.percentageTap.value);
                          standardDiscountBloc.percentageError.add(false);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    StreamBuilder(
                      stream: standardDiscountBloc.percentageError,
                      builder: (context, snapshot) {
                        return Visibility(
                          visible: standardDiscountBloc.percentageError.value,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              standardDiscountBloc.percentageErrorMsg,
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
        ],
      ),
    );
  }

  Future<void> alertBox({required BuildContext context, required String id}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Remove Standard Discount".i18n),
          content: Text("Are you sure you want to do this?".i18n),
          actions: [
            Padding(
              padding: AppPaddingConstants().bottom8,
              child: AppButton(
                label: "No".i18n,
                onPressed: () {
                  Navigator.pop(ctx);
                },
                labelColor: AppColors.colorPrimary,
                color: AppColors.colorWhite,
                height: 32,
              ),
            ),
            AppButton(
              label: "Yes".i18n,
              onPressed: () {
                Navigator.pop(ctx);
                standardDiscountBloc.deleteStandard(id);
              },
              height: 32,
            ),
          ],
        );
      },
    );
  }

  void editStandard(String id) {
    standardDiscountBloc.getStandard(id);
    AppBottomSheet(
      child: StreamBuilder(
        stream: standardDiscountBloc.editState,
        builder: (context, snapshot) {
          if (standardDiscountBloc.editState.value.isLoading()) {
            return const DefaultLoadingWidget(
              loadingBars: 2,
            );
          }
          if (standardDiscountBloc.editState.value.isError()) {
            return const ErrorWidgetScreen();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                "Edit Standard discount".i18n,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.colorBlack,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: standardDiscountBloc.addFormKey,
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: standardDiscountBloc.discountTap,
                      builder: (context, snapshot) {
                        return Focus(
                          onFocusChange: (val) {
                            standardDiscountBloc.discountTap.add(val);
                          },
                          child: Column(
                            children: [
                              AppTextField(
                                isFocused: standardDiscountBloc.discountTap.value,
                                label: "Discount Name".i18n,
                                textEditingController: standardDiscountBloc.discountNameController,
                                showError: standardDiscountBloc.discountError.value,
                                validatorFunction: (value) {
                                  if (value == null || value.isEmpty) {
                                    standardDiscountBloc.discountTap
                                        .add(standardDiscountBloc.discountTap.value);
                                    standardDiscountBloc.discountError.add(true);
                                  } else {
                                    standardDiscountBloc.discountTap
                                        .add(standardDiscountBloc.discountTap.value);
                                    standardDiscountBloc.discountError.add(false);
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              StreamBuilder(
                                stream: standardDiscountBloc.discountError,
                                builder: (context, snapshot) {
                                  return Visibility(
                                    visible: standardDiscountBloc.discountError.value,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Discount name is required'.i18n,
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
                      stream: standardDiscountBloc.percentageTap,
                      builder: (context, snapshot) {
                        return Focus(
                          onFocusChange: (val) {
                            standardDiscountBloc.percentageTap.add(val);
                          },
                          child: Column(
                            children: [
                              AppTextField(
                                isFocused: standardDiscountBloc.percentageTap.value,
                                label: "Percentages".i18n,
                                textEditingController: standardDiscountBloc.percentageNameController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(AppUtil.allowDecimal()),
                                ],
                                showError: standardDiscountBloc.percentageError.value,
                                validatorFunction: (value) {
                                  if (value == null || value.isEmpty) {
                                    standardDiscountBloc.percentageTap
                                        .add(standardDiscountBloc.percentageTap.value);
                                    standardDiscountBloc.percentageError.add(true);
                                  } else {
                                    standardDiscountBloc.percentageTap
                                        .add(standardDiscountBloc.percentageTap.value);
                                    standardDiscountBloc.percentageError.add(false);
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              StreamBuilder(
                                stream: standardDiscountBloc.percentageError,
                                builder: (context, snapshot) {
                                  return Visibility(
                                    visible: standardDiscountBloc.percentageError.value,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        standardDiscountBloc.percentageErrorMsg,
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
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              AppButton(
                label: "Update".i18n,
                onPressed: () {
                  standardDiscountBloc.addFormKey.currentState?.validate();
                  if (standardDiscountBloc.checkValidation()) {
                    Navigator.pop(context);
                    standardDiscountBloc.editStandard(id);
                  }
                },
              ),
              const SizedBox(
                height: 85,
              ),
            ],
          );
        },
      ),
    ).showBottomSheet().then((value) {
      standardDiscountBloc.addTypeValue.add(standardDiscountBloc.addType.first);
      standardDiscountBloc.addReset();
    });
  }
}
