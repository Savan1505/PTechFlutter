import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
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
import 'package:ptecpos_mobile/core/utils/route_constants.dart';
import 'package:ptecpos_mobile/core/widget/access_tile.dart';
import 'package:ptecpos_mobile/core/widget/app_bottom_sheet.dart';
import 'package:ptecpos_mobile/core/widget/app_button.dart';
import 'package:ptecpos_mobile/core/widget/app_checkbox.dart';
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/core/widget/default_loading_widget.dart';
import 'package:ptecpos_mobile/core/widget/error_screen_widget.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/accessGroup/bloc/access_group_bloc.dart';

class AccessGroupScreen extends StatefulWidget {
  const AccessGroupScreen({super.key});

  @override
  State<AccessGroupScreen> createState() => _AccessGroupScreenState();
}

class _AccessGroupScreenState extends BaseState<AccessGroupScreen> {
  final AccessGroupBloc accessGroupBloc = AccessGroupBloc();

  @override
  void initState() {
    super.initState();
    buttonBehaviour();
    accessGroupBloc.initData();
    accessGroupBloc.scrollController.addListener(accessGroupBloc.scrollListener);
  }

  void buttonBehaviour() {
    RootBloc().changeBottomBarBehaviour(
      onTap: () {
        TabNavigatorRouter(
          navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
          currentPageKey: AppRouteManager.currentPage,
        ).pushNamed(AppRouteConstants.addQuickAccessScreen)?.then((value) {
          buttonBehaviour();
          accessGroupBloc.initData();
        });
      },
      bottomBarIconPath: icPlusIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: StreamBuilder(
        stream: accessGroupBloc.accessState,
        builder: (context, snapshot) {
          if (accessGroupBloc.accessState.value.isLoading()) {
            return const DefaultLoadingWidget();
          }
          if (accessGroupBloc.accessState.value.isError()) {
            return const ErrorWidgetScreen();
          }
          return SingleChildScrollView(
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
                    stream: accessGroupBloc.filterAccessState,
                    builder: (context, snapshot) {
                      if (accessGroupBloc.filterAccessState.value.isLoading()) {
                        return const DefaultLoadingWidget();
                      }
                      if (accessGroupBloc.filterAccessState.value.isError()) {
                        return const ErrorWidgetScreen();
                      }
                      if (accessGroupBloc.resAccessGroupModel.data?.list?.isEmpty ?? true) {
                        return Text("No item found".i18n);
                      }
                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: accessGroupBloc.resAccessGroupModel.data!.list!.length,
                            itemBuilder: (ctx, index) {
                              var item = accessGroupBloc.resAccessGroupModel.data!.list![index];

                              return AccessTile(
                                onDeleteTap: () {
                                  alertBox(id: item.id!, context: context, delete: item.active ?? false);
                                },
                                onEditTap: () {
                                  if (item.active ?? false) {
                                    TabNavigatorRouter(
                                      navigatorKey: AppRouteManager
                                          .rootNavigatorKeys[AppRouteManager.currentPage]!,
                                      currentPageKey: AppRouteManager.currentPage,
                                    ).pushNamed(
                                      AppRouteConstants.addQuickAccessScreen,
                                      arguments: {
                                        "accessId": item.id,
                                      },
                                    )?.then((value) {
                                      buttonBehaviour();
                                      accessGroupBloc.initData();
                                    });
                                  } else {
                                    AppUtil.showSnackBar(label: "This group is inactive".i18n);
                                  }
                                },
                                storeItemName: item.name!,
                                itemCount: item.itemCount.toString(),
                                isActive: item.active ?? true,
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          StreamBuilder(
                            stream: accessGroupBloc.loadingAccess,
                            builder: (context, snapshot) {
                              if (accessGroupBloc.loadingAccess.value) {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Quick Access Groups".i18n,
          style: AppTextStyle().employeeTextStyle,
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (!accessGroupBloc.isAppliedClicked) {
                  accessGroupBloc.resetValue();
                }
                showFilterBottomSheet();
              },
              child: NeumorphicIcon(
                Icons.filter_list_alt,
                style: const NeumorphicStyle(
                  color: AppColors.colorBlack,
                  depth: 0.1,
                ),
                size: 18,
              ),
            ),
            const SizedBox(
              width: 7,
            ),
          ],
        ),
      ],
    );
  }

  void showFilterBottomSheet() {
    AppBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "Filters".i18n,
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.colorBlack,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Focus(
            onFocusChange: (val) {
              accessGroupBloc.nameTap.add(val);
            },
            child: StreamBuilder(
              stream: accessGroupBloc.nameTap,
              builder: (context, snapshot) {
                return AppTextField(
                  textEditingController: accessGroupBloc.nameController,
                  label: "Quick Access Group Name".i18n,
                  isFocused: accessGroupBloc.nameTap.value,
                  showError: false,
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder(
            stream: accessGroupBloc.includeInactive,
            builder: (context, snapshot) {
              return AppCheckBox(
                value: accessGroupBloc.includeInactive.value,
                onChanged: (value) {
                  accessGroupBloc.includeInactive.add(value);
                },
                label: "Include Inactive".i18n,
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: "RESET".i18n,
                  labelColor: AppColors.colorPrimary,
                  color: AppColors.colorWhite,
                  onPressed: () {
                    AppRouteManager.pop();
                    accessGroupBloc.resetValue();
                    accessGroupBloc.initData();
                  },
                ),
              ),
              const SizedBox(
                width: 25,
              ),
              Expanded(
                child: AppButton(
                  label: "APPLY".i18n,
                  onPressed: () {
                    AppRouteManager.pop();
                    accessGroupBloc.getFilterData();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    ).showBottomSheet();
  }

  @override
  BaseBloc? getBaseBloc() {
    return accessGroupBloc;
  }

  Future<void> alertBox({required BuildContext context, required String id, bool delete = false}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text(delete ? 'Remove Quick Access Group ?'.i18n : 'Undo Quick Access Group ?'.i18n),
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
                accessGroupBloc.undoDeleteAccess(id: id, delete: delete);
              },
              height: 32,
            ),
          ],
        );
      },
    );
  }
}
