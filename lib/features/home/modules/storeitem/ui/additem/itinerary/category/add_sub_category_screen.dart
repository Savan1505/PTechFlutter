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
import 'package:ptecpos_mobile/core/widget/app_circle_radio_field.dart';
import 'package:ptecpos_mobile/core/widget/app_dropdown.dart';
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/core/widget/default_loading_widget.dart';
import 'package:ptecpos_mobile/core/widget/error_screen_widget.dart';
import 'package:ptecpos_mobile/core/widget/shimmer_widget.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/bloc/item_bloc.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_category_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/category/model/req_item_sub_category_model.dart';
import 'package:rxdart/rxdart.dart';

class AddSubCategoryScreen extends StatefulWidget {
  final ItemBloc itemBloc;

  const AddSubCategoryScreen({
    super.key,
    required this.itemBloc,
  });

  @override
  State<AddSubCategoryScreen> createState() => _AddSubCategoryScreenState();
}

class _AddSubCategoryScreenState extends State<AddSubCategoryScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    RootBloc().changeBottomBarBehaviour(onTap: buttonTapBehaviour, bottomBarIconPath: icCheck);

    widget.itemBloc.getSubcategory();
  }

  void buttonTapBehaviour() {
    if (widget.itemBloc.itemSubCategoryValue.valueOrNull != null) {
      TabNavigatorRouter(
        navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
        currentPageKey: AppRouteManager.currentPage,
      ).pop();
    } else {
      if (widget.itemBloc.resSubCategoryModel.data?.list?.isNotEmpty ?? false) {
        AppUtil.showSnackBar(label: "Please select a sub category".i18n);
      }
    }
  }

  @override
  Widget build(BuildContext ctx) {
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
              "Select Sub Category".i18n,
              style: AppTextStyle().appBarTextStyle,
            ),
          ],
        ),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: widget.itemBloc.itemSubCategoryState,
        builder: (context, snapshot) {
          if (widget.itemBloc.itemSubCategoryState.value.isLoading()) {
            return const DefaultLoadingWidget();
          } else if (widget.itemBloc.itemSubCategoryState.value.isLoading()) {
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
                      await showCategoryBottomSheet().then((value) {
                        widget.itemBloc.itemSubModuleCategoryValue.add(null);
                      });
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
                            "Add Sub Category".i18n,
                            style: AppTextStyle().darkTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 33,
                  ),
                  Visibility(
                    visible: widget.itemBloc.resSubCategoryModel.data?.list?.isEmpty ?? true,
                    child: Text("No Sub category available".i18n),
                  ),
                  StreamBuilder(
                    stream: widget.itemBloc.itemSubCategoryValue,
                    builder: (context, snapshot) {
                      return ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: widget.itemBloc.resSubCategoryModel.data!.list!.map((e) {
                          return Padding(
                            padding: AppPaddingConstants().bottom25,
                            child: AppCircleRadioOption(
                              value: e,
                              groupValue: widget.itemBloc.itemSubCategoryValue.valueOrNull,
                              text: e.name!,
                              onChanged: (val) {
                                widget.itemBloc.itemSubCategoryValue.add(val);
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

  Future<void> showCategoryBottomSheet() async {
    TextEditingController nameController = TextEditingController();

    BehaviorSubject<bool> nameTap = BehaviorSubject<bool>.seeded(false);
    BehaviorSubject<bool> nameError = BehaviorSubject<bool>.seeded(false);
    BehaviorSubject<bool> categoryError = BehaviorSubject<bool>.seeded(false);

    widget.itemBloc.getItemCategorySubModule();
    AppBottomSheet(
      child: StreamBuilder(
        stream: widget.itemBloc.itemSubmoduleCategoryState,
        builder: (context, snapshot) {
          if (widget.itemBloc.itemSubmoduleCategoryState.value.isLoading()) {
            return buildFilterLoading(context);
          }
          if (widget.itemBloc.itemSubmoduleCategoryState.value.isError()) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text("Error fetching required filters data".i18n),
                const SizedBox(
                  height: 100,
                ),
              ],
            );
          }
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Add Sub Category".i18n,
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
                  stream: widget.itemBloc.itemSubModuleCategoryValue,
                  builder: (context, snapshot) {
                    return AppDropdown(
                      hintText: "Department".i18n,
                      value: widget.itemBloc.itemSubModuleCategoryValue.valueOrNull,
                      items: widget.itemBloc.resItemSubModuleCategoryModel.data!.list!
                          .map((ItemCategory item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item.name!,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        widget.itemBloc.itemSubModuleCategoryValue.add(val!);
                        categoryError.add(false);
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 3,
                ),
                StreamBuilder(
                  stream: categoryError,
                  builder: (context, snapshot) {
                    return Visibility(
                      visible: categoryError.value,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Category is required".i18n,
                          style: AppTextStyle().errorStyle,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                AppButton(
                  label: "ADD".i18n,
                  onPressed: () {
                    _formKey.currentState!.validate();
                    if ((!nameError.value && nameController.text.isNotEmpty)) {
                      if (widget.itemBloc.itemSubModuleCategoryValue.valueOrNull != null) {
                        Navigator.pop(AppRouteManager.navigatorKey.currentContext!);
                        ReqItemSubCategoryModel reqItemSubCategoryModel = ReqItemSubCategoryModel(
                          storeId: RootBloc.store?.id,
                          name: nameController.text,
                          categoryId: widget.itemBloc.itemCategoryValue.value?.id ?? "",
                        );
                        widget.itemBloc.postSubCategory(reqItemSubCategoryModel);
                      } else {
                        categoryError.add(true);
                      }
                    } else {
                      if (widget.itemBloc.itemSubModuleCategoryValue.valueOrNull == null) {
                        categoryError.add(true);
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          );
        },
      ),
    ).showBottomSheet();
  }

  Shimmer buildFilterLoading(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.loadingColor,
      highlightColor: AppColors.loadingLightColor,
      child: ListView.builder(
        itemCount: 6,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, __) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 4,
              child: Column(
                children: [
                  Container(
                    height: 25,
                    width: MediaQuery.of(context).size.width,
                    color: AppColors.colorWhite,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 10,
                    width: MediaQuery.of(context).size.width,
                    color: AppColors.colorWhite,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 10,
                    width: MediaQuery.of(context).size.width,
                    color: AppColors.colorWhite,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 10,
                    width: MediaQuery.of(context).size.width,
                    color: AppColors.colorWhite,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
