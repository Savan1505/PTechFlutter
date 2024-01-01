import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/widget/app_dropdown.dart';
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/bloc/item_bloc.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/package/model/item_package_model.dart';
import 'package:rxdart/rxdart.dart';

class AddItemPackageV1 extends StatefulWidget {
  final ItemBloc itemBloc;
  final bool isMultiPack;

  const AddItemPackageV1({
    super.key,
    required this.itemBloc,
    required this.isMultiPack,
  });

  @override
  State<AddItemPackageV1> createState() => _AddItemPackageV1State();
}

class _AddItemPackageV1State extends State<AddItemPackageV1> {
  BehaviorSubject<bool> packageNameRebuild = BehaviorSubject<bool>.seeded(false);

  @override
  void initState() {
    super.initState();

    if (widget.itemBloc.itemPrimaryPackageList.isEmpty) {
      widget.itemBloc.itemPackageNameController.text = widget.itemBloc.itemNameController.text;
      if (widget.itemBloc.itemPackageQtyController.text.compareTo("1") != 0) {
        widget.itemBloc.itemPackageQtyController.text = "1";
      }
    } else {
      widget.itemBloc.itemPackageQtyController.clear();
    }
  }

  @override
  void dispose() {
    packageNameRebuild.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.itemBloc.formPackageKeyV1,
      child: SingleChildScrollView(
        child: Padding(
          padding: AppPaddingConstants().leftRight25,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              StreamBuilder(
                stream: widget.itemBloc.itemPackageNameTap.stream,
                builder: (context, snapshot) {
                  return Focus(
                    onFocusChange: (val) {
                      widget.itemBloc.itemPackageNameTap.add(val);
                    },
                    child: Column(
                      children: [
                        AppTextField(
                          isFocused: widget.itemBloc.itemPackageNameTap.value,
                          label: "Package Name".i18n,
                          textEditingController: widget.itemBloc.itemPackageNameController,
                          showError: widget.itemBloc.itemPackageNameShowError.value,
                          onChangeFunction: (value) {
                            packageNameRebuild.add(true);
                            return null;
                          },
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              widget.itemBloc.itemPackageNameTap
                                  .add(widget.itemBloc.itemPackageNameTap.value);
                              widget.itemBloc.itemPackageNameShowError.add(true);
                            } else {
                              widget.itemBloc.itemPackageNameTap
                                  .add(widget.itemBloc.itemPackageNameTap.value);
                              widget.itemBloc.itemPackageNameShowError.add(false);
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        StreamBuilder(
                          stream: widget.itemBloc.itemPackageNameShowError,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: widget.itemBloc.itemPackageNameShowError.value,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Please enter package name'.i18n,
                                  style: AppTextStyle().errorStyle,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Visibility(
                          visible: (widget.itemBloc.uomValue.value.compareTo("Unit") != 0 &&
                              (widget.itemBloc.itemPrimaryPackageList.isEmpty)),
                          child: StreamBuilder(
                            stream: packageNameRebuild,
                            builder: (context, snapshot) {
                              return Text(
                                "${widget.itemBloc.itemPackageNameController.text} - Open (Raw)",
                              );
                            },
                          ),
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
                stream: widget.itemBloc.itemPackageType,
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      StreamBuilder(
                        stream: widget.itemBloc.itemPackageTypeShowError,
                        builder: (context, snapshot) {
                          return AppDropdown(
                            borderColor: widget.itemBloc.itemPackageTypeShowError.value
                                ? AppColors.redColor
                                : AppColors.colorTransparent,
                            items: getPackageType().map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                ),
                              );
                            }).toList(),
                            value: widget.itemBloc.itemPackageType.valueOrNull,
                            hintText: "Package Type".i18n,
                            onChanged: (value) {
                              widget.itemBloc.itemPackageType.add(value);
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      StreamBuilder(
                        stream: widget.itemBloc.itemPackageTypeShowError,
                        builder: (context, snapshot) {
                          return Visibility(
                            visible: widget.itemBloc.itemPackageTypeShowError.value,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Select package type'.i18n,
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
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: widget.itemBloc.itemPackageForValue,
                builder: (context, snapshot) {
                  return AppDropdown(
                    items: widget.itemBloc.itemPackageFor.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(
                          e.name,
                        ),
                      );
                    }).toList(),
                    value: widget.itemBloc.itemPackageForValue.valueOrNull,
                    hintText: "Package For".i18n,
                    onChanged: (value) {
                      if (value!.code.compareTo("Prse") != 0) {
                        widget.itemBloc.itemRetailPriceController.clear();
                        widget.itemBloc.itemMarkUpController.clear();
                        widget.itemBloc.itemMarginController.clear();
                        widget.itemBloc.itemColdPriceController.clear();
                        widget.itemBloc.itemWarmPriceController.clear();
                      }
                      widget.itemBloc.itemPackageForValue.add(value);
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: widget.itemBloc.contentTypeValue,
                builder: (context, snapshot) {
                  return AppDropdown(
                    items: getContentTypeList().map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(
                          e.name,
                        ),
                      );
                    }).toList(),
                    value: widget.itemBloc.contentTypeValue.valueOrNull,
                    hintText: "Content Type".i18n,
                    onChanged: (value) {
                      widget.itemBloc.contentTypeValue.add(value!);
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: widget.itemBloc.itemPackageQtyTap.stream,
                builder: (context, snapshot) {
                  return Focus(
                    onFocusChange: (val) {
                      widget.itemBloc.itemPackageQtyTap.add(val);
                    },
                    child: Column(
                      children: [
                        AppTextField(
                          isFocused: widget.itemBloc.itemPackageQtyTap.value,
                          label: "Content QTY".i18n,
                          textEditingController: widget.itemBloc.itemPackageQtyController,
                          showError: widget.itemBloc.itemPackageQtyShowError.value,
                          keyboardType: TextInputType.number,
                          enabled: widget.itemBloc.itemPrimaryPackageList.isNotEmpty,
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[1-9]'))],
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              widget.itemBloc.itemPackageQtyTap
                                  .add(widget.itemBloc.itemPackageQtyTap.value);
                              widget.itemBloc.itemPackageQtyShowError.add(true);
                            } else {
                              widget.itemBloc.itemPackageQtyTap
                                  .add(widget.itemBloc.itemPackageQtyTap.value);
                              widget.itemBloc.itemPackageQtyShowError.add(false);
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        StreamBuilder(
                          stream: widget.itemBloc.itemPackageQtyShowError,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: widget.itemBloc.itemPackageQtyShowError.value,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Please enter qty'.i18n,
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
              Visibility(
                visible: widget.itemBloc.uomValue.value.compareTo("Unit") == 0,
                child: StreamBuilder(
                  stream: widget.itemBloc.itemPackageSize,
                  builder: (context, snapshot) {
                    return AppDropdown(
                      items: widget.itemBloc.resItemPackageSizeCollectionModel.data!.list!.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(
                            e.name!,
                          ),
                        );
                      }).toList(),
                      value: widget.itemBloc.itemPackageSize.valueOrNull,
                      hintText: "Size".i18n,
                      onChanged: (value) {
                        widget.itemBloc.itemPackageSize.add(value);
                      },
                    );
                  },
                ),
              ),
              Visibility(
                visible: widget.itemBloc.uomValue.value.compareTo("Unit") == 0,
                child: const SizedBox(
                  height: 20,
                ),
              ),
              StreamBuilder(
                stream: widget.itemBloc.itemPackageQtyOnHandTap.stream,
                builder: (context, snapshot) {
                  return Focus(
                    onFocusChange: (val) {
                      widget.itemBloc.itemPackageQtyOnHandTap.add(val);
                    },
                    child: AppTextField(
                      isFocused: widget.itemBloc.itemPackageQtyOnHandTap.value,
                      label: "QTY on Hand".i18n,
                      textEditingController: widget.itemBloc.itemPackageQtyOnHandController,
                      showError: false,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(AppUtil.allowDecimal())],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: widget.itemBloc.itemPackageUnitCostTap.stream,
                builder: (context, snapshot) {
                  return Focus(
                    onFocusChange: (val) {
                      widget.itemBloc.itemPackageUnitCostTap.add(val);
                    },
                    child: Column(
                      children: [
                        AppTextField(
                          isFocused: widget.itemBloc.itemPackageUnitCostTap.value,
                          label: "Unit Cost".i18n,
                          textEditingController: widget.itemBloc.itemPackageUnitCostController,
                          showError: widget.itemBloc.itemPackageUnitCostShowError.value,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(AppUtil.allowDecimal()),
                          ],
                          onChangeFunction: (value) {
                            if (value?.isNotEmpty ?? false) {
                              if (double.parse(value!) != 0) {
                                widget.itemBloc.marginMarkupCalculation();
                                widget.itemBloc.retailMarginCalculation();
                                widget.itemBloc.retailMarkupCalculation();
                              }
                            }
                            return null;
                          },
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              widget.itemBloc.itemPackageUnitCostTap
                                  .add(widget.itemBloc.itemPackageUnitCostTap.value);
                              widget.itemBloc.itemPackageUnitCostShowError.add(true);
                            } else {
                              widget.itemBloc.itemPackageUnitCostTap
                                  .add(widget.itemBloc.itemPackageUnitCostTap.value);
                              widget.itemBloc.itemPackageUnitCostShowError.add(false);
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        StreamBuilder(
                          stream: widget.itemBloc.itemPackageUnitCostShowError,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: widget.itemBloc.itemPackageUnitCostShowError.value,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Please enter Unit Cost'.i18n,
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
                height: 130,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ItemPackageModel> getContentTypeList() {
    if (widget.itemBloc.itemPrimaryPackageList.isEmpty) {
      if (widget.itemBloc.uomValue.value.compareTo("Volume") == 0) {
        widget.itemBloc.contentTypeValue.add(widget.itemBloc.contentOfVolume[0]);
        return [widget.itemBloc.contentOfVolume[0]];
      } else if (widget.itemBloc.uomValue.value.compareTo("Weight") == 0) {
        widget.itemBloc.contentTypeValue.add(widget.itemBloc.contentOfWeight[0]);
        return [widget.itemBloc.contentOfWeight[0]];
      } else {
        widget.itemBloc.contentTypeValue.add(widget.itemBloc.contentOfSingle[0]);
        return widget.itemBloc.contentOfSingle;
      }
    } else {
      if (widget.itemBloc.uomValue.value.compareTo("Volume") == 0) {
        widget.itemBloc.contentTypeValue.add(widget.itemBloc.contentOfVolume[0]);
        return widget.itemBloc.contentOfVolume;
      } else if (widget.itemBloc.uomValue.value.compareTo("Weight") == 0) {
        widget.itemBloc.contentTypeValue.add(widget.itemBloc.contentOfWeight[0]);
        return widget.itemBloc.contentOfWeight;
      } else {
        widget.itemBloc.contentTypeValue.add(widget.itemBloc.contentOfSingle[0]);
        return widget.itemBloc.contentOfSingle;
      }
    }
  }

  List<String> getPackageType() {
    if (widget.itemBloc.uomValue.value.compareTo("Volume") == 0) {
      return widget.itemBloc.packageTypeValues;
    }
    List<String> t = [];
    for (int i = 0; i < widget.itemBloc.packageTypeValues.length; i++) {
      if (i != 0) {
        t.add(widget.itemBloc.packageTypeValues[i]);
      }
    }
    return t;
  }
}
