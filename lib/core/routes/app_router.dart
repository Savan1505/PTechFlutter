import 'package:flutter/material.dart';
import 'package:ptecpos_mobile/core/root/root_page.dart';
import 'package:ptecpos_mobile/core/routes/tab_navigator.dart';
import 'package:ptecpos_mobile/core/utils/route_constants.dart';
import 'package:ptecpos_mobile/features/authentication/ui/pages/login_page.dart';
import 'package:ptecpos_mobile/features/authentication/ui/pages/splash_page.dart';
import 'package:ptecpos_mobile/features/store/presentation/pages/store_page.dart';

class AppRouteManager {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static List<PageKeys> pageKeys = [
    PageKeys.homeKey,
    PageKeys.reportsKey,
    PageKeys.posKey,
    PageKeys.settingsKey,
  ];
  static PageKeys currentPage = PageKeys.homeKey;
  static String currentRouteName = "/";

  static final Map<PageKeys, GlobalKey<NavigatorState>> rootNavigatorKeys = {
    PageKeys.homeKey: GlobalKey<NavigatorState>(),
    PageKeys.reportsKey: GlobalKey<NavigatorState>(),
    PageKeys.posKey: GlobalKey<NavigatorState>(),
    PageKeys.settingsKey: GlobalKey<NavigatorState>(),
  };

  ///This will keep record of the routes in the stack of a particular key
  static Map<PageKeys, List<String>> tabRoutes = {
    PageKeys.homeKey: [],
    PageKeys.reportsKey: [],
    PageKeys.posKey: [],
    PageKeys.settingsKey: [],
  };

  static PageRoute onGenerateRoute(RouteSettings settings) {
    Map<String, dynamic>? args = settings.arguments as Map<String, dynamic>?;
    switch (settings.name) {
      case AppRouteConstants.splash:
        return MaterialPageRoute(
          builder: (context) => const SplashPage(),
          settings: const RouteSettings(
            name: AppRouteConstants.splash,
          ),
        );
      case AppRouteConstants.login:
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
          settings: const RouteSettings(
            name: AppRouteConstants.login,
          ),
        );
      case AppRouteConstants.store:
        return MaterialPageRoute(
          builder: (context) => const StorePage(),
          settings: const RouteSettings(
            name: AppRouteConstants.store,
          ),
        );
      case AppRouteConstants.root:
        return MaterialPageRoute(
          builder: (context) => RootPage(
            store: args?["store"],
          ),
          settings: const RouteSettings(
            name: AppRouteConstants.root,
          ),
        );
    }
    return MaterialPageRoute(
      builder: (context) => const Center(
        child: Text('404!!'),
      ),
    );
  }

  static Future<T?>? pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    currentRouteName = routeName;
    return navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  static Future<T?>? pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    currentRouteName = newRouteName;
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      newRouteName,
      predicate,
      arguments: arguments,
    );
  }

  static void pop<T extends Object?>() {
    return navigatorKey.currentState?.pop();
  }

  static BuildContext getCurrentContext() {
    if (currentRouteName != AppRouteConstants.root) {
      return navigatorKey.currentState!.context;
    } else {
      var ctx = TabNavigatorRouter(
        navigatorKey: rootNavigatorKeys[currentPage]!,
        currentPageKey: currentPage,
      ).getContext();
      if (ctx != null) {
        return ctx;
      }
      return navigatorKey.currentState!.context;
    }
  }
}

enum PageKeys { homeKey, reportsKey, posKey, settingsKey }
