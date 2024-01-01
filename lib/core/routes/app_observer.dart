import 'package:flutter/material.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';

///This is our own App navigator observer that will observe the adding or removing of the routes accordingly

class AppObserver extends NavigatorObserver {
  late PageKeys pageKey;

  AppObserver({required this.pageKey});

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route.settings.name?.isNotEmpty ?? false) {
      AppRouteManager.tabRoutes[pageKey]?.add(route.settings.name!);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (route.settings.name?.isNotEmpty ?? false) {
      AppRouteManager.tabRoutes[pageKey]?.remove(route.settings.name ?? '');
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    if (route.settings.name?.isNotEmpty ?? false) {
      AppRouteManager.tabRoutes[pageKey]?.remove(route.settings.name);
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (newRoute == null) return;
    if (newRoute.settings.name?.isNotEmpty ?? false) {
      final index =
          AppRouteManager.tabRoutes[pageKey]?.indexWhere((element) => newRoute.settings.name == element);
      AppRouteManager.tabRoutes[pageKey]![index!] = newRoute.settings.name!;
    }
  }
}
