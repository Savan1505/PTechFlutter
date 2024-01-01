// ignore_for_file: deprecated_member_use

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/routes/tab_navigator.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/utils/image_path.dart';
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/bloc/item_bloc.dart';
import 'package:rxdart/rxdart.dart';

class ItemPackUpcScreen extends StatefulWidget {
  final ItemBloc itemBloc;

  const ItemPackUpcScreen({
    super.key,
    required this.itemBloc,
  });

  @override
  State<ItemPackUpcScreen> createState() => _ItemPackUpcScreenState();
}

class _ItemPackUpcScreenState extends State<ItemPackUpcScreen> {
  BehaviorSubject<bool> isAddAllowed = BehaviorSubject<bool>.seeded(false);

  @override
  void initState() {
    super.initState();
    RootBloc().changeBottomBarBehaviour(onTap: buttonTapBehaviour, bottomBarIconPath: icCheck);
  }

  @override
  void dispose() {
    isAddAllowed.close();
    super.dispose();
  }

  void buttonTapBehaviour() {
    if (widget.itemBloc.itemPackUpcList.isNotEmpty) {
      TabNavigatorRouter(
        navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
        currentPageKey: AppRouteManager.currentPage,
      ).pop();
    } else {
      AppUtil.showSnackBar(label: "Please create a pack upc");
    }
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Add UPC".i18n,
              style: AppTextStyle().appBarTextStyle,
            ),
          ],
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPaddingConstants().leftRight25,
          child: Column(
            children: [
              const SizedBox(
                height: 33,
              ),
              AppTextField(
                textEditingController: widget.itemBloc.itemPackUpcController,
                label: "Pack UPC".i18n,
                isFocused: false,
                showError: false,
                onChangeFunction: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (value.length >= 6) {
                      isAddAllowed.add(true);
                    } else {
                      isAddAllowed.add(false);
                    }
                  } else {
                    isAddAllowed.add(false);
                  }
                  return null;
                },
                suffixIcon: StreamBuilder(
                  stream: isAddAllowed,
                  builder: (context, snapshot) {
                    if (isAddAllowed.value) {
                      return GestureDetector(
                        onTap: () {
                          widget.itemBloc.addUpc(widget.itemBloc.itemPackUpcController.text);
                        },
                        child: const Icon(
                          Icons.add,
                          color: AppColors.colorPrimary,
                          size: 30,
                        ),
                      );
                    }
                    return GestureDetector(
                      onTap: () {
                        widget.itemBloc.generatePackUpc();
                      },
                      child: SizedBox(
                        height: 16,
                        width: 16,
                        child: Padding(
                          padding: AppPaddingConstants().employeePagePadding,
                          child: SvgPicture.asset(
                            icGenerate,
                            color: AppColors.colorPrimary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 33,
              ),
              StreamBuilder(
                stream: widget.itemBloc.rebuildPackUpcList,
                builder: (context, snapshot) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.itemBloc.itemPackUpcList.length,
                    itemBuilder: (context, index) {
                      var item = widget.itemBloc.itemPackUpcList[index];
                      return Padding(
                        padding: AppPaddingConstants().bottom27,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              icUpcBadge,
                              color: AppColors.colorDarkPrimary,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              item.packUpcName,
                              style: AppTextStyle().darkTextStyle,
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                if (widget.itemBloc.itemPackUpcList.isNotEmpty &&
                                    widget.itemBloc.itemPackUpcList.length != 1) {
                                  widget.itemBloc.itemPackUpcList.removeAt(index);
                                  widget.itemBloc.rebuildPackUpcList.add(true);
                                }
                              },
                              child: SvgPicture.asset(
                                icTrashIcon,
                                color: (widget.itemBloc.itemPackUpcList.isNotEmpty &&
                                        widget.itemBloc.itemPackUpcList.length != 1)
                                    ? AppColors.redColor
                                    : AppColors.defaultGreyColor,
                              ),
                            ),
                          ],
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
    );
  }
}
