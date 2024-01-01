// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:ptecpos_mobile/core/widget/module_card.dart';
import 'package:ptecpos_mobile/core/widget/update_card.dart';
import 'package:ptecpos_mobile/features/home/bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage> with SingleTickerProviderStateMixin {
  final HomeBloc homeBloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),

            ///App bar
            Padding(
              padding: AppPaddingConstants().leftRight25,
              child: buildAppBar(),
            ),

            /// Chart widget
            buildChart(context),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: AppPaddingConstants().leftRight25,
              child: Row(
                children: [
                  Text(
                    "Updates".i18n,
                    style: const TextStyle(
                      color: AppColors.colorBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Today, 5 June 2023",
                    style: AppTextStyle().homeStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            buildUpdatesList(),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: AppPaddingConstants().leftRight25,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Other".i18n, style: AppTextStyle().homeStyle2),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: AppPaddingConstants().leftRight25,
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        ModuleCard(
                          onTap: () {
                            RootBloc.currentDrawerIndex.add(SidebarItem.items);
                            TabNavigatorRouter(
                              navigatorKey:
                                  AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                              currentPageKey: AppRouteManager.currentPage,
                            ).pushNamed(AppRouteConstants.storeItemScreen)?.then((value) {
                              RootBloc.currentDrawerIndex.add(SidebarItem.dashboard);
                              RootBloc.resetBottomBarStyles(callSubject: true);
                            });
                          },
                          icon: SvgPicture.asset(
                            icItem,
                            height: 35,
                            width: 32,
                          ),
                          label: "Items".i18n,
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        ModuleCard(
                          onTap: () {
                            RootBloc.currentDrawerIndex.add(SidebarItem.employee);
                            TabNavigatorRouter(
                              navigatorKey:
                                  AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                              currentPageKey: AppRouteManager.currentPage,
                            ).pushNamed(AppRouteConstants.employeeListScreen)?.then((value) {
                              RootBloc.currentDrawerIndex.add(SidebarItem.dashboard);
                              RootBloc.resetBottomBarStyles(callSubject: true);
                            });
                          },
                          icon: SvgPicture.asset(
                            icEmployee,
                            height: 35,
                            width: 32,
                          ),
                          label: "Employees".i18n,
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        ModuleCard(
                          applyWidth: false,
                          onTap: () {
                            RootBloc.currentDrawerIndex.add(SidebarItem.employee);
                            TabNavigatorRouter(
                              navigatorKey:
                                  AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                              currentPageKey: AppRouteManager.currentPage,
                            ).pushNamed(AppRouteConstants.tprScreen)?.then((value) {
                              RootBloc.resetBottomBarStyles(callSubject: true);
                            });
                          },
                          icon: SvgPicture.asset(
                            icPriceChange,
                            height: 35,
                            width: 32,
                            color: Colors.black.withAlpha(150),
                          ),
                          label: "Temporary Price Reduction".i18n,
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        ModuleCard(
                          applyWidth: false,
                          onTap: () {
                            TabNavigatorRouter(
                              navigatorKey:
                                  AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                              currentPageKey: AppRouteManager.currentPage,
                            ).pushNamed(AppRouteConstants.quickAccessScreen)?.then((value) {
                              RootBloc.resetBottomBarStyles(callSubject: true);
                            });
                          },
                          icon: SvgPicture.asset(
                            icEmployee,
                            height: 35,
                            width: 32,
                          ),
                          label: "Quick Access Group".i18n,
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        ModuleCard(
                          applyWidth: false,
                          onTap: () {
                            TabNavigatorRouter(
                              navigatorKey:
                                  AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                              currentPageKey: AppRouteManager.currentPage,
                            ).pushNamed(AppRouteConstants.standardDiscountScreen)?.then((value) {
                              RootBloc.resetBottomBarStyles(callSubject: true);
                            });
                          },
                          icon: SvgPicture.asset(
                            icEmployee,
                            height: 35,
                            width: 32,
                          ),
                          label: "Standard Discount".i18n,
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        ModuleCard(
                          applyWidth: false,
                          onTap: () {
                            TabNavigatorRouter(
                              navigatorKey:
                                  AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                              currentPageKey: AppRouteManager.currentPage,
                            ).pushNamed(AppRouteConstants.priceLevelScreen)?.then((value) {
                              RootBloc.resetBottomBarStyles(callSubject: true);
                            });
                          },
                          icon: SvgPicture.asset(
                            icEmployee,
                            height: 35,
                            width: 32,
                          ),
                          label: "Price Levels".i18n,
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 120,
            ),
          ],
        ),
      ),
    );
  }

  SizedBox buildUpdatesList() {
    return SizedBox(
      height: 155,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: AppPaddingConstants().homePageUpdateCardPadding,
          child: Row(
            children: [
              UpdatesCard(
                onPressed: () {},
                value: 50.0,
                label: "Net Sales".i18n,
              ),
              const SizedBox(
                width: 30,
              ),
              UpdatesCard(
                onPressed: () {},
                value: 50.0,
                label: "Net Sales".i18n,
              ),
              const SizedBox(
                width: 30,
              ),
              UpdatesCard(
                onPressed: () {},
                value: 50.0,
                label: "Net Sales".i18n,
              ),
              const SizedBox(
                width: 30,
              ),
              UpdatesCard(
                onPressed: () {},
                value: 50.0,
                label: "Net Sales".i18n,
              ),
              const SizedBox(
                width: 30,
              ),
              UpdatesCard(
                onPressed: () {},
                value: 50.0,
                label: "Net Sales".i18n,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildChart(BuildContext context) {
    return Padding(
      padding: AppPaddingConstants().leftRight25,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: AppUtil.neuMorphicWidget(
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(
              12,
            ),
          ),
          depth: 3,
          topMargin: 7,
          backgroundColor: AppColors.colorSecondary,
          surfaceIntensity: 0.3,
          childWidget: Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.70,
                child: Padding(
                  padding: AppPaddingConstants().all12,
                  child: LineChart(
                    homeBloc.lineChartData(),
                  ),
                ),
              ),
              Padding(
                padding: AppPaddingConstants().all8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Gross Received".i18n,
                      style: AppTextStyle().homeStyle2.copyWith(
                            fontSize: 16,
                          ),
                    ),
                    Text("Average usage: ".i18n),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppUtil().drawerButton(),
        Text(
          "Home".i18n,
          style: AppTextStyle().homeStyle2.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
        ),
        Row(
          children: [
            AppUtil.circularImageWidget(
              iconData: Icons.notifications,
              height: 18,
              paddingAll: 10,
              depth: 0.1,
            ),
            AppUtil.circularImageWidget(
              iconData: Icons.search,
              height: 20,
              paddingAll: 10,
              depth: 0.1,
            ),
          ],
        ),
      ],
    );
  }

  @override
  BaseBloc? getBaseBloc() {
    return homeBloc;
  }
}
