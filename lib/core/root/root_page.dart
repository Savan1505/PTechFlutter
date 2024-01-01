import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:ptecpos_mobile/core/base/base_bloc.dart';
import 'package:ptecpos_mobile/core/base/base_state.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/routes/tab_navigator.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/widget/custom_bottombar_widget.dart';
import 'package:ptecpos_mobile/core/widget/custom_drawer_widget.dart';
import 'package:ptecpos_mobile/features/store/data/model/res_storeitems_model.dart';

class RootPage extends StatefulWidget {
  final StoreListElement? store;

  const RootPage({super.key, this.store});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends BaseState<RootPage> {
  final RootBloc rootBloc = RootBloc();

  @override
  void initState() {
    super.initState();
    if (widget.store != null) {
      RootBloc.store = widget.store;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab = await AppRouteManager
            .rootNavigatorKeys[AppRouteManager.currentPage]?.currentState
            ?.maybePop();

        if (!isFirstRouteInCurrentTab!) {
          if (AppRouteManager.currentPage != PageKeys.homeKey) {
            rootBloc.setBottomBarCurrentItem(BottomBarItem.home);
            RootBloc.currentDrawerIndex.add(SidebarItem.dashboard);
            _selectTab(PageKeys.homeKey);
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return !isFirstRouteInCurrentTab;
      },
      child: ZoomDrawer(
        controller: RootBloc().getDrawerController(),
        angle: 0.0,
        mainScreenScale: 0,
        slideWidth: 330,
        androidCloseOnBackTap: true,
        mainScreenTapClose: true,
        style: DrawerStyle.style3,
        disableDragGesture: true,
        menuBackgroundColor: AppColors.colorPrimary,
        menuScreen: const CustomDrawerWidget(),
        mainScreen: Scaffold(
          backgroundColor: AppColors.colorPrimary,
          drawerEnableOpenDragGesture: false,
          extendBody: true,
          drawer: const CustomDrawerWidget(),
          body: SafeArea(
            bottom: false,
            child: AppUtil.neuMorphicWidget(
              backgroundColor: AppColors.colorBackGround,
              boxShape: NeumorphicBoxShape.roundRect(
                const BorderRadius.only(
                  topLeft: Radius.circular(
                    20,
                  ),
                  topRight: Radius.circular(
                    20,
                  ),
                ),
              ),
              depth: -5,
              childWidget: StreamBuilder(
                stream: rootBloc.getBottomBarCurrentItem(),
                builder: (context, snapshot) {
                  return Stack(
                    children: [
                      _buildOffstageNavigator(PageKeys.homeKey),
                      _buildOffstageNavigator(PageKeys.reportsKey),
                      _buildOffstageNavigator(PageKeys.posKey),
                      _buildOffstageNavigator(PageKeys.settingsKey),
                    ],
                  );
                },
              ),
            ),
          ),
          bottomNavigationBar: StreamBuilder<Object>(
            stream: rootBloc.getBottomBarCurrentItem(),
            builder: (context, snapshot) {
              return BottomBarWidget(
                onButtonPress: RootBloc.bottomBarMainButtonOnTap,
                buttonIconPath: RootBloc.bottomBarButtonIconPath,
                paddingButton: RootBloc.paddingButtonValue,
                onHomeBtnPress: () {
                  rootBloc.setBottomBarCurrentItem(BottomBarItem.home);
                  RootBloc.currentDrawerIndex.add(SidebarItem.dashboard);
                  _selectTab(PageKeys.homeKey);
                },
                onReportsBtnPress: () {
                  rootBloc.setBottomBarCurrentItem(BottomBarItem.reports);
                  RootBloc.currentDrawerIndex.add(SidebarItem.reports);
                  _selectTab(PageKeys.reportsKey);
                },
                onPosBtnPress: () {
                  rootBloc.setBottomBarCurrentItem(BottomBarItem.pos);
                  _selectTab(PageKeys.posKey);
                },
                onSettingsBtnPress: () {
                  rootBloc.setBottomBarCurrentItem(BottomBarItem.settings);
                  _selectTab(PageKeys.settingsKey);
                },
                currentItem: rootBloc.getBottomBarCurrentItem().value,
              );
            },
          ),
        ),

        // drawerShadowsBackgroundColor: Colors.grey[300]!,
        // slideWidth: MediaQuery.of(context).size.width*.65,
        // openCurve: Curves.fastOutSlowIn,
        // closeCurve: Curves.bounceIn,
        // style: DrawerStyle.style1,
      ),
    );
  }

  void _selectTab(PageKeys pageItem) {
    if (pageItem == AppRouteManager.currentPage) {
      AppRouteManager.rootNavigatorKeys[pageItem]?.currentState?.popUntil((route) => route.isFirst);
    } else {
      AppRouteManager.currentPage =
          AppRouteManager.pageKeys[rootBloc.getBottomBarCurrentItem().value.toIndex()];
      AppRouteManager.rootNavigatorKeys[pageItem]?.currentState?.popUntil((route) => route.isFirst);
      rootBloc.getBottomBarCurrentItem().add(rootBloc.getBottomBarCurrentItem().value);
    }
    RootBloc.resetBottomBarStyles();
  }

  Widget _buildOffstageNavigator(PageKeys currentItem) {
    return Offstage(
      offstage: AppRouteManager.currentPage != currentItem,
      child: TabNavigatorRouter(
        navigatorKey: AppRouteManager.rootNavigatorKeys[currentItem]!,
        currentPageKey: currentItem,
      ),
    );
  }

  @override
  BaseBloc? getBaseBloc() {
    return rootBloc;
  }
}
