// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/routes/tab_navigator.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';
import 'package:ptecpos_mobile/core/utils/image_path.dart';
import 'package:ptecpos_mobile/core/utils/route_constants.dart';
import 'package:ptecpos_mobile/core/utils/user_util.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final RootBloc rootBloc = RootBloc();
    return Scaffold(
      primary: false,
      backgroundColor: AppColors.colorPrimary,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: AppPaddingConstants().left25,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.redColor,
                    backgroundImage: (UserUtil.profileModel.image?.isNotEmpty ?? false)
                        ? MemoryImage(
                            const Base64Decoder().convert(
                              UserUtil.profileModel.image!.split(",").last,
                            ),
                          )
                        : const CachedNetworkImageProvider(icProfileImage) as ImageProvider<Object>?,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Hi ${UserUtil.profileModel.firstName ?? ""}",
                    style: AppTextStyle().sideMenuHeaderStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 28,
            ),
            Container(
              color: AppColors.colorDarkPrimary,
              width: double.infinity,
              child: Padding(
                padding: AppPaddingConstants().sideMenuPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.redColor,
                      backgroundImage: (RootBloc.store?.logo?.isNotEmpty ?? false)
                          ? MemoryImage(
                              const Base64Decoder().convert(
                                RootBloc.store!.logo!.split(",").last,
                              ),
                            )
                          : const CachedNetworkImageProvider(icProfileImage) as ImageProvider<Object>?,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          RootBloc.store?.name ?? "",
                          style: AppTextStyle().sideMenuStoreNameStyle,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${RootBloc.store?.cityName}, ${RootBloc.store?.countryName}",
                          style: AppTextStyle().sideMenuStoreNameStyle.copyWith(
                                color: AppColors.colorLightGreen,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 45,
            ),

            ///Home
            GestureDetector(
              onTap: () {
                RootBloc().openDrawer();
                if (RootBloc.currentDrawerIndex.value != SidebarItem.dashboard) {
                  RootBloc.resetBottomBarStyles();
                  RootBloc.currentDrawerIndex.add(SidebarItem.dashboard);
                  rootBloc.setBottomBarCurrentItem(BottomBarItem.home);
                  if (AppRouteManager.currentPage == PageKeys.homeKey) {
                    AppRouteManager.rootNavigatorKeys[PageKeys.homeKey]?.currentState
                        ?.popUntil((route) => route.isFirst);
                  } else {
                    AppRouteManager.currentPage =
                        AppRouteManager.pageKeys[rootBloc.getBottomBarCurrentItem().value.toIndex()];
                    rootBloc.getBottomBarCurrentItem().add(
                          rootBloc.getBottomBarCurrentItem().value,
                        );
                  }
                }
              },
              child: StreamBuilder(
                stream: RootBloc.currentDrawerIndex,
                builder: (context, snapshot) {
                  if (RootBloc.currentDrawerIndex.value == SidebarItem.dashboard) {
                    return Padding(
                      padding: AppPaddingConstants().right7,
                      child: Container(
                        padding: AppPaddingConstants().sideMenuItemPadding,
                        decoration: const BoxDecoration(
                          color: AppColors.colorWhite,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              icDashboard,
                              color: AppColors.colorBlack,
                            ),
                            const SizedBox(
                              width: 27,
                            ),
                            Text(
                              "Dashboard".i18n,
                              style:
                                  AppTextStyle().sideMenuItemStyle.copyWith(color: AppColors.colorBlack),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: AppPaddingConstants().left10,
                    child: ListTile(
                      leading: SvgPicture.asset(
                        icDashboard,
                        color: AppColors.colorWhite,
                      ),
                      title: Text(
                        "Dashboard".i18n,
                        style: AppTextStyle().sideMenuItemStyle,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.colorWhite,
                        size: 15,
                      ),
                    ),
                  );
                },
              ),
            ),

            ///Items
            GestureDetector(
              onTap: () {
                RootBloc().openDrawer();
                if (RootBloc.currentDrawerIndex.value != SidebarItem.items) {
                  RootBloc.currentDrawerIndex.add(SidebarItem.items);
                  if (AppRouteManager.tabRoutes[AppRouteManager.currentPage]?.isEmpty ?? false) {
                    TabNavigatorRouter(
                      navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                      currentPageKey: AppRouteManager.currentPage,
                    )
                        .pushNamed(
                      AppRouteConstants.storeItemScreen,
                    )
                        ?.then((value) {
                      if (AppRouteManager.tabRoutes[AppRouteManager.currentPage]?.isEmpty ?? false) {
                        getPopRouteCallback();
                      }

                      RootBloc.resetBottomBarStyles();
                    });
                  } else {
                    /// We will pop all the previous routes than push a new one;
                    TabNavigatorRouter(
                      navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                      currentPageKey: AppRouteManager.currentPage,
                    ).popUntil(AppRouteManager.tabRoutes[AppRouteManager.currentPage]!.length);

                    TabNavigatorRouter(
                      navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                      currentPageKey: AppRouteManager.currentPage,
                    )
                        .pushNamed(
                      AppRouteConstants.storeItemScreen,
                    )
                        ?.then((value) {
                      if (AppRouteManager.tabRoutes[AppRouteManager.currentPage]?.isEmpty ?? false) {
                        getPopRouteCallback();
                      }
                      RootBloc.resetBottomBarStyles();
                    });
                  }
                }
              },
              child: StreamBuilder(
                stream: RootBloc.currentDrawerIndex,
                builder: (context, snapshot) {
                  if (RootBloc.currentDrawerIndex.value == SidebarItem.items) {
                    return Padding(
                      padding: AppPaddingConstants().right7,
                      child: Container(
                        padding: AppPaddingConstants().sideMenuItemPadding,
                        decoration: const BoxDecoration(
                          color: AppColors.colorWhite,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              icDashboard,
                              color: AppColors.colorBlack,
                            ),
                            const SizedBox(
                              width: 27,
                            ),
                            Text(
                              "Items".i18n,
                              style:
                                  AppTextStyle().sideMenuItemStyle.copyWith(color: AppColors.colorBlack),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: AppPaddingConstants().left10,
                    child: ListTile(
                      leading: SvgPicture.asset(
                        icDashboard,
                        color: AppColors.colorWhite,
                      ),
                      title: Text(
                        "Items".i18n,
                        style: AppTextStyle().sideMenuItemStyle,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.colorWhite,
                        size: 15,
                      ),
                    ),
                  );
                },
              ),
            ),

            ///Employee
            GestureDetector(
              onTap: () {
                RootBloc().openDrawer();
                if (RootBloc.currentDrawerIndex.value != SidebarItem.employee) {
                  RootBloc.currentDrawerIndex.add(SidebarItem.employee);
                  if (AppRouteManager.tabRoutes[AppRouteManager.currentPage]?.isEmpty ?? false) {
                    TabNavigatorRouter(
                      navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                      currentPageKey: AppRouteManager.currentPage,
                    )
                        .pushNamed(
                      AppRouteConstants.employeeListScreen,
                    )
                        ?.then((value) {
                      if (AppRouteManager.tabRoutes[AppRouteManager.currentPage]?.isEmpty ?? false) {
                        getPopRouteCallback();
                      }
                    });
                  } else {
                    /// We will pop all the previous routes and than push a new one;

                    TabNavigatorRouter(
                      navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                      currentPageKey: AppRouteManager.currentPage,
                    ).popUntil(AppRouteManager.tabRoutes[AppRouteManager.currentPage]!.length);

                    TabNavigatorRouter(
                      navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                      currentPageKey: AppRouteManager.currentPage,
                    )
                        .pushNamed(
                      AppRouteConstants.employeeListScreen,
                    )
                        ?.then((value) {
                      if (AppRouteManager.tabRoutes[AppRouteManager.currentPage]?.isEmpty ?? false) {
                        getPopRouteCallback();
                      }
                    });
                  }
                }
              },
              child: StreamBuilder(
                stream: RootBloc.currentDrawerIndex,
                builder: (context, snapshot) {
                  if (RootBloc.currentDrawerIndex.value == SidebarItem.employee) {
                    return Padding(
                      padding: AppPaddingConstants().right7,
                      child: Container(
                        padding: AppPaddingConstants().sideMenuItemPadding,
                        decoration: const BoxDecoration(
                          color: AppColors.colorWhite,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              icDashboard,
                              color: AppColors.colorBlack,
                            ),
                            const SizedBox(
                              width: 27,
                            ),
                            Text(
                              "Employees".i18n,
                              style:
                                  AppTextStyle().sideMenuItemStyle.copyWith(color: AppColors.colorBlack),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: AppPaddingConstants().left10,
                    child: ListTile(
                      leading: SvgPicture.asset(
                        icDashboard,
                        color: AppColors.colorWhite,
                      ),
                      title: Text(
                        "Employees".i18n,
                        style: AppTextStyle().sideMenuItemStyle,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.colorWhite,
                        size: 15,
                      ),
                    ),
                  );
                },
              ),
            ),

            ///Reports
            GestureDetector(
              onTap: () {
                RootBloc().openDrawer();
                if (RootBloc.currentDrawerIndex.value != SidebarItem.reports) {
                  RootBloc.resetBottomBarStyles();

                  RootBloc.currentDrawerIndex.add(SidebarItem.reports);
                  rootBloc.setBottomBarCurrentItem(BottomBarItem.reports);
                  if (PageKeys.reportsKey == AppRouteManager.currentPage) {
                    AppRouteManager.rootNavigatorKeys[PageKeys.reportsKey]?.currentState
                        ?.popUntil((route) => route.isFirst);
                  } else {
                    AppRouteManager.currentPage =
                        AppRouteManager.pageKeys[rootBloc.getBottomBarCurrentItem().value.toIndex()];
                    rootBloc.getBottomBarCurrentItem().add(rootBloc.getBottomBarCurrentItem().value);
                  }
                }
              },
              child: StreamBuilder(
                stream: RootBloc.currentDrawerIndex,
                builder: (context, snapshot) {
                  if (RootBloc.currentDrawerIndex.value == SidebarItem.reports) {
                    return Padding(
                      padding: AppPaddingConstants().right7,
                      child: Container(
                        padding: AppPaddingConstants().sideMenuItemPadding,
                        decoration: const BoxDecoration(
                          color: AppColors.colorWhite,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              icDashboard,
                              color: AppColors.colorBlack,
                            ),
                            const SizedBox(
                              width: 27,
                            ),
                            Text(
                              "Reports".i18n,
                              style:
                                  AppTextStyle().sideMenuItemStyle.copyWith(color: AppColors.colorBlack),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: AppPaddingConstants().left10,
                    child: ListTile(
                      leading: SvgPicture.asset(
                        icDashboard,
                        color: AppColors.colorWhite,
                      ),
                      title: Text(
                        "Reports".i18n,
                        style: AppTextStyle().sideMenuItemStyle,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.colorWhite,
                        size: 15,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getPopRouteCallback() {
    if (AppRouteManager.currentPage == PageKeys.reportsKey) {
      RootBloc.currentDrawerIndex.add(SidebarItem.reports);
    } else if (AppRouteManager.currentPage == PageKeys.homeKey) {
      RootBloc.currentDrawerIndex.add(SidebarItem.dashboard);
    } else if (AppRouteManager.currentPage == PageKeys.settingsKey) {
      /// drawer current index should be of settings
    } else if (AppRouteManager.currentPage == PageKeys.posKey) {
      /// drawer current index should be of POS
    }
  }
}
