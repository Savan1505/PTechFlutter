import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
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
import 'package:ptecpos_mobile/features/home/modules/storeitem/bloc/item_bloc.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/package/add_item_package_v1.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/package/add_item_package_v2.dart';

class AddItemPackageScreenRoot extends StatefulWidget {
  final ItemBloc itemBloc;
  final bool isMultiPack;

  const AddItemPackageScreenRoot({super.key, required this.itemBloc, this.isMultiPack = false});

  @override
  State<AddItemPackageScreenRoot> createState() => _AddItemPackageScreenRootState();
}

class _AddItemPackageScreenRootState extends State<AddItemPackageScreenRoot> {
  late List<Widget> _itemPages = [];

  @override
  void initState() {
    super.initState();
    widget.itemBloc.currentPackagePageIndex.add(0);
    widget.itemBloc.initPackageData();
    _itemPages = [
      AddItemPackageV1(
        itemBloc: widget.itemBloc,
        isMultiPack: widget.isMultiPack,
      ),
      AddItemPackageV2(
        itemBloc: widget.itemBloc,
        onTap: bottomBarButtonTap,
        isMultiPack: widget.isMultiPack,
      ),
    ];
    RootBloc().changeBottomBarBehaviour(onTap: bottomBarButtonTap, bottomBarIconPath: null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppColors.colorWhite,
        leading: NeumorphicButton(
          margin: const EdgeInsets.all(8),
          padding: EdgeInsets.zero,
          onPressed: () {
            if (widget.itemBloc.currentPackagePageIndex.value == 0) {
              TabNavigatorRouter(
                navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                currentPageKey: AppRouteManager.currentPage,
              ).pop();
              return;
            }
            widget.itemBloc.pageViewPackageController
                .previousPage(
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.easeIn,
            )
                .then((value) {
              RootBloc.bottomBarButtonIconPath = null;
              RootBloc().setBottomBarCurrentItem(RootBloc().getBottomBarCurrentItem().value);
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Add Items",
              style: AppTextStyle().appBarTextStyle,
            ),
            Padding(
              padding: AppPaddingConstants().right25,
              child: StreamBuilder(
                stream: widget.itemBloc.currentPackagePageIndex,
                builder: (context, snapshot) {
                  return Text(
                    "${(widget.itemBloc.currentPackagePageIndex.value + 1).toString()}/${_itemPages.length}",
                    style: AppTextStyle().lightTextStyle100,
                  );
                },
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: widget.itemBloc.packagePageState,
        builder: (context, snapshot) {
          if (widget.itemBloc.packagePageState.value.isLoading()) {
            return const DefaultLoadingWidget();
          } else if (widget.itemBloc.packagePageState.value.isError()) {
            return const ErrorWidgetScreen();
          }
          return PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: widget.itemBloc.pageViewPackageController,
            children: _itemPages,
            onPageChanged: (index) {
              widget.itemBloc.currentPackagePageIndex.add(index);
            },
          );
        },
      ),
    );
  }

  Future<void> bottomBarButtonTap() async {
    if (widget.itemBloc.currentPackagePageIndex.value == 0) {
      widget.itemBloc.formPackageKeyV1.currentState!.validate();
      if (widget.itemBloc.checkPackageV1Validation()) {
        await widget.itemBloc.pageViewPackageController.nextPage(
          duration: const Duration(
            milliseconds: 300,
          ),
          curve: Curves.easeIn,
        );
        RootBloc.bottomBarButtonIconPath = icCheck;
        RootBloc().setBottomBarCurrentItem(RootBloc().getBottomBarCurrentItem().value);
      }
    } else if (widget.itemBloc.currentPackagePageIndex.value == 1) {
      widget.itemBloc.formPackageKeyV2.currentState!.validate();
      if (widget.itemBloc.checkPackageV2Validation()) {
        if (retailCheck() && downByCheck() && coldPriceCheck() && warmPriceCheck()) {
          widget.itemBloc.addPackage();
          AppUtil.showSnackBar(label: "Package have been created".i18n);
          TabNavigatorRouter(
            navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
            currentPageKey: AppRouteManager.currentPage,
          ).pop();
        }
      }
    }
  }

  bool retailCheck() {
    double unitCost = double.parse(
      widget.itemBloc.itemPackageUnitCostController.text.isEmpty
          ? "0.0"
          : double.parse(widget.itemBloc.itemPackageUnitCostController.text).toStringAsFixed(2),
    );
    double retailPrice = double.parse(
      widget.itemBloc.itemRetailPriceController.text.isEmpty
          ? "0.0"
          : double.parse(widget.itemBloc.itemRetailPriceController.text).toStringAsFixed(2),
    );
    double mergePrice = unitCost -
        double.parse(
          widget.itemBloc.itemDownByController.text.isEmpty
              ? "0.0"
              : double.parse(widget.itemBloc.itemDownByController.text).toStringAsFixed(2),
        );
    if (retailPrice > 0) {
      if (mergePrice > retailPrice) {
        AppUtil.showSnackBar(
          label: "The 'Retail Price' can not be less than the 'Unit Cost'".i18n,
        );
      } else {
        return true;
      }
    } else {
      return true;
    }
    widget.itemBloc.itemWarmPriceController.clear();
    widget.itemBloc.itemColdPriceController.clear();
    return false;
  }

  bool downByCheck() {
    if (widget.itemBloc.itemDownByController.text.isNotEmpty) {
      double downByValue =
          double.parse(double.parse(widget.itemBloc.itemDownByController.text).toStringAsFixed(2));
      double unitCost = double.parse(
        widget.itemBloc.itemPackageUnitCostController.text.isEmpty
            ? "0.0"
            : double.parse(widget.itemBloc.itemPackageUnitCostController.text).toStringAsFixed(2),
      );
      if (unitCost < downByValue) {
        AppUtil.showSnackBar(
          label: "Down by price can not be greater than the 'Unit cost'".i18n,
        );
        return false;
      }
    }
    return true;
  }

  bool coldPriceCheck() {
    if (widget.itemBloc.itemColdPriceController.text.isNotEmpty) {
      double retailPrice = double.parse(
        widget.itemBloc.itemRetailPriceController.text.isEmpty
            ? "0.0"
            : double.parse(widget.itemBloc.itemRetailPriceController.text).toStringAsFixed(2),
      );
      double coldPrice =
          double.parse(double.parse(widget.itemBloc.itemColdPriceController.text).toStringAsFixed(2));
      if (retailPrice >= coldPrice) {
        if (coldPrice > 0) {
          AppUtil.showSnackBar(label: ("The 'Cold Price' can not be less than the 'Retail Price'".i18n));
          return false;
        }
      }
    }
    return true;
  }

  bool warmPriceCheck() {
    if (widget.itemBloc.itemWarmPriceController.text.isNotEmpty) {
      double retailPrice = double.parse(
        widget.itemBloc.itemRetailPriceController.text.isEmpty
            ? "0.0"
            : double.parse(widget.itemBloc.itemRetailPriceController.text).toStringAsFixed(2),
      );
      double warmPrice =
          double.parse(double.parse(widget.itemBloc.itemWarmPriceController.text).toStringAsFixed(2));
      if (retailPrice >= warmPrice) {
        if (warmPrice > 0) {
          widget.itemBloc.itemWarmPriceController.text = "0";
          AppUtil.showSnackBar(
            label: "The 'Warm Price' can not be less than the 'Retail Price'".i18n,
          );
          return false;
        }
      }
    }
    return true;
  }
}
