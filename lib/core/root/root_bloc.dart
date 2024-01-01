import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:ptecpos_mobile/core/base/base_bloc.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/utils/image_path.dart';
import 'package:ptecpos_mobile/core/utils/route_constants.dart';
import 'package:ptecpos_mobile/features/store/data/model/res_storeitems_model.dart';
import 'package:rxdart/rxdart.dart';

class RootBloc extends BaseBloc {
  static final BehaviorSubject<BottomBarItem> _currentIndex =
      BehaviorSubject<BottomBarItem>.seeded(BottomBarItem.home);

  static final ZoomDrawerController _zoomDrawerController = ZoomDrawerController();

  static BehaviorSubject<SidebarItem> currentDrawerIndex =
      BehaviorSubject<SidebarItem>.seeded(SidebarItem.dashboard);

  /// Use this variables to set the onTap and the icon path from any of the screen you want
  static void Function() bottomBarMainButtonOnTap = () {
    AppRouteManager.pushNamedAndRemoveUntil(
      AppRouteConstants.store,
      (route) => false,
    );
  };
  static String? bottomBarButtonIconPath = icExchange;

  /// Padding all around the icon Do not use this variable
  static double paddingButtonValue = 6;

  ///------------------------------------

  /// Store Id from the store pages
  static StoreListElement? store;

  ZoomDrawerController getDrawerController() {
    return _zoomDrawerController;
  }

  void openDrawer() {
    _zoomDrawerController.toggle!();
  }

  BehaviorSubject<BottomBarItem> getBottomBarCurrentItem() {
    return _currentIndex;
  }

  void setBottomBarCurrentItem(BottomBarItem value) {
    _currentIndex.add(value);
  }

  static void resetBottomBarStyles({bool callSubject = false}) {
    bottomBarMainButtonOnTap = () {
      AppRouteManager.pushNamedAndRemoveUntil(
        AppRouteConstants.store,
        (route) => false,
      );
    };
    paddingButtonValue = 6;
    bottomBarButtonIconPath = icExchange;
    if (callSubject) {
      _currentIndex.add(_currentIndex.value);
    }
  }

  /// Change the bottom behaviour according to the screen
  void changeBottomBarBehaviour({
    required void Function() onTap,
    String? bottomBarIconPath,
    double? paddingButton,
  }) {
    bottomBarMainButtonOnTap = onTap;
    bottomBarButtonIconPath = bottomBarIconPath;
    paddingButtonValue = paddingButton ?? 6;
    _currentIndex.add(_currentIndex.value);
  }
}

enum SidebarItem { dashboard, items, reports, employee }

extension ToSideBarIndex on SidebarItem {
  int toIndex() {
    switch (this) {
      case SidebarItem.dashboard:
        return 0;
      case SidebarItem.items:
        return 1;
      case SidebarItem.employee:
        return 2;
      case SidebarItem.reports:
        return 3;
    }
  }
}

extension ToIndex on BottomBarItem {
  int toIndex() {
    switch (this) {
      case BottomBarItem.home:
        return 0;
      case BottomBarItem.reports:
        return 1;
      case BottomBarItem.pos:
        return 2;
      case BottomBarItem.settings:
        return 3;
    }
  }
}

enum BottomBarItem { home, reports, pos, settings }
