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
import 'package:ptecpos_mobile/core/widget/default_loading_widget.dart';
import 'package:ptecpos_mobile/core/widget/error_screen_widget.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/bloc/employee_bloc.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/ui/add_employee_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/ui/add_employee_screen_v2.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/ui/add_employee_screen_v3.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/ui/add_employee_screen_v4.dart';

class EmployeePage extends StatefulWidget {
  final String? employeeId;

  const EmployeePage({super.key, this.employeeId});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends BaseState<EmployeePage> {
  bool isTapped = false;
  final EmployeeBloc employeeBloc = EmployeeBloc();
  late List<Widget> _employeePages = [];

  @override
  void initState() {
    super.initState();
    employeeBloc.initData(widget.employeeId);
    _employeePages = [
      AddEmployeePage(
        employeeBloc: employeeBloc,
      ),
      AddEmployeeV2(
        employeeBloc: employeeBloc,
      ),
      AddEmployeeV3(
        employeeBloc: employeeBloc,
      ),
      AddEmployeeV4(
        employeeBloc: employeeBloc,
      ),
    ];
    RootBloc().changeBottomBarBehaviour(onTap: bottomBarButtonTap, bottomBarIconPath: null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorWhite,
        leading: NeumorphicButton(
          margin: const EdgeInsets.all(8),
          padding: EdgeInsets.zero,
          onPressed: () {
            if (employeeBloc.currentPageIndex.value == 0) {
              TabNavigatorRouter(
                navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                currentPageKey: AppRouteManager.currentPage,
              ).pop();
              return;
            }
            employeeBloc.pageViewController
                .previousPage(
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.easeIn,
            )
                .then((value) {
              RootBloc.bottomBarButtonIconPath = null;
              RootBloc().setBottomBarCurrentItem(RootBloc().getBottomBarCurrentItem().value);
              // employeeBloc.buildBottomBar.add(true);
            });
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
        centerTitle: true,
        title: Text(
          (widget.employeeId != null) ? "Edit Employee".i18n : "Add Employee".i18n,
          style: AppTextStyle().appBarTextStyle,
        ),
        actions: [
          Center(
            child: Padding(
              padding: AppPaddingConstants().right25,
              child: StreamBuilder(
                stream: employeeBloc.currentPageIndex,
                builder: (context, snapshot) {
                  return Text(
                    "${(employeeBloc.currentPageIndex.value + 1).toString()}/4",
                    style: AppTextStyle().lightTextStyle100,
                  );
                },
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: employeeBloc.employeeState,
        builder: (context, snapshot) {
          if (employeeBloc.employeeState.value.isLoading()) {
            return const DefaultLoadingWidget();
          }
          if (employeeBloc.employeeState.value.isError()) {
            return const ErrorWidgetScreen();
          }
          return PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: employeeBloc.pageViewController,
            children: _employeePages,
            onPageChanged: (index) {
              employeeBloc.currentPageIndex.add(index);
            },
          );
        },
      ),
      extendBody: true,
    );
  }

  @override
  BaseBloc? getBaseBloc() {
    return employeeBloc;
  }

  Future<void> bottomBarButtonTap() async {
    if (employeeBloc.currentPageIndex.value == 0) {
      employeeBloc.formKeyV1.currentState!.validate();
      if (employeeBloc.checkV1Validation()) {
        await employeeBloc.pageViewController.nextPage(
          duration: const Duration(
            milliseconds: 300,
          ),
          curve: Curves.easeIn,
        );
      }
    } else if (employeeBloc.currentPageIndex.value == 1) {
      // if (employeeBloc.selectedGender.value.compareTo(GenderOption.gender.displayTitle) == 0) {
      //   employeeBloc.genderShowError.add(true);
      // } else {
      //   employeeBloc.genderShowError.add(false);
      // }
      employeeBloc.formKeyV2.currentState!.validate();
      if (employeeBloc.checkV2Validation()) {
        await employeeBloc.pageViewController.nextPage(
          duration: const Duration(
            milliseconds: 300,
          ),
          curve: Curves.easeIn,
        );
      }
    } else if (employeeBloc.currentPageIndex.value == 2) {
      employeeBloc.formKeyV3.currentState!.validate();

      if (employeeBloc.checkV3Validation()) {
        await employeeBloc.pageViewController.nextPage(
          duration: const Duration(
            milliseconds: 300,
          ),
          curve: Curves.easeIn,
        );
        RootBloc.bottomBarButtonIconPath = icCheck;
        RootBloc().setBottomBarCurrentItem(RootBloc().getBottomBarCurrentItem().value);
      }
    } else if (employeeBloc.currentPageIndex.value == 3) {
      employeeBloc.formKeyV4.currentState!.validate();
      if (employeeBloc.checkV4Validation()) {
        employeeBloc.postData();
      } else {
        AppUtil.showSnackBar(
          label: "Please fill all the details".i18n,
        );
      }
    }
  }
}
