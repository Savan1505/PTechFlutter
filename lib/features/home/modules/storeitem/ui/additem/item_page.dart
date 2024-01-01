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
import 'package:ptecpos_mobile/features/home/modules/storeitem/bloc/item_bloc.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/add_item_screen.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/add_item_screen_v2.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/add_item_screen_v3.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends BaseState<ItemPage> {
  bool isTapped = false;
  final ItemBloc itemBloc = ItemBloc();
  late List<Widget> _itemPages = [];

  @override
  void initState() {
    super.initState();
    _itemPages = [
      AddItemPage(
        itemBloc: itemBloc,
        onTap: bottomBarButtonTap,
      ),
      AddItemV2(
        itemBloc: itemBloc,
        onTap: bottomBarButtonTap,
      ),
      AddItemV3(
        itemBloc: itemBloc,
        onTap: bottomBarButtonTap,
      ),
    ];
    RootBloc().changeBottomBarBehaviour(onTap: bottomBarButtonTap, bottomBarIconPath: null);
    itemBloc.initData();
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
            if (itemBloc.currentPageIndex.value == 0) {
              TabNavigatorRouter(
                navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                currentPageKey: AppRouteManager.currentPage,
              ).pop();
              return;
            }
            itemBloc.pageViewController
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
              "Add Items".i18n,
              style: AppTextStyle().appBarTextStyle,
            ),
            Padding(
              padding: AppPaddingConstants().right25,
              child: StreamBuilder(
                stream: itemBloc.currentPageIndex,
                builder: (context, snapshot) {
                  return Text(
                    "${(itemBloc.currentPageIndex.value + 1).toString()}/${_itemPages.length}",
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
        stream: itemBloc.itemPage,
        builder: (context, snapshot) {
          if (itemBloc.itemPage.value.isLoading()) {
            return const DefaultLoadingWidget();
          }
          if (itemBloc.itemPage.value.isError()) {
            return const ErrorWidgetScreen();
          }
          return PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: itemBloc.pageViewController,
            children: _itemPages,
            onPageChanged: (index) {
              itemBloc.currentPageIndex.add(index);
            },
          );
        },
      ),
      extendBody: true,
    );
  }

  @override
  BaseBloc? getBaseBloc() {
    return itemBloc;
  }

  Future<void> bottomBarButtonTap() async {
    if (itemBloc.currentPageIndex.value == 0) {
      itemBloc.formKeyV1.currentState!.validate();
      if (itemBloc.checkV1Validation()) {
        await itemBloc.pageViewController.nextPage(
          duration: const Duration(
            milliseconds: 300,
          ),
          curve: Curves.easeIn,
        );
      }
    } else if (itemBloc.currentPageIndex.value == 1) {
      await itemBloc.pageViewController.nextPage(
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeIn,
      );
      RootBloc.bottomBarButtonIconPath = icCheck;
      RootBloc().setBottomBarCurrentItem(RootBloc().getBottomBarCurrentItem().value);
    } else if (itemBloc.currentPageIndex.value == 2) {
      if (itemBloc.itemPrimaryPackageList.isEmpty) {
        AppUtil.showSnackBar(label: "Please create a package".i18n);
      } else {
        itemBloc.addItem();
      }
    }
  }
}
