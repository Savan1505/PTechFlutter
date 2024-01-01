import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/base/base_bloc.dart';
import 'package:ptecpos_mobile/core/base/base_state.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
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
import 'package:ptecpos_mobile/core/widget/error_screen_widget.dart';
import 'package:ptecpos_mobile/core/widget/price_tile.dart';
import 'package:ptecpos_mobile/features/home/modules/price/bloc/price_bloc.dart';

class PriceLevelScreen extends StatefulWidget {
  const PriceLevelScreen({super.key});

  @override
  State<PriceLevelScreen> createState() => _PriceLevelScreenState();
}

class _PriceLevelScreenState extends BaseState<PriceLevelScreen> {
  final PriceBloc priceBloc = PriceBloc();

  @override
  void initState() {
    super.initState();
    buttonBehaviour();
    priceBloc.initData();
    priceBloc.searchController.addListener(priceBloc.scrollListener);
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
        stream: priceBloc.priceState,
        builder: (context, snapshot) {
          if (priceBloc.priceState.value.isLoading()) {
            return const DefaultLoadingWidget();
          }
          if (priceBloc.priceState.value.isError()) {
            return const ErrorWidgetScreen();
          }
          return SingleChildScrollView(
            controller: priceBloc.scrollController,
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
                    stream: priceBloc.filterPriceState,
                    builder: (context, snapshot) {
                      if (priceBloc.filterPriceState.value.isLoading()) {
                        return const DefaultLoadingWidget();
                      }
                      if (priceBloc.filterPriceState.value.isError()) {
                        return const ErrorWidgetScreen();
                      }
                      if (priceBloc.resPriceLevelModel.data?.list?.isEmpty ?? true) {
                        return Text("No price level found".i18n);
                      }
                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: priceBloc.resPriceLevelModel.data!.list!.length,
                            itemBuilder: (ctx, index) {
                              var item = priceBloc.resPriceLevelModel.data!.list![index];
                              return PriceTile(
                                name: item.name!,
                                percentage: item.rate.toString(),
                                onEditTap: () {
                                  editPriceLevel(item.id!);
                                },
                                onDeleteTap: () {
                                  alertBox(context: context, id: item.id!);
                                },
                                rateAdd: item.rateAdd ?? false,
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          StreamBuilder(
                            stream: priceBloc.loadingState,
                            builder: (context, snapshot) {
                              if (priceBloc.loadingState.value) {
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
      stream: priceBloc.isSearchEnabled,
      builder: (context, snapshot) {
        if (priceBloc.isSearchEnabled.value) {
          return ListTile(
            leading: InkWell(
              onTap: () {
                priceBloc.searchController.clear();
                priceBloc.isSearchEnabled.add(!priceBloc.isSearchEnabled.value);
                priceBloc.searchedData();
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
              textEditingController: priceBloc.searchController,
              textInputAction: TextInputAction.search,
              onChangedMethod: (value) {
                priceBloc.searchedData();
              },
              suffixIcon: InkWell(
                onTap: () {
                  priceBloc.searchController.clear();
                  priceBloc.isSearchEnabled.add(!priceBloc.isSearchEnabled.value);
                  priceBloc.searchedData();
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
              "Price Levels".i18n,
              style: AppTextStyle().employeeTextStyle,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    priceBloc.isSearchEnabled.add(true);
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
    return priceBloc;
  }

  void buttonTap() {
    AppBottomSheet(
      child: Form(
        key: priceBloc.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              "Add Price Level".i18n,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.colorBlack,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: priceBloc.nameTap,
              builder: (context, snapshot) {
                return Focus(
                  onFocusChange: (val) {
                    priceBloc.nameTap.add(val);
                  },
                  child: Column(
                    children: [
                      AppTextField(
                        isFocused: priceBloc.nameTap.value,
                        label: "Name".i18n,
                        textEditingController: priceBloc.nameController,
                        showError: priceBloc.nameError.value,
                        validatorFunction: (value) {
                          if (value == null || value.isEmpty) {
                            priceBloc.nameTap.add(priceBloc.nameTap.value);
                            priceBloc.nameError.add(true);
                          } else {
                            priceBloc.nameTap.add(priceBloc.nameTap.value);
                            priceBloc.nameError.add(false);
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      StreamBuilder(
                        stream: priceBloc.nameError,
                        builder: (context, snapshot) {
                          return Visibility(
                            visible: priceBloc.nameError.value,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Name is required'.i18n,
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
              stream: priceBloc.reduceTypeValue,
              builder: (context, snapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: priceBloc.reduceType.map((e) {
                    return Padding(
                      padding: AppPaddingConstants().right8,
                      child: AppRadioOption(
                        groupValue: priceBloc.reduceTypeValue.value,
                        value: e,
                        text: e,
                        onChanged: (val) {
                          priceBloc.reduceTypeValue.add(val);
                          priceBloc.reduceTap.add(priceBloc.reduceTap.value);

                          priceBloc.reduceController.clear();
                          if (priceBloc.reduceTypeValue.value.compareTo(priceBloc.reduceType.first) ==
                              0) {
                            priceBloc.reduceMessage = "By percentages is required".i18n;
                          } else {
                            priceBloc.reduceMessage = "By amount is required".i18n;
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
              stream: priceBloc.reduceTap,
              builder: (context, snapshot) {
                return Focus(
                  onFocusChange: (val) {
                    priceBloc.reduceTap.add(val);
                  },
                  child: Column(
                    children: [
                      AppTextField(
                        isFocused: priceBloc.reduceTap.value,
                        label: priceBloc.reduceTypeValue.value.compareTo(priceBloc.reduceType.first) == 0
                            ? "By Percentages".i18n
                            : "By Amount",
                        textEditingController: priceBloc.reduceController,
                        showError: priceBloc.reduceError.value,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(AppUtil.allowDecimal())],
                        validatorFunction: (value) {
                          if (value == null || value.isEmpty) {
                            priceBloc.reduceTap.add(priceBloc.reduceTap.value);
                            if (priceBloc.reduceTypeValue.value.compareTo(priceBloc.reduceType.first) ==
                                0) {
                              priceBloc.reduceMessage = "By percentages is required".i18n;
                            } else {
                              priceBloc.reduceMessage = "By amount is required".i18n;
                            }
                            priceBloc.reduceError.add(true);
                          } else {
                            priceBloc.reduceTap.add(priceBloc.reduceTap.value);
                            priceBloc.reduceError.add(false);
                            if (priceBloc.reduceTypeValue.value.compareTo(priceBloc.reduceType.first) ==
                                0) {
                              priceBloc.reduceMessage = "By percentages is required".i18n;
                            } else {
                              priceBloc.reduceMessage = "By amount is required".i18n;
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      StreamBuilder(
                        stream: priceBloc.reduceError,
                        builder: (context, snapshot) {
                          return Visibility(
                            visible: priceBloc.reduceError.value,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                priceBloc.reduceMessage,
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
              stream: priceBloc.addTypeValue,
              builder: (context, snapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: priceBloc.addType.map((e) {
                    return Padding(
                      padding: AppPaddingConstants().right8,
                      child: AppRadioOption(
                        groupValue: priceBloc.addTypeValue.value,
                        value: e,
                        text: e,
                        onChanged: (val) {
                          priceBloc.addTypeValue.add(val);
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
            AppButton(
              label: "Save".i18n,
              onPressed: () {
                priceBloc.formKey.currentState?.validate();
                if (priceBloc.checkValidation()) {
                  AppRouteManager.pop();
                  priceBloc.addPriceLevel();
                }
              },
            ),
            const SizedBox(
              height: 85,
            ),
          ],
        ),
      ),
    ).showBottomSheet().then((value) {
      priceBloc.reduceTypeValue.add(priceBloc.reduceType.first);
      priceBloc.addReset();
    });
  }

  void editPriceLevel(String id) {
    priceBloc.getPriceLevel(id);
    AppBottomSheet(
      child: StreamBuilder(
        stream: priceBloc.editState,
        builder: (context, snapshot) {
          if (priceBloc.editState.value.isLoading()) {
            return const Padding(
              padding: EdgeInsets.all(30.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (priceBloc.editState.value.isError()) {
            return const ErrorWidgetScreen();
          }
          return Form(
            key: priceBloc.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Edit Price Level".i18n,
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.colorBlack,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                  stream: priceBloc.nameTap,
                  builder: (context, snapshot) {
                    return Focus(
                      onFocusChange: (val) {
                        priceBloc.nameTap.add(val);
                      },
                      child: Column(
                        children: [
                          AppTextField(
                            isFocused: priceBloc.nameTap.value,
                            label: "Name".i18n,
                            textEditingController: priceBloc.nameController,
                            showError: priceBloc.nameError.value,
                            validatorFunction: (value) {
                              if (value == null || value.isEmpty) {
                                priceBloc.nameTap.add(priceBloc.nameTap.value);
                                priceBloc.nameError.add(true);
                              } else {
                                priceBloc.nameTap.add(priceBloc.nameTap.value);
                                priceBloc.nameError.add(false);
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          StreamBuilder(
                            stream: priceBloc.nameError,
                            builder: (context, snapshot) {
                              return Visibility(
                                visible: priceBloc.nameError.value,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Name is required'.i18n,
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
                  stream: priceBloc.reduceTypeValue,
                  builder: (context, snapshot) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: priceBloc.reduceType.map((e) {
                        return Padding(
                          padding: AppPaddingConstants().right8,
                          child: AppRadioOption(
                            groupValue: priceBloc.reduceTypeValue.value,
                            value: e,
                            text: e,
                            onChanged: (val) {
                              priceBloc.reduceTypeValue.add(val);
                              priceBloc.reduceTap.add(priceBloc.reduceTap.value);

                              priceBloc.reduceController.clear();
                              priceBloc.reduceMessage = "By percentages is required".i18n;
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
                  stream: priceBloc.reduceTap,
                  builder: (context, snapshot) {
                    return Focus(
                      onFocusChange: (val) {
                        priceBloc.reduceTap.add(val);
                      },
                      child: Column(
                        children: [
                          AppTextField(
                            isFocused: priceBloc.reduceTap.value,
                            label:
                                priceBloc.reduceTypeValue.value.compareTo(priceBloc.reduceType.first) ==
                                        0
                                    ? "By Percentages".i18n
                                    : "By Amount",
                            textEditingController: priceBloc.reduceController,
                            showError: priceBloc.reduceError.value,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(AppUtil.allowDecimal())],
                            validatorFunction: (value) {
                              if (value == null || value.isEmpty) {
                                priceBloc.reduceTap.add(priceBloc.reduceTap.value);
                                if (priceBloc.reduceTypeValue.value
                                        .compareTo(priceBloc.reduceType.first) ==
                                    0) {
                                  priceBloc.reduceMessage = "By percentages is required".i18n;
                                } else {
                                  priceBloc.reduceMessage = "By amount is required".i18n;
                                }
                                priceBloc.reduceError.add(true);
                              } else {
                                priceBloc.reduceTap.add(priceBloc.reduceTap.value);
                                priceBloc.reduceError.add(false);
                                if (priceBloc.reduceTypeValue.value
                                        .compareTo(priceBloc.reduceType.first) ==
                                    0) {
                                  priceBloc.reduceMessage = "By percentages is required".i18n;
                                } else {
                                  priceBloc.reduceMessage = "By amount is required".i18n;
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          StreamBuilder(
                            stream: priceBloc.reduceError,
                            builder: (context, snapshot) {
                              return Visibility(
                                visible: priceBloc.reduceError.value,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    priceBloc.reduceMessage,
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
                  stream: priceBloc.addTypeValue,
                  builder: (context, snapshot) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: priceBloc.addType.map((e) {
                        return Padding(
                          padding: AppPaddingConstants().right8,
                          child: AppRadioOption(
                            groupValue: priceBloc.addTypeValue.value,
                            value: e,
                            text: e,
                            onChanged: (val) {
                              priceBloc.addTypeValue.add(val);
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
                AppButton(
                  label: "Update".i18n,
                  onPressed: () {
                    priceBloc.formKey.currentState?.validate();
                    if (priceBloc.checkValidation()) {
                      AppRouteManager.pop();
                      priceBloc.editPriceLevel(id);
                    }
                  },
                ),
                const SizedBox(
                  height: 85,
                ),
              ],
            ),
          );
        },
      ),
    ).showBottomSheet().then((value) {
      priceBloc.reduceTypeValue.add(priceBloc.reduceType.first);
      priceBloc.addReset();
    });
  }

  Future<void> alertBox({required BuildContext context, required String id}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Remove Price Level".i18n),
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
                priceBloc.deletePriceLevel(id);
              },
              height: 32,
            ),
          ],
        );
      },
    );
  }
}
