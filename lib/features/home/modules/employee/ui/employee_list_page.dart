import 'dart:io';

import 'package:flutter/services.dart';
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
import 'package:ptecpos_mobile/core/widget/app_bottom_sheet.dart';
import 'package:ptecpos_mobile/core/widget/app_button.dart';
import 'package:ptecpos_mobile/core/widget/app_radio_field.dart';
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/core/widget/custom_textfield_widget.dart';
import 'package:ptecpos_mobile/core/widget/default_loading_widget.dart';
import 'package:ptecpos_mobile/core/widget/employee_card.dart';
import 'package:ptecpos_mobile/core/widget/error_screen_widget.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/bloc/employee_list_bloc.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/model/res_employee_model.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends BaseState<EmployeeListPage> {
  final EmployeeListBloc employeeListBloc = EmployeeListBloc();

  @override
  void initState() {
    super.initState();
    buttonBehaviour();
    employeeListBloc.getEmployee();
    employeeListBloc.scrollController.addListener(employeeListBloc.scrollListener);
  }

  void buttonBehaviour() {
    RootBloc().changeBottomBarBehaviour(
      onTap: () {
        TabNavigatorRouter(
          navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
          currentPageKey: AppRouteManager.currentPage,
        ).pushNamed(AppRouteConstants.employeeScreen)?.then((value) {
          employeeListBloc.getEmployee();
          buttonBehaviour();
        });
      },
      bottomBarIconPath: icPlusIcon,
    );
  }

  @override
  void dispose() {
    RootBloc.resetBottomBarStyles(callSubject: true);
    employeeListBloc.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: StreamBuilder(
        stream: employeeListBloc.employeeState,
        builder: (context, snapshot) {
          if (employeeListBloc.employeeState.value.isLoading()) {
            return const DefaultLoadingWidget();
          }
          if (employeeListBloc.employeeState.value.isError()) {
            return const ErrorWidgetScreen();
          }
          return SingleChildScrollView(
            controller: employeeListBloc.scrollController,
            child: Padding(
              padding: AppPaddingConstants().leftRight25,
              child: Column(
                children: [
                  const SizedBox(
                    height: 32,
                  ),

                  /// App bar
                  buildAppBar(),
                  const SizedBox(
                    height: 28,
                  ),

                  StreamBuilder(
                    stream: employeeListBloc.filterEmployeeState,
                    builder: (context, snapshot) {
                      if (employeeListBloc.filterEmployeeState.value.isLoading()) {
                        return const DefaultLoadingWidget();
                      } else if (employeeListBloc.filterEmployeeState.value.isError()) {
                        return const ErrorWidgetScreen();
                      }
                      if (employeeListBloc.resEmployeeModel.data?.list?.isEmpty ?? true) {
                        return Text("No employee found".i18n);
                      }
                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: employeeListBloc.resEmployeeModel.data!.list!.length,
                            itemBuilder: (ctx, index) {
                              Employee employee = employeeListBloc.resEmployeeModel.data!.list![index];
                              return EmployeeCard(
                                employeeName: employee.firstName!,
                                role: employee.storeRoleName!,
                                logo: employee.image,
                                isPosUser: employee.posUser!,
                                isWebUser: employee.webUser!,
                                isWebUserExist: employee.isWebUserExist!,
                                employee: employee,
                                employeeState: employeeListBloc.employeeState,
                                onEditTap: () {
                                  TabNavigatorRouter(
                                    navigatorKey:
                                        AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                                    currentPageKey: AppRouteManager.currentPage,
                                  ).pushNamed(
                                    AppRouteConstants.employeeScreen,
                                    arguments: {
                                      "employeeId": employee.id,
                                    },
                                  )?.then((value) {
                                    employeeListBloc.getEmployee();
                                    buttonBehaviour();
                                  });
                                },
                                onDeleteTap: () {
                                  // print("ad");
                                },
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          StreamBuilder(
                            stream: employeeListBloc.loadingEmployees,
                            builder: (context, snapshot) {
                              if (employeeListBloc.loadingEmployees.value) {
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

  @override
  BaseBloc? getBaseBloc() {
    return employeeListBloc;
  }

  StreamBuilder buildAppBar() {
    return StreamBuilder(
      stream: employeeListBloc.isSearchEnabled,
      builder: (context, snapshot) {
        if (employeeListBloc.isSearchEnabled.value) {
          return ListTile(
            leading: InkWell(
              onTap: () {
                employeeListBloc.nameController.clear();
                employeeListBloc.isSearchEnabled.add(!employeeListBloc.isSearchEnabled.value);

                if (employeeListBloc.isAppliedClick) {
                  employeeListBloc.filteredEmployee();
                } else {
                  employeeListBloc.searchedFilteredEmployee();
                }
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
              textEditingController: employeeListBloc.nameController,
              textInputAction: TextInputAction.search,
              onChangedMethod: (value) {
                if (employeeListBloc.isAppliedClick) {
                  employeeListBloc.filteredEmployee();
                } else {
                  employeeListBloc.searchedFilteredEmployee();
                }
              },
              suffixIcon: InkWell(
                onTap: () {
                  employeeListBloc.nameController.clear();
                  employeeListBloc.isSearchEnabled.add(!employeeListBloc.isSearchEnabled.value);
                  // if (storeItemBloc.isAppliedClick) {
                  //   storeItemBloc.getItemFilteredData();
                  // } else {
                  //   storeItemBloc.getStoreItem();
                  // }
                  employeeListBloc.isAppliedClick = false;
                  employeeListBloc.getEmployee();
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
            AppUtil().drawerButton(),
            Text(
              "Employees".i18n,
              style: AppTextStyle().employeeTextStyle,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // if (!storeItemBloc.isAppliedClick) {
                    //   storeItemBloc.getFilterData();
                    // }
                    // filterBottomSheet(AppRouteManager.navigatorKey.currentContext!);
                    filterBottomSheet(AppRouteManager.navigatorKey.currentContext!);
                  },
                  child: AppUtil.circularImageWidget(
                    iconData: Icons.filter_list_alt,
                    height: 18,
                    paddingAll: 10,
                    depth: 0.1,
                  ),
                ),
                const SizedBox(
                  width: 7,
                ),
                GestureDetector(
                  onTap: () {
                    employeeListBloc.isSearchEnabled.add(!employeeListBloc.isSearchEnabled.value);
                  },
                  child: AppUtil.circularImageWidget(
                    iconData: Icons.search,
                    height: 20,
                    paddingAll: 10,
                    depth: 0.1,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void filterBottomSheet(BuildContext context) {
    if (!employeeListBloc.isAppliedClick) {
      employeeListBloc.accessValue.add("Web Access".i18n);
    }
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
              employeeListBloc.contactField.add(val);
            },
            child: StreamBuilder(
              stream: employeeListBloc.contactField,
              builder: (context, snapshot) {
                return AppTextField(
                  textEditingController: employeeListBloc.contactController,
                  label: "Contact No.",
                  isFocused: employeeListBloc.contactField.value,
                  showError: false,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: employeeListBloc.accessValue,
            builder: (context, snapshot) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: employeeListBloc.access.map((e) {
                  return Padding(
                    padding: AppPaddingConstants().right8,
                    child: AppRadioOption(
                      groupValue: employeeListBloc.accessValue.value,
                      value: e,
                      text: e,
                      onChanged: (val) {
                        employeeListBloc.accessValue.add(val);
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
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: "RESET".i18n,
                  labelColor: AppColors.colorPrimary,
                  color: AppColors.colorWhite,
                  onPressed: () {
                    employeeListBloc.contactController.clear();
                    employeeListBloc.isAppliedClick = false;
                    Navigator.pop(context);
                    employeeListBloc.getEmployee();
                    // storeItemBloc.isAppliedClick = false;
                    // Navigator.pop(context);
                    // storeItemBloc.resetValue();
                    // storeItemBloc.getStoreItem();
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
                    employeeListBloc.isAppliedClick = true;
                    employeeListBloc.applyFilteredEmployee();
                    Navigator.pop(context);
                    // storeItemBloc.isAppliedClick = true;
                    // Navigator.pop(context);
                    // storeItemBloc.getItemFilteredData();
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
}
