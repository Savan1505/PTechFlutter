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
import 'package:ptecpos_mobile/core/widget/app_bottom_sheet.dart';
import 'package:ptecpos_mobile/core/widget/app_button.dart';
import 'package:ptecpos_mobile/core/widget/app_checkbox.dart';
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/core/widget/default_loading_widget.dart';
import 'package:ptecpos_mobile/core/widget/error_screen_widget.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/bloc/item_bloc.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/department/model/req_item_tax_slab_model.dart';
import 'package:rxdart/rxdart.dart';

class AddTaxScreen extends StatefulWidget {
  final ItemBloc itemBloc;

  const AddTaxScreen({super.key, required this.itemBloc});

  @override
  State<AddTaxScreen> createState() => _AddTaxScreenState();
}

class _AddTaxScreenState extends State<AddTaxScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    RootBloc().changeBottomBarBehaviour(onTap: buttonTapBehaviour, bottomBarIconPath: icCheck);
    widget.itemBloc.getItemDeptTax();
  }

  void buttonTapBehaviour() {
    if (widget.itemBloc.taxSlabs.isNotEmpty) {
      bool isAnySelected = false;
      for (var element in widget.itemBloc.taxSlabs) {
        if (element.value.isSelected) {
          isAnySelected = true;
          break;
        }
      }
      if (isAnySelected) {
        TabNavigatorRouter(
          navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
          currentPageKey: AppRouteManager.currentPage,
        ).pop();
      } else {
        AppUtil.showSnackBar(label: "Please select a tax slab".i18n);
      }
    } else {
      AppUtil.showSnackBar(label: "Please select a tax slab".i18n);
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
          onPressed: () async {
            TabNavigatorRouter(
              navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
              currentPageKey: AppRouteManager.currentPage,
            ).pop();
            await Future.delayed(const Duration(milliseconds: 300));
            widget.itemBloc.taxSlabs.clear();
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
              "Apply Tax".i18n,
              style: AppTextStyle().appBarTextStyle,
            ),
          ],
        ),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: widget.itemBloc.itemDepartmentTaxState,
        builder: (context, snapshot) {
          if (widget.itemBloc.itemDepartmentTaxState.value.isLoading()) {
            return const DefaultLoadingWidget();
          } else if (widget.itemBloc.itemDepartmentTaxState.value.isLoading()) {
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
                      await showTaxBottomSheet();
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
                            "Add Tax".i18n,
                            style: AppTextStyle().darkTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 33,
                  ),
                  Column(
                    children: widget.itemBloc.resDeptTaxSlabModel.data!.list!.asMap().entries.map((e) {
                      return StreamBuilder(
                        stream: widget.itemBloc.taxSlabs[e.key],
                        builder: (context, snapshot) {
                          return Padding(
                            padding: AppPaddingConstants().bottom8,
                            child: AppCheckBox(
                              label: e.value.name!,
                              value: widget.itemBloc.taxSlabs[e.key].value.isSelected,
                              onChanged: (value) {
                                var t = widget.itemBloc.taxSlabs[e.key].value;
                                t.isSelected = value;
                                widget.itemBloc.taxSlabs[e.key].add(t);
                              },
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 120,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> showTaxBottomSheet() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController taxSlabController = TextEditingController();
    TextEditingController descController = TextEditingController();

    BehaviorSubject<bool> nameTap = BehaviorSubject<bool>.seeded(false);
    BehaviorSubject<bool> nameError = BehaviorSubject<bool>.seeded(false);

    BehaviorSubject<bool> taxSlabTap = BehaviorSubject<bool>.seeded(false);
    BehaviorSubject<bool> taxSlabError = BehaviorSubject<bool>.seeded(false);

    BehaviorSubject<bool> descTap = BehaviorSubject<bool>.seeded(false);
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
              "Add Tax".i18n,
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
                                "Please enter tax name".i18n,
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
                taxSlabTap.add(val);
              },
              child: StreamBuilder(
                stream: taxSlabTap,
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      AppTextField(
                        textEditingController: taxSlabController,
                        label: "Tax Slab %".i18n,
                        isFocused: taxSlabTap.value,
                        showError: taxSlabError.value,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                        ],
                        validatorFunction: (value) {
                          if (value == null || value.isEmpty) {
                            taxSlabTap.add(taxSlabTap.value);
                            taxSlabError.add(true);
                          } else {
                            taxSlabTap.add(taxSlabTap.value);
                            taxSlabError.add(false);
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      StreamBuilder(
                        stream: taxSlabError,
                        builder: (context, snapshot) {
                          return Visibility(
                            visible: taxSlabError.value,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Tax Slab is required".i18n,
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
                descTap.add(val);
              },
              child: StreamBuilder(
                stream: descTap,
                builder: (context, snapshot) {
                  return AppTextField(
                    textEditingController: descController,
                    label: "Description".i18n,
                    isFocused: descTap.value,
                    showError: false,
                    maxLines: 5,
                  );
                },
              ),
            ),
            const SizedBox(
              height: 27,
            ),
            AppButton(
              label: "ADD".i18n,
              onPressed: () {
                _formKey.currentState!.validate();
                if ((!nameError.value && nameController.text.isNotEmpty) &&
                    (!taxSlabError.value && taxSlabController.text.isNotEmpty)) {
                  {
                    Navigator.pop(AppRouteManager.navigatorKey.currentContext!);
                    ReqItemTaxLabModel reqItemTaxLabModel = ReqItemTaxLabModel(
                      name: nameController.text,
                      description: descController.text,
                      taxSlab: double.tryParse(taxSlabController.text),
                      storeIdList: [RootBloc.store!.id!],
                    );
                    widget.itemBloc.postItemDeptTaxSlab(reqItemTaxLabModel);
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
