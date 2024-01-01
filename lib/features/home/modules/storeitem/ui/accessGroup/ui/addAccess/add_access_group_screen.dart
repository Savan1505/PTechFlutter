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
import 'package:ptecpos_mobile/core/widget/app_checkbox.dart';
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/core/widget/default_loading_widget.dart';
import 'package:ptecpos_mobile/core/widget/error_screen_widget.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/accessGroup/bloc/add_access_group_bloc.dart';

class AddAccessGroupScreen extends StatefulWidget {
  final String? accessId;

  const AddAccessGroupScreen({super.key, this.accessId});

  @override
  State<AddAccessGroupScreen> createState() => _AddAccessGroupScreenState();
}

class _AddAccessGroupScreenState extends BaseState<AddAccessGroupScreen> {
  final AddAccessGroupBloc groupBloc = AddAccessGroupBloc();

  @override
  void initState() {
    super.initState();
    buttonBehaviour();
    if (widget.accessId != null) {
      groupBloc.getQuickAccess(widget.accessId!);
    }
  }

  void buttonBehaviour() {
    RootBloc().changeBottomBarBehaviour(
      onTap: buttonTap,
      bottomBarIconPath: icCheck,
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
          widget.accessId != null ? "Edit Group".i18n : "Add Group".i18n,
          style: AppTextStyle().appBarTextStyle,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: groupBloc.editAccessState,
        builder: (context, snapshot) {
          if (groupBloc.editAccessState.value.isLoading()) {
            return const DefaultLoadingWidget();
          }
          if (groupBloc.editAccessState.value.isError()) {
            return const ErrorWidgetScreen();
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 27,
                ),
                Container(
                  padding: AppPaddingConstants().topBottom27,
                  decoration: BoxDecoration(
                    color: AppColors.colorLightGreen,
                    border: Border.all(
                      color: AppColors.colorPrimary,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder(
                        stream: groupBloc.ringUpValue,
                        builder: (context, snapshot) {
                          return AppCheckBox(
                            label: "Show On The Ring Up".i18n,
                            value: groupBloc.ringUpValue.value,
                            onChanged: (value) {
                              groupBloc.ringUpValue.add(value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 27,
                ),
                Padding(
                  padding: AppPaddingConstants().leftRight25,
                  child: Column(
                    children: [
                      StreamBuilder(
                        stream: groupBloc.nameTap,
                        builder: (context, snapshot) {
                          return Focus(
                            onFocusChange: (val) {
                              groupBloc.nameTap.add(val);
                            },
                            child: Column(
                              children: [
                                AppTextField(
                                  isFocused: groupBloc.nameTap.value,
                                  label: "Name".i18n,
                                  textEditingController: groupBloc.nameController,
                                  showError: groupBloc.nameError.value,
                                  validatorFunction: (value) {
                                    if (value == null || value.isEmpty) {
                                      groupBloc.nameTap.add(groupBloc.nameTap.value);
                                      groupBloc.nameError.add(true);
                                    } else {
                                      groupBloc.nameTap.add(groupBloc.nameTap.value);
                                      groupBloc.nameError.add(false);
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                StreamBuilder(
                                  stream: groupBloc.nameError,
                                  builder: (context, snapshot) {
                                    return Visibility(
                                      visible: groupBloc.nameError.value,
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
                        height: 27,
                      ),
                      Focus(
                        onFocusChange: (val) {
                          groupBloc.descTap.add(val);
                        },
                        child: StreamBuilder(
                          stream: groupBloc.descTap,
                          builder: (context, snapshot) {
                            return AppTextField(
                              textEditingController: groupBloc.descController,
                              label: "Description".i18n,
                              isFocused: groupBloc.descTap.value,
                              showError: false,
                              maxLines: 5,
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 27,
                      ),
                      GestureDetector(
                        onTap: () {
                          TabNavigatorRouter(
                            navigatorKey:
                                AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                            currentPageKey: AppRouteManager.currentPage,
                          ).pushNamed(
                            AppRouteConstants.searchQuickAccessScreen,
                            arguments: {"groupBloc": groupBloc},
                          )?.then((value) {
                            buttonBehaviour();
                          });
                        },
                        child: Neumorphic(
                          style: const NeumorphicStyle(
                            shape: NeumorphicShape.concave,
                            color: AppColors.colorWhite,
                            surfaceIntensity: 0.02,
                            intensity: 0.43,
                          ),
                          child: Container(
                            height: 52,
                            color: AppColors.colorWhite,
                            child: Row(
                              children: [
                                Padding(
                                  padding: AppPaddingConstants().symmetricH10,
                                  child: const Icon(
                                    Icons.add,
                                    size: 35,
                                    color: AppColors.colorBlack,
                                  ),
                                ),
                                Text(
                                  "Add Items".i18n,
                                  style: AppTextStyle().darkTextStyle,
                                ),
                                const Spacer(),
                                StreamBuilder(
                                  stream: groupBloc.selectedItemList,
                                  builder: (context, snapshot) {
                                    if (groupBloc.selectedItemList.value.isEmpty) {
                                      return const SizedBox.shrink();
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 12.0),
                                      child: Text(
                                        "Selected (%s)"
                                            .i18n
                                            .fill([groupBloc.selectedItemList.value.length.toString()]),
                                        style: const TextStyle(
                                          color: AppColors.colorPrimary,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  BaseBloc? getBaseBloc() {
    return groupBloc;
  }

  void buttonTap() {
    if (groupBloc.nameController.text.isEmpty || groupBloc.selectedItemList.value.isEmpty) {
      if (groupBloc.nameController.text.isEmpty) {
        AppUtil.showSnackBar(label: "Name is required".i18n);
      } else {
        AppUtil.showSnackBar(label: "Select at least one item".i18n);
      }
    } else {
      if (widget.accessId != null) {
        groupBloc.updateQuickAccessGroup(widget.accessId!);
      } else {
        groupBloc.addQuickAccessGroup();
      }
    }
  }
}
