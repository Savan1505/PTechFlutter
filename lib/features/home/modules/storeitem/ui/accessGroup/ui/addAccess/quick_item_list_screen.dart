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
import 'package:ptecpos_mobile/core/widget/selected_item_tile.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_storeitem_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/accessGroup/bloc/add_access_group_bloc.dart';

class QuickItemListScreen extends StatefulWidget {
  final AddAccessGroupBloc groupBloc;

  const QuickItemListScreen({super.key, required this.groupBloc});

  @override
  State<QuickItemListScreen> createState() => _QuickItemListScreenState();
}

class _QuickItemListScreenState extends State<QuickItemListScreen> {
  @override
  void initState() {
    super.initState();
    buttonBehaviour();
  }

  void buttonBehaviour() {
    RootBloc().changeBottomBarBehaviour(
      onTap: () {
        if(widget.groupBloc.selectedItemList.value.isNotEmpty) {
          widget.groupBloc.areItemSelected = true;
          TabNavigatorRouter(
            navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
            currentPageKey: AppRouteManager.currentPage,
          ).popUntil(2);
        }
        else {
          AppUtil.showSnackBar(label: "Select at least one item".i18n);
        }
        
      },
      bottomBarIconPath: icCheck
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorGrey100,
        elevation: 0,
        leading: NeumorphicButton(
          margin: const EdgeInsets.all(8),
          padding: EdgeInsets.zero,
          onPressed: () {
            widget.groupBloc.areItemSelected = false;
            TabNavigatorRouter(
              navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
              currentPageKey: AppRouteManager.currentPage,
            ).pop();
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
        title: StreamBuilder(
          stream: widget.groupBloc.selectedItemList,
          builder: (context, snapshot) {
            if (widget.groupBloc.selectedItemList.value.isNotEmpty) {
              return Text(
                "Selected Items(%s)"
                    .i18n
                    .fill([widget.groupBloc.selectedItemList.value.length.toString()]),
                style: AppTextStyle().appBarTextStyle,
              );
            }
            return Text(
              "Select Items".i18n,
              style: AppTextStyle().appBarTextStyle,
            );
          },
        ),
        actions: [
          GestureDetector(
            onTap: () {
              if (widget.groupBloc.selectedItemList.value.length ==
                  widget.groupBloc.resStoreItemModel.data!.list!.length) {
                List<StoreItemElement> t = widget.groupBloc.selectedItemList.value;
                t.clear();
                widget.groupBloc.selectedItemList.add(t);
              } else {
                List<StoreItemElement> t = widget.groupBloc.selectedItemList.value;
                t.clear();
                t.addAll(widget.groupBloc.resStoreItemModel.data!.list!);
                widget.groupBloc.selectedItemList.add(t);
              }
            },
            child: StreamBuilder(
              stream: widget.groupBloc.selectedItemList,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: (widget.groupBloc.selectedItemList.value.length ==
                          widget.groupBloc.resStoreItemModel.data!.list!.length)
                      ? const Icon(
                          Icons.circle,
                          color: AppColors.colorPrimary,
                        )
                      : const Icon(
                          Icons.circle_outlined,
                          color: AppColors.colorPrimary,
                        ),
                );
              },
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: () {
          widget.groupBloc.areItemSelected = false;
          return Future.value(true);
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: AppPaddingConstants().leftRight25,
            child: Column(
              children: [
                StreamBuilder(
                  stream: widget.groupBloc.selectedItemList,
                  builder: (context, snapshot) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.groupBloc.resStoreItemModel.data!.list!.length,
                      itemBuilder: (context, index) {
                        var item = widget.groupBloc.resStoreItemModel.data!.list![index];
                        return GestureDetector(
                          onTap: () {
                            if (widget.groupBloc.selectedItemList.value.contains(item)) {
                              List<StoreItemElement> t = widget.groupBloc.selectedItemList.value;
                              t.remove(item);
                              widget.groupBloc.selectedItemList.add(t);
                            } else {
                              widget.groupBloc.selectedItemList.add([item]);
                            }
                          },
                          child: SelectedItemTile(
                            itemId: item.id!,
                            itemSku: item.sku!,
                            storeItemName: item.name!,
                            isSelected: widget.groupBloc.selectedItemList.value.contains(item),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
