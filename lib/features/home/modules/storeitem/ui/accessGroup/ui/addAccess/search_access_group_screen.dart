import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/routes/tab_navigator.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';
import 'package:ptecpos_mobile/core/utils/image_path.dart';
import 'package:ptecpos_mobile/core/utils/route_constants.dart';
import 'package:ptecpos_mobile/core/widget/app_button.dart';
import 'package:ptecpos_mobile/core/widget/app_dropdown.dart';
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/core/widget/default_loading_widget.dart';
import 'package:ptecpos_mobile/core/widget/error_screen_widget.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/accessGroup/bloc/add_access_group_bloc.dart';

class SearchAccessGroupScreen extends StatefulWidget {
  final AddAccessGroupBloc groupBloc;

  const SearchAccessGroupScreen({
    super.key,
    required this.groupBloc,
  });

  @override
  State<SearchAccessGroupScreen> createState() => _SearchAccessGroupScreenState();
}

class _SearchAccessGroupScreenState extends State<SearchAccessGroupScreen> {
  @override
  void initState() {
    super.initState();
    buttonBehaviour();
    widget.groupBloc.searchInitData();
  }

  void buttonBehaviour() {
    RootBloc().changeBottomBarBehaviour(
      onTap: () async {
        if (await widget.groupBloc.navigateToListScreenCheck()) {
          TabNavigatorRouter(
            navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
            currentPageKey: AppRouteManager.currentPage,
          ).pushNamed(
            AppRouteConstants.quickItemListScreen,
            arguments: {
              "groupBloc": widget.groupBloc,
            },
          )?.then((value) {
            buttonBehaviour();
            widget.groupBloc.searchInitData();
            if (!widget.groupBloc.areItemSelected) {
              var t = widget.groupBloc.selectedItemList.value;
              t.clear();
              widget.groupBloc.selectedItemList.add(t);
            }
          });
        }
      },
      bottomBarIconPath: icCheck,
      paddingButton: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorGrey100,
        elevation: 0,
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
        title: Text(
          "Search Item".i18n,
          style: AppTextStyle().appBarTextStyle,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: widget.groupBloc.accessState,
        builder: (context, snapshot) {
          if (widget.groupBloc.accessState.value.isLoading()) {
            return const DefaultLoadingWidget();
          }
          if (widget.groupBloc.accessState.value.isError()) {
            return const ErrorWidgetScreen();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: AppPaddingConstants().leftRight25,
              child: Column(
                children: [
                  const SizedBox(
                    height: 27,
                  ),
                  StreamBuilder(
                    stream: widget.groupBloc.itemNameTap,
                    builder: (context, snapshot) {
                      return Focus(
                        onFocusChange: (val) {
                          widget.groupBloc.itemNameTap.add(val);
                        },
                        child: AppTextField(
                          isFocused: widget.groupBloc.itemNameTap.value,
                          label: "Store Item name".i18n,
                          textEditingController: widget.groupBloc.itemNameController,
                          showError: false,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 27,
                  ),
                  StreamBuilder(
                    stream: widget.groupBloc.itemDepartmentValue,
                    builder: (context, snapshot) {
                      return AppDropdown(
                        hintText: "Department".i18n,
                        value: widget.groupBloc.itemDepartmentValue.valueOrNull,
                        items: widget.groupBloc.resItemDepartmentModel.data!.list!.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(
                              item.name!,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          widget.groupBloc.itemDepartmentValue.add(val);
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 27,
                  ),
                  StreamBuilder(
                    stream: widget.groupBloc.itemCategoryValue,
                    builder: (context, snapshot) {
                      return AppDropdown(
                        hintText: "Category".i18n,
                        value: widget.groupBloc.itemCategoryValue.valueOrNull,
                        items: widget.groupBloc.resItemCategoryModel.data!.list!.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(
                              item.name!,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          widget.groupBloc.itemCategoryValue.add(val);
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 27,
                  ),
                  StreamBuilder(
                    stream: widget.groupBloc.itemSubCategoryValue,
                    builder: (context, snapshot) {
                      return AppDropdown(
                        hintText: "Sub Category".i18n,
                        value: widget.groupBloc.itemSubCategoryValue.valueOrNull,
                        items: widget.groupBloc.resSubCategoryModel.data!.list!.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(
                              item.name!,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          widget.groupBloc.itemSubCategoryValue.add(val);
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 27,
                  ),
                  AppButton(
                    label: "RESET".i18n,
                    onPressed: () {
                      widget.groupBloc.resetFilter();
                    },
                    color: AppColors.colorWhite,
                    labelColor: AppColors.colorPrimary,
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
