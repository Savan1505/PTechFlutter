import 'package:flutter/material.dart';
import 'package:ptecpos_mobile/core/routes/app_observer.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/utils/route_constants.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/ui/standard_discount_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/ui/employee_list_page.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/ui/employee_page.dart';
import 'package:ptecpos_mobile/features/home/modules/price/ui/price_level_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/accessGroup/ui/access_group_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/accessGroup/ui/addAccess/add_access_group_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/accessGroup/ui/addAccess/quick_item_list_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/accessGroup/ui/addAccess/search_access_group_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/item_page.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/abv/add_abv_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/category/add_category_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/category/add_sub_category_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/department/add_department_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/department/add_tax_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/family/add_family_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/flavour/add_flavour_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/package/add_item_package_screen_root.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/package/item_pack_upc_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/package/item_package_price.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/package/item_package_price_level.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/package/item_package_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/regions/add_region_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/tax/add_tax_slab_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/triggers/triggers_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/vintage/add_vintage_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/store_item_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/ui/add_tpr_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/ui/tpr_screen.dart';
import 'package:ptecpos_mobile/features/home/ui/pages/home_page.dart';
import 'package:ptecpos_mobile/features/pos/ui/pages/pos_page.dart';
import 'package:ptecpos_mobile/features/reports/ui/pages/reports_page.dart';
import 'package:ptecpos_mobile/features/settings/ui/pages/settings_page.dart';

