import 'dart:io';

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/base/base_bloc.dart';
import 'package:ptecpos_mobile/core/base/base_state.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/utils/image_path.dart';
import 'package:ptecpos_mobile/core/utils/route_constants.dart';
import 'package:ptecpos_mobile/core/utils/user_util.dart';
import 'package:ptecpos_mobile/core/widget/custom_list_tile_widget.dart';
import 'package:ptecpos_mobile/core/widget/custom_textfield_widget.dart';
import 'package:ptecpos_mobile/core/widget/default_loading_widget.dart';
import 'package:ptecpos_mobile/core/widget/error_screen_widget.dart';
import 'package:ptecpos_mobile/core/widget/shimmer_widget.dart';
import 'package:ptecpos_mobile/features/store/data/model/res_storeitems_model.dart';
import 'package:ptecpos_mobile/features/store/presentation/bloc/store_bloc.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends BaseState<StorePage> {
  final StoreBloc storeBloc = StoreBloc();

  @override
  void initState() {
    super.initState();
    storeBloc.getStoreItems();
    storeBloc.scrollController.addListener(storeBloc.scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    storeBloc.debouncer.dispose();
    storeBloc.scrollController.dispose();
    storeBloc.searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorPrimary,
      body: StreamBuilder(
        stream: storeBloc.storeState,
        builder: (context, snapshot) {
          if (storeBloc.storeState.value.isLoading()) {
            return const DefaultLoadingWidget();
          }
          if (storeBloc.storeState.value.isError()) {
            return const ErrorWidgetScreen();
          }
          return AppUtil.neuMorphicWidget(
            backgroundColor: AppColors.colorBackGround,
            topMargin: TextSelectionToolbar.kHandleSize,
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
            childWidget: SafeArea(
              child: Column(
                children: [
                  /// App bar of the screen
                  appBar(),

                  /// body of the screen
                  StreamBuilder(
                    stream: storeBloc.searchedStoreState,
                    builder: (context, snapshot) {
                      if (storeBloc.searchedStoreState.value.isLoading()) {
                        return Expanded(
                          child: AppUtil.neuMorphicWidget(
                            backgroundColor: AppColors.colorBackGround,
                            topMargin: TextSelectionToolbar.kHandleSize,
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
                            childWidget: Padding(
                              padding: AppPaddingConstants().storePagePadding,
                              child: Shimmer.fromColors(
                                baseColor: AppColors.loadingColor,
                                highlightColor: AppColors.loadingLightColor,
                                child: ListView.builder(
                                  itemCount: 6,
                                  itemBuilder: (_, __) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Material(
                                        elevation: 4,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 100,
                                              width: MediaQuery.of(context).size.width,
                                              color: AppColors.colorWhite,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context).size.width,
                                              color: AppColors.colorWhite,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context).size.width,
                                              color: AppColors.colorWhite,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context).size.width,
                                              color: AppColors.colorWhite,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      if (storeBloc.storeState.value.isError()) {
                        return const ErrorWidgetScreen();
                      }
                      return Expanded(
                        child: Column(
                          children: [
                            Visibility(
                              visible: storeBloc.storeItemModel.listStoreElement!.isEmpty,
                              child: Text("No store found".i18n),
                            ),
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  storeBloc.getStoreItems();
                                  await Future.delayed(Duration.zero);
                                },
                                child: SingleChildScrollView(
                                  controller: storeBloc.scrollController,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: storeBloc.storeItemModel.listStoreElement!.length,
                                    itemBuilder: (ctx, index) {
                                      StoreListElement storeElement =
                                          storeBloc.storeItemModel.listStoreElement![index];
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: CustomListTileWidget(
                                          logo: storeElement.logo,
                                          header: storeElement.name,
                                          decodeLogo: AppUtil.convertStringToUint8List(
                                            storeElement.logo?.split(",").last,
                                          ),
                                          logoName:
                                              "${storeElement.firstName?.trim().substring(0, 1)}${storeElement.lastName?.trim().substring(0, 1)}",
                                          subTitle:
                                              "${storeElement.cityName}, ${storeElement.stateName}, ${storeElement.countryName}",
                                          onTapAdmin: () {
                                            AppRouteManager.pushNamed(
                                              AppRouteConstants.root,
                                              arguments: {"store": storeElement},
                                            );
                                          },
                                          onTapPos: () {
                                            debugPrint("pos ${storeElement.name}");
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            StreamBuilder(
                              stream: storeBloc.loadingStoreItem,
                              builder: (context, snapshot) {
                                if (storeBloc.loadingStoreItem.value) {
                                  return const CircularProgressIndicator();
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  StreamBuilder<bool> appBar() {
    return StreamBuilder(
      stream: storeBloc.isSearchEnabled.stream,
      builder: (context, snapshot) {
        if (storeBloc.isSearchEnabled.value) {
          return ListTile(
            leading: InkWell(
              onTap: () {
                storeBloc.searchController.clear();
                storeBloc.getStoreItems();
                storeBloc.isSearchEnabled.add(!storeBloc.isSearchEnabled.value);
              },
              child: Container(
                margin: const EdgeInsets.only(
                  left: 15,
                  right: 10,
                ),
                child: AppUtil.circularImageWidget(
                  iconData: Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios_new_rounded,
                  height: 20,
                  paddingAll: 10,
                  depth: 2,
                ),
              ),
            ),
            horizontalTitleGap: -20,
            contentPadding: const EdgeInsets.all(
              -20,
            ),
            title: CustomTextFieldWidget(
              left: 20,
              right: 10,
              hint: "searchHere".i18n,
              textEditingController: storeBloc.searchController,
              textInputAction: TextInputAction.search,
              onChangedMethod: (value) {
                storeBloc.debouncer.run(() {
                  storeBloc.getSearchedStoreItems();
                });
              },
              suffixIcon: InkWell(
                onTap: () {
                  storeBloc.searchController.clear();
                  storeBloc.getStoreItems();
                  storeBloc.isSearchEnabled.add(!storeBloc.isSearchEnabled.value);
                },
                child: AppUtil.circularImageWidget(
                  iconData: Icons.close,
                  height: 20,
                  paddingAll: 10,
                  depth: 0,
                ),
              ),
            ),
          );
        }
        return ListTile(
          leading: AppUtil.circularImageWidget(
            icAssetsSVG: icProfilePlaceHolder,
            depth: 2,
            height: 40,
          ),
          horizontalTitleGap: 10,
          title: Text(
            "Hello ${UserUtil.profileModel.firstName ?? ""}",
            maxLines: 1,
            style: AppTextStyle.storeTextStyle,
          ),
          trailing: InkWell(
            splashColor: AppColors.colorTransparent,
            highlightColor: AppColors.colorTransparent,
            hoverColor: AppColors.colorTransparent,
            onTap: () {
              storeBloc.isSearchEnabled.add(!storeBloc.isSearchEnabled.value);
            },
            child: AppUtil.circularImageWidget(
              iconData: Icons.search,
              height: 20,
              paddingAll: 10,
              depth: 0.1,
            ),
          ),
        );
      },
    );
  }

  @override
  BaseBloc? getBaseBloc() {
    return storeBloc;
  }
}
