import 'dart:io';

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:ptecpos_mobile/core/widget/app_button.dart';
import 'package:ptecpos_mobile/core/widget/app_dropdown.dart';
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/core/widget/arrow_card.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/bloc/item_bloc.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_storeitem_collectiontype_model.dart';

class AddItemPage extends StatefulWidget {
  final ItemBloc itemBloc;
  final void Function() onTap;

  const AddItemPage({
    super.key,
    required this.itemBloc,
    required this.onTap,
  });

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  late final void Function() bottomButtonBehaviour = widget.onTap;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.itemBloc.rebuildPage1,
      builder: (context, snapshot) {
        return Form(
          key: widget.itemBloc.formKeyV1,
          child: SingleChildScrollView(
            child: Padding(
              padding: AppPaddingConstants().leftRight25,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  StreamBuilder(
                    stream: widget.itemBloc.pickedImage,
                    builder: (context, snapshot) {
                      if (widget.itemBloc.pickedImage.valueOrNull != null) {
                        File file = File(widget.itemBloc.pickedImage.value!.path);
                        return GestureDetector(
                          onTap: () async {
                            var temp =
                                await widget.itemBloc.picker.pickImage(source: ImageSource.gallery);
                            if (temp != null) {
                              widget.itemBloc.pickedImage.add(temp);
                            }
                          },
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 67,
                                backgroundColor: AppColors.blueColor,
                                backgroundImage: FileImage(file),
                              ),
                              Positioned(
                                top: 87,
                                left: 97,
                                child: Container(
                                  padding: const EdgeInsets.all(11),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: AppColors.colorPrimary,
                                  ),
                                  child: const Icon(
                                    Icons.camera_enhance_outlined,
                                    color: AppColors.colorWhite,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: () async {
                          var temp = await widget.itemBloc.picker.pickImage(source: ImageSource.gallery);
                          if (temp != null) {
                            widget.itemBloc.pickedImage.add(temp);
                          }
                        },
                        child: Stack(
                          children: [
                            Neumorphic(
                              padding: const EdgeInsets.all(44),
                              style: NeumorphicStyle(
                                boxShape: const NeumorphicBoxShape.circle(),
                                depth: NeumorphicTheme.embossDepth(context),
                                shadowDarkColorEmboss:
                                    const Color.fromRGBO(0, 0, 0, 0.30196078431372547),
                                shadowLightColorEmboss: AppColors.colorWhite,
                                color: AppColors.colorLightGreen,
                                border: const NeumorphicBorder.none(),
                              ),
                              child: const Icon(
                                Icons.image,
                                color: AppColors.colorPrimary,
                                size: 50,
                              ),
                            ),
                            Positioned(
                              top: 87,
                              left: 97,
                              child: Container(
                                padding: const EdgeInsets.all(11),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: AppColors.colorPrimary,
                                ),
                                child: const Icon(
                                  Icons.camera_enhance_outlined,
                                  color: AppColors.colorWhite,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  StreamBuilder(
                    stream: widget.itemBloc.itemNameTap.stream,
                    builder: (context, snapshot) {
                      return Focus(
                        onFocusChange: (val) {
                          widget.itemBloc.itemNameTap.add(val);
                        },
                        child: Column(
                          children: [
                            AppTextField(
                              isFocused: widget.itemBloc.itemNameTap.value,
                              label: "Item Name".i18n,
                              textEditingController: widget.itemBloc.itemNameController,
                              showError: widget.itemBloc.itemNameShowError.value,
                              validatorFunction: (value) {
                                if (value == null || value.isEmpty) {
                                  widget.itemBloc.itemNameTap.add(widget.itemBloc.itemNameTap.value);
                                  widget.itemBloc.itemNameShowError.add(true);
                                } else {
                                  widget.itemBloc.itemNameTap.add(widget.itemBloc.itemNameTap.value);
                                  widget.itemBloc.itemNameShowError.add(false);
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            StreamBuilder(
                              stream: widget.itemBloc.itemNameShowError,
                              builder: (context, snapshot) {
                                return Visibility(
                                  visible: widget.itemBloc.itemNameShowError.value,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Please Enter Item Name'.i18n,
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
                    stream: widget.itemBloc.skuTap.stream,
                    builder: (context, snapshot) {
                      return Focus(
                        onFocusChange: (val) {
                          widget.itemBloc.skuTap.add(val);
                        },
                        child: Column(
                          children: [
                            AppTextField(
                              isFocused: widget.itemBloc.skuTap.value,
                              label: "SKU",
                              textEditingController: widget.itemBloc.skuController,
                              showError: widget.itemBloc.skuShowError.value,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  widget.itemBloc.generateSku();
                                },
                                child: SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: Padding(
                                    padding: AppPaddingConstants().employeePagePadding,
                                    child: SvgPicture.asset(
                                      icGenerate,
                                      // ignore: deprecated_member_use
                                      color: widget.itemBloc.isSkuGenerated
                                          ? AppColors.defaultGreyColor
                                          : AppColors.colorPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              onChangeFunction: (value) {
                                if (value!.length >= 5) {
                                  widget.itemBloc.checkSku(value);
                                }
                                return null;
                              },
                              validatorFunction: (value) {
                                if (value == null || value.isEmpty) {
                                  widget.itemBloc.skuTap.add(widget.itemBloc.skuTap.value);
                                  widget.itemBloc.skuShowError.add(true);
                                } else {
                                  if (value.length < 5) {
                                    widget.itemBloc.skuErrorMessage =
                                        'SKU should be more than 5 units'.i18n;
                                    widget.itemBloc.skuTap.add(widget.itemBloc.skuTap.value);
                                    widget.itemBloc.skuShowError.add(true);
                                  } else {
                                    widget.itemBloc.skuTap.add(widget.itemBloc.skuTap.value);
                                    widget.itemBloc.skuShowError.add(false);
                                    widget.itemBloc.skuErrorMessage = 'Please Enter SKU'.i18n;
                                  }
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            StreamBuilder(
                              stream: widget.itemBloc.skuShowError,
                              builder: (context, snapshot) {
                                return Visibility(
                                  visible: widget.itemBloc.skuShowError.value,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.itemBloc.skuErrorMessage,
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
                    stream: widget.itemBloc.itemTypeValue,
                    builder: (context, snapshot) {
                      return AppDropdown(
                        hintText: "Item Type".i18n,
                        value: widget.itemBloc.itemTypeValue.valueOrNull,
                        items: widget.itemBloc.resStoreItemTypeCollectionModel.data!.list!
                            .map((ItemTypeCollection item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(
                              item.name!,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (widget.itemBloc.itemTypeValue.value!.id!.compareTo(val!.id!) != 0) {
                            if (val.code!.compareTo("MP") == 0) {
                              widget.itemBloc.itemTypeValue.add(val);
                            } else {
                              alertBox(context, val);
                            }
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ArrowCard(
                    onTap: () {
                      TabNavigatorRouter(
                        navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                        currentPageKey: AppRouteManager.currentPage,
                      ).pushNamed(
                        AppRouteConstants.addItemDepartment,
                        arguments: {"itemBloc": widget.itemBloc},
                      )?.then((value) {
                        RootBloc().changeBottomBarBehaviour(
                          onTap: bottomButtonBehaviour,
                          bottomBarIconPath: null,
                        );
                        if (widget.itemBloc.departmentValue.valueOrNull != null) {
                          widget.itemBloc.itemCategoryValue.add(null);
                          widget.itemBloc.itemSubModuleCategoryValue.add(null);
                        }
                        widget.itemBloc.rebuildPage1.add(true);
                      });
                    },
                    label: Text(
                      widget.itemBloc.departmentValue.valueOrNull != null
                          ? widget.itemBloc.departmentValue.value!.name!
                          : "Department".i18n,
                      style: TextStyle(
                        color: widget.itemBloc.departmentValue.valueOrNull != null
                            ? AppColors.colorBlack
                            : AppColors.colorLightGrey100,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ArrowCard(
                    label: Text(
                      widget.itemBloc.itemCategoryValue.valueOrNull?.name ?? "Category",
                      style: TextStyle(
                        color: widget.itemBloc.itemCategoryValue.valueOrNull != null
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
                        AppRouteConstants.addItemCategory,
                        arguments: {"itemBloc": widget.itemBloc},
                      )?.then((value) {
                        RootBloc().changeBottomBarBehaviour(
                          onTap: bottomButtonBehaviour,
                          bottomBarIconPath: null,
                        );
                        widget.itemBloc.rebuildPage1.add(true);
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ArrowCard(
                    label: Text(
                      widget.itemBloc.itemSubCategoryValue.valueOrNull?.name ?? "Sub Category".i18n,
                      style: TextStyle(
                        color: widget.itemBloc.itemSubCategoryValue.valueOrNull != null
                            ? AppColors.colorBlack
                            : AppColors.colorLightGrey100,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      if (widget.itemBloc.itemCategoryValue.valueOrNull != null) {
                        TabNavigatorRouter(
                          navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                          currentPageKey: AppRouteManager.currentPage,
                        ).pushNamed(
                          AppRouteConstants.addSubItemCategory,
                          arguments: {"itemBloc": widget.itemBloc},
                        )?.then((value) {
                          RootBloc().changeBottomBarBehaviour(
                            onTap: bottomButtonBehaviour,
                            bottomBarIconPath: null,
                          );
                          widget.itemBloc.rebuildPage1.add(true);
                        });
                      } else {
                        AppUtil.showSnackBar(label: "Please select a category".i18n);
                      }
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
      },
    );
  }

  Future<void> alertBox(BuildContext context, ItemTypeCollection val) async {
    bool allowChange = true;
    String message = "As long as you have one package, we can change the item type".i18n;
    if (widget.itemBloc.itemPrimaryPackageList.length > 1) {
      allowChange = false;
      message =
          "Hey! You have more than one ‘Package’. The item type can not be changed from ‘Multiple’ to ‘Standard’. Please remove the added items and try again."
              .i18n;
    }
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text(message),
          content: allowChange ? Text('Are you sure you want to do this?'.i18n) : null,
          actions: [
            Visibility(
              visible: allowChange,
              child: Padding(
                padding: AppPaddingConstants().bottom8,
                child: AppButton(
                  label: "CANCEL".i18n,
                  height: 32,
                  labelColor: AppColors.colorPrimary,
                  color: AppColors.colorWhite,
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                ),
              ),
            ),
            AppButton(
              label: allowChange ? "APPLY".i18n : "OK".i18n,
              height: 32,
              onPressed: () {
                if (allowChange) {
                  widget.itemBloc.itemTypeValue.add(val);
                }
                Navigator.pop(ctx);
              },
            ),
          ],
        );
      },
    );
  }
}