class TabNavigatorRouter extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final PageKeys currentPageKey;

  const TabNavigatorRouter({
    super.key,
    required this.navigatorKey,
    required this.currentPageKey,
  });

  @override
  Widget build(BuildContext context) {
    late Widget child;
    switch (currentPageKey) {
      case PageKeys.homeKey:
        child = const HomePage();
        break;
      case PageKeys.reportsKey:
        child = const ReportPage();
        break;
      case PageKeys.posKey:
        child = const PosPage();
        break;
      case PageKeys.settingsKey:
        child = const SettingsPage();
        break;
    }

    return Navigator(
      key: navigatorKey,
      observers: [AppObserver(pageKey: currentPageKey)],
      onGenerateRoute: (routeSettings) {
        Map<String, dynamic>? args = routeSettings.arguments as Map<String, dynamic>?;

        switch (routeSettings.name) {
          case AppRouteConstants.storeItemScreen:
            return MaterialPageRoute(
              builder: (context) => const StoreItemScreen(),
              settings: const RouteSettings(
                name: AppRouteConstants.storeItemScreen,
              ),
            );
          case AppRouteConstants.storeHomeScreen:
            return MaterialPageRoute(
              builder: (context) => const HomePage(),
              settings: const RouteSettings(
                name: AppRouteConstants.storeHomeScreen,
              ),
            );
          case AppRouteConstants.employeeScreen:
            return MaterialPageRoute(
              builder: (context) => EmployeePage(
                employeeId: args?["employeeId"],
              ),
              settings: const RouteSettings(
                name: AppRouteConstants.storeHomeScreen,
              ),
            );
          case AppRouteConstants.employeeListScreen:
            return MaterialPageRoute(
              builder: (context) => const EmployeeListPage(),
              settings: const RouteSettings(
                name: AppRouteConstants.employeeListScreen,
              ),
            );
          case AppRouteConstants.addItemScreen:
            return MaterialPageRoute(
              builder: (context) => const ItemPage(),
              settings: const RouteSettings(
                name: AppRouteConstants.addItemScreen,
              ),
            );
          case AppRouteConstants.addItemDepartment:
            return MaterialPageRoute(
              builder: (context) => AddItemDepartmentScreen(
                itemBloc: args?["itemBloc"],
              ),
              settings: const RouteSettings(
                name: AppRouteConstants.addItemDepartment,
              ),
            );
          case AppRouteConstants.addTax:
            return MaterialPageRoute(
              builder: (context) => AddTaxScreen(
                itemBloc: args?["itemBloc"],
              ),
              settings: const RouteSettings(
                name: AppRouteConstants.addTax,
              ),
            );
          case AppRouteConstants.addItemCategory:
            return MaterialPageRoute(
              builder: (context) => AddCategoryScreen(
                itemBloc: args?["itemBloc"],
              ),
              settings: const RouteSettings(
                name: AppRouteConstants.addItemCategory,
              ),
            );
          case AppRouteConstants.addSubItemCategory:
            return MaterialPageRoute(
              builder: (context) => AddSubCategoryScreen(
                itemBloc: args?["itemBloc"],
              ),
              settings: const RouteSettings(
                name: AppRouteConstants.addSubItemCategory,
              ),
            );
          case AppRouteConstants.addItemRegionsScreen:
            return MaterialPageRoute(
              builder: (context) => AddRegionsScreen(
                itemBloc: args?["itemBloc"],
              ),
              settings: const RouteSettings(
                name: AppRouteConstants.addItemRegionsScreen,
              ),
            );
          case AppRouteConstants.addAbvScreen:
            return MaterialPageRoute(
              builder: (context) => AddAbvScreen(
                itemBloc: args?["itemBloc"],
              ),
              settings: const RouteSettings(
                name: AppRouteConstants.addAbvScreen,
              ),
            );
          case AppRouteConstants.addFlavourScreen:
            return MaterialPageRoute(
              builder: (context) => AddFlavourScreen(
                itemBloc: args?["itemBloc"],
              ),
              settings: const RouteSettings(
                name: AppRouteConstants.addFlavourScreen,
              ),
            );
          case AppRouteConstants.addFamilyScreen:
            return MaterialPageRoute(
              builder: (context) => AddFamilyScreen(
                itemBloc: args?["itemBloc"],
              ),
              settings: const RouteSettings(
                name: AppRouteConstants.addFamilyScreen,
              ),
            );
          case AppRouteConstants.addVintageScreen:
            return MaterialPageRoute(
              builder: (context) => AddVintageScreen(
                itemBloc: args?["itemBloc"],
              ),
              settings: const RouteSettings(
                name: AppRouteConstants.addVintageScreen,
              ),
            );
          case AppRouteConstants.addItemTaxSlabScreen:
            return MaterialPageRoute(
              builder: (context) => AddTaxSlabScreen(
                itemBloc: args?["itemBloc"],
              ),
              settings: const RouteSettings(
                name: AppRouteConstants.addItemTaxSlabScreen,
              ),
            );
          case AppRouteConstants.itemTriggerScreen:
            return MaterialPageRoute(
              builder: (context) => TriggersScreen(
                itemBloc: args?["itemBloc"],
              ),
              settings: const RouteSettings(
                name: AppRouteConstants.itemTriggerScreen,
              ),
            );
          case AppRouteConstants.itemPackageScreen:
            return MaterialPageRoute(
              builder: (context) => ItemPackageScreen(
                itemBloc: args?["itemBloc"],
              ),
              settings: const RouteSettings(
                name: AppRouteConstants.itemPackageScreen,
              ),
            );
          case AppRouteConstants.itemRootPackageScreen:
            return MaterialPageRoute(
              builder: (context) => AddItemPackageScreenRoot(
                itemBloc: args?["itemBloc"],
              ),
              settings: const RouteSettings(
                name: AppRouteConstants.itemRootPackageScreen,
              ),
            );
          case AppRouteConstants.itemPackUpcScreen:
            return MaterialPageRoute(
              builder: (context) => ItemPackUpcScreen(
                itemBloc: args?["itemBloc"],
              ),
              settings: const RouteSettings(
                name: AppRouteConstants.itemPackUpcScreen,
              ),
            );
          case AppRouteConstants.itemPackagePriceLevelScreen:
            return MaterialPageRoute(
              builder: (context) => ItemPackagePriceLevel(
                itemBloc: args?["itemBloc"],
              ),
              settings: const RouteSettings(
                name: AppRouteConstants.itemPackagePriceLevelScreen,
              ),
            );
          case AppRouteConstants.itemPackagePriceScreen:
            return MaterialPageRoute(
              builder: (context) => ItemPackagePrice(
                itemBloc: args?["itemBloc"],
              ),
              settings: const RouteSettings(
                name: AppRouteConstants.itemPackagePriceScreen,
              ),
            );
          case AppRouteConstants.tprScreen:
            return MaterialPageRoute(
              builder: (context) => const TprScreen(),
              settings: const RouteSettings(
                name: AppRouteConstants.tprScreen,
              ),
            );
          case AppRouteConstants.addTprScreen:
            return MaterialPageRoute(
              builder: (context) => AddTprScreen(
                id: args?["id"],
              ),
              settings: const RouteSettings(
                name: AppRouteConstants.addTprScreen,
              ),
            );
          case AppRouteConstants.quickAccessScreen:
            return MaterialPageRoute(
              builder: (context) => const AccessGroupScreen(),
              settings: const RouteSettings(
                name: AppRouteConstants.quickAccessScreen,
              ),
            );
          case AppRouteConstants.addQuickAccessScreen:
            return MaterialPageRoute(
              builder: (context) => AddAccessGroupScreen(
                accessId: args?["accessId"],
              ),
              settings: const RouteSettings(
                name: AppRouteConstants.addQuickAccessScreen,
              ),
            );
          case AppRouteConstants.searchQuickAccessScreen:
            return MaterialPageRoute(
              builder: (context) => SearchAccessGroupScreen(
                groupBloc: args?["groupBloc"],
              ),
              settings: const RouteSettings(
                name: AppRouteConstants.searchQuickAccessScreen,
              ),
            );
          case AppRouteConstants.quickItemListScreen:
            return MaterialPageRoute(
              builder: (context) => QuickItemListScreen(
                groupBloc: args?["groupBloc"],
              ),
              settings: const RouteSettings(
                name: AppRouteConstants.quickItemListScreen,
              ),
            );
          case AppRouteConstants.standardDiscountScreen:
            return MaterialPageRoute(
              builder: (context) => const StandardDiscountScreen(),
              settings: const RouteSettings(
                name: AppRouteConstants.standardDiscountScreen,
              ),
            );
          case AppRouteConstants.priceLevelScreen:
            return MaterialPageRoute(
              builder: (context) => const PriceLevelScreen(),
              settings: const RouteSettings(
                name: AppRouteConstants.priceLevelScreen,
              ),
            );
        }
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }

  Future<T?>? pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  Future<T?>? popAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return navigatorKey.currentState?.popAndPushNamed(routeName, result: result, arguments: arguments);
  }

  Future<T?>? pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      newRouteName,
      predicate,
      arguments: arguments,
    );
  }

  void popUntil(int popNumber) {
    for (int i = 0; i < popNumber; i++) {
      navigatorKey.currentState?.pop();
    }
  }

  void pop<T extends Object?>() {
    return navigatorKey.currentState?.pop();
  }

  BuildContext? getContext() {
    return navigatorKey.currentState?.context;
  }
}
