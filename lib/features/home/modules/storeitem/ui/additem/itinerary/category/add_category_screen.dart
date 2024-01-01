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
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_department_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/category/model/req_item_category_dept_model.dart';
import 'package:rxdart/rxdart.dart';

class AddCategoryScreen extends StatefulWidget {
  final ItemBloc itemBloc;

  const AddCategoryScreen({
    super.key,
    required this.itemBloc,
  });

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    RootBloc().changeBottomBarBehaviour(onTap: buttonTapBehaviour, bottomBarIconPath: icCheck);
    widget.itemBloc.getItemCategory();
  }

  void buttonTapBehaviour() {
    if (widget.itemBloc.itemCategoryValue.valueOrNull != null) {
      TabNavigatorRouter(
        navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
        currentPageKey: AppRouteManager.currentPage,
      ).pop();
    } else {
      AppUtil.showSnackBar(label: "Please select a category".i18n);
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
              "Select Category".i18n,
              style: AppTextStyle().appBarTextStyle,
            ),
          ],
        ),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: widget.itemBloc.itemCategoryState,
        builder: (context, snapshot) {
          if (widget.itemBloc.itemCategoryState.value.isLoading()) {
            return const DefaultLoadingWidget();
          } else if (widget.itemBloc.itemCategoryState.value.isError()) {
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
                        widget.itemBloc.itemCategoryDepartment.add(null);
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
                            "Add Category".i18n,
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
                    visible: widget.itemBloc.resItemCategoryModel.data?.list?.isEmpty ?? true,
                    child: Text("No category available".i18n),
                  ),
                  StreamBuilder(
                    stream: widget.itemBloc.itemCategoryValue,
                    builder: (context, snapshot) {
                      return ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: widget.itemBloc.resItemCategoryModel.data!.list!.map((e) {
                          return Padding(
                            padding: AppPaddingConstants().bottom25,
                            child: AppCircleRadioOption(
                              value: e,
                              groupValue: widget.itemBloc.itemCategoryValue.valueOrNull,
                              text: e.name!,
                              onChanged: (val) {
                                widget.itemBloc.itemCategoryValue.add(val);
                                widget.itemBloc.itemSubCategoryValue.add(null);
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

    widget.itemBloc.getItemDepartmentCategory();

    await AppBottomSheet(
      child: StreamBuilder<Object>(
        stream: widget.itemBloc.itemCategoryDepartmentState,
        builder: (context, snapshot) {
          if (widget.itemBloc.itemCategoryDepartmentState.value.isLoading()) {
            return buildFilterLoading(context);
          }
          if (widget.itemBloc.itemCategoryDepartmentState.value.isError()) {
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
                  "Add Category".i18n,
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
                  stream: widget.itemBloc.itemCategoryDepartment,
                  builder: (context, snapshot) {
                    return AppDropdown(
                      hintText: "Department".i18n,
                      value: widget.itemBloc.itemCategoryDepartment.valueOrNull,
                      items: widget.itemBloc.resItemDepartmentCategoryModel.data!.list!
                          .map((ItemDepartment item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item.name!,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        widget.itemBloc.itemCategoryDepartment.add(val!);
                      },
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
                      Navigator.pop(AppRouteManager.navigatorKey.currentContext!);
                      ReqItemCategoryDeptModel reqItemCategoryDeptModel = ReqItemCategoryDeptModel(
                        name: nameController.text,
                        storeId: RootBloc.store?.id,
                        itemDeptId: widget.itemBloc.itemCategoryDepartment.valueOrNull?.id ?? "",
                      );
                      widget.itemBloc.postCategory(reqItemCategoryDeptModel);
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
