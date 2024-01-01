import 'dart:io';

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/base/base_bloc.dart';
import 'package:ptecpos_mobile/core/base/base_state.dart';
import 'package:ptecpos_mobile/core/domain/datasource/api_manager.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/routes/tab_navigator.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/api_constants.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/utils/image_path.dart';
import 'package:ptecpos_mobile/core/utils/route_constants.dart';
import 'package:ptecpos_mobile/core/widget/app_bottom_sheet.dart';
import 'package:ptecpos_mobile/core/widget/app_button.dart';
import 'package:ptecpos_mobile/core/widget/app_checkbox.dart';
import 'package:ptecpos_mobile/core/widget/app_dropdown.dart';
import 'package:ptecpos_mobile/core/widget/app_radio_field.dart';
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/core/widget/custom_textfield_widget.dart';
import 'package:ptecpos_mobile/core/widget/default_loading_widget.dart';
import 'package:ptecpos_mobile/core/widget/error_screen_widget.dart';
import 'package:ptecpos_mobile/core/widget/item_tile.dart';
import 'package:ptecpos_mobile/core/widget/shimmer_widget.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/bloc/store_item_bloc.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_distrubutor_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_category_collection.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_department_collection_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_scandata_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_storeitem_collectiontype_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_storeitem_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_sub_category_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_taxslab_model.dart';

class StoreItemScreen extends StatefulWidget {
  const StoreItemScreen({super.key});

  @override
  State<StoreItemScreen> createState() => _StoreItemScreenState();
}

class _StoreItemScreenState extends BaseState<StoreItemScreen> {
  final StoreItemBloc storeItemBloc = StoreItemBloc();

  @override
  void initState() {
    super.initState();

    buttonBehaviour();
    storeItemBloc.getStoreItem();
    storeItemBloc.scrollController.addListener(storeItemBloc.scrollListener);
  }

  void buttonBehaviour() {
    RootBloc().changeBottomBarBehaviour(
      onTap: () {
        TabNavigatorRouter(
          navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
          currentPageKey: AppRouteManager.currentPage,
        ).pushNamed(AppRouteConstants.addItemScreen)?.then((value) {
          buttonBehaviour();
          storeItemBloc.getStoreItem();
        });
      },
      bottomBarIconPath: icPlusIcon,
    );
  }

  @override
  void dispose() {
    storeItemBloc.scrollController.dispose();
    storeItemBloc.debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: storeItemBloc.storeItemState,
        builder: (context, snapshot) {
          if (storeItemBloc.storeItemState.value.isLoading()) {
            return const DefaultLoadingWidget();
          }
          if (storeItemBloc.storeItemState.value.isError()) {
            return const ErrorWidgetScreen();
          }
          return SingleChildScrollView(
            controller: storeItemBloc.scrollController,
            child: Padding(
              padding: AppPaddingConstants().leftRight25,
              child: Column(
                children: [
                  const SizedBox(
                    height: 32,
                  ),

                  /// App bar
                  buildAppBar(),
                  const SizedBox(
                    height: 28,
                  ),
                  StreamBuilder(
                    stream: storeItemBloc.selectedItems,
                    builder: (context, snapshot) {
                      if (storeItemBloc.selectedItems.value.isEmpty) {
                        return StreamBuilder(
                          stream: storeItemBloc.searchedStoreItemState,
                          builder: (context, snapshot) {
                            if (storeItemBloc.searchedStoreItemState.value.isLoading()) {
                              return const DefaultLoadingWidget();
                            }
                            if (storeItemBloc.searchedStoreItemState.value.isError()) {
                              return const ErrorWidgetScreen();
                            }
                            return Column(
                              children: [
                                Visibility(
                                  visible: storeItemBloc.resStoreItemModel.data!.list!.isEmpty,
                                  child: Text("No Item Found".i18n),
                                ),
                                ListView.builder(
                                  itemCount: storeItemBloc.resStoreItemModel.data!.list!.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (ctx, index) {
                                    StoreItemElement item =
                                        storeItemBloc.resStoreItemModel.data!.list![index];
                                    return ItemTile(
                                      itemId: item.id!,
                                      itemSku: item.sku!,
                                      storeItemName: item.name!,
                                      onLongPress: (id) {
                                        // RootBloc.bottomBarButtonIconPath = icPOS;
                                        // RootBloc.bottomBarMainButtonOnTap = () {};
                                        // RootBloc().setBottomBarCurrentItem(
                                        //   RootBloc().getBottomBarCurrentItem().value,
                                        // );
                                        //storeItemBloc.selectedItems.add([id]);
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                StreamBuilder(
                                  stream: storeItemBloc.loadingStoreItem,
                                  builder: (context, snapshot) {
                                    if (storeItemBloc.loadingStoreItem.value) {
                                      return const CircularProgressIndicator();
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }

                      ///TO DO: Delete operation of store item
                      return ListView.builder(
                        itemCount: 10,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          return AppUtil.neuMorphicWidget(
                            boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(
                                12,
                              ),
                            ),
                            border: const NeumorphicBorder(
                              color: AppColors.colorTransparent,
                              width: 0.5,
                            ),
                            depth: 9,
                            topMargin: 7,
                            backgroundColor: AppColors.colorSecondary,
                            childWidget: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.colorLightGray,
                                    AppColors.colorSecondary,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [-10, 0.5],
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                leading: AppUtil.circularTextAndImageWidget(
                                  childWidget: AppUtil.circularProfileNameWidget(
                                    profileName: "Text",
                                  ),
                                ),
                                trailing: const SizedBox.shrink(),
                                title: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Item name",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTextStyle.storeHeaderTextStyle,
                                            ),
                                            Text(
                                              "\$0.02",
                                              style: AppTextStyle.storeListTextStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      const Text(
                                        "x 05",
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 28,
                                      ),
                                      const RotatedBox(
                                        quarterTurns: -3,
                                        child: Text(
                                          "8534",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.colorGrey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      extendBody: true,
    );
  }

  StreamBuilder buildAppBar() {
    return StreamBuilder(
      stream: storeItemBloc.isSearchEnabled,
      builder: (context, snapshot) {
        if (storeItemBloc.isSearchEnabled.value) {
          return ListTile(
            leading: InkWell(
              onTap: () {
                storeItemBloc.searchItemController.clear();
                storeItemBloc.isSearchEnabled.add(!storeItemBloc.isSearchEnabled.value);

                if (storeItemBloc.isAppliedClick) {
                  storeItemBloc.getItemFilteredData();
                } else {
                  storeItemBloc.getStoreItem();
                }
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
              textEditingController: storeItemBloc.searchItemController,
              textInputAction: TextInputAction.search,
              onChangedMethod: (value) {
                storeItemBloc.debouncer.run(() {
                  if (storeItemBloc.isAppliedClick) {
                    storeItemBloc.getSearchedItemFilteredData();
                  } else {
                    storeItemBloc.getSearchedStoreItem();
                  }
                });

                // storeBloc.getSearchedStoreItems();
              },
              suffixIcon: InkWell(
                onTap: () {
                  storeItemBloc.searchItemController.clear();
                  storeItemBloc.isSearchEnabled.add(!storeItemBloc.isSearchEnabled.value);
                  if (storeItemBloc.isAppliedClick) {
                    storeItemBloc.getItemFilteredData();
                  } else {
                    storeItemBloc.getStoreItem();
                  }
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
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppUtil().drawerButton(),
            Text(
              "Items".i18n,
              style: const TextStyle(
                color: AppColors.colorBlack,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (!storeItemBloc.isAppliedClick) {
                      storeItemBloc.getFilterData();
                    }
                    filterBottomSheet(AppRouteManager.navigatorKey.currentContext!);
                  },
                  child: AppUtil.circularImageWidget(
                    iconData: Icons.filter_list_alt,
                    height: 18,
                    paddingAll: 10,
                    depth: 0.1,
                  ),
                ),
                const SizedBox(
                  width: 7,
                ),
                GestureDetector(
                  onTap: () {
                    storeItemBloc.isSearchEnabled.add(!storeItemBloc.isSearchEnabled.value);
                  },
                  child: AppUtil.circularImageWidget(
                    iconData: Icons.search,
                    height: 20,
                    paddingAll: 10,
                    depth: 0.1,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  BaseBloc? getBaseBloc() {
    return storeItemBloc;
  }

  void filterBottomSheet(BuildContext context) {
    AppBottomSheet(
      child: StreamBuilder(
        stream: storeItemBloc.filterState,
        builder: (context, snapshot) {
          if (storeItemBloc.filterState.value.isLoading()) {
            return buildFilterLoading(context);
          } else if (storeItemBloc.filterState.value.isError()) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text("Error fetching required filters data".i18n),
                const SizedBox(
                  height: 100,
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                "Filters".i18n,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.colorBlack,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: storeItemBloc.departmentValue,
                builder: (context, snapshot) {
                  return AppDropdown(
                    hintText: "Department".i18n,
                    value: storeItemBloc.departmentValue.valueOrNull,
                    items: storeItemBloc.resItemDepartmentCollectionModel.data!.list!
                        .map((DepartmentCollection item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item.name!,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      storeItemBloc.departmentValue.add(val!);
                      storeItemBloc.getCategory(val.id!);
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: storeItemBloc.categoryValue,
                builder: (context, snapshot) {
                  return AppDropdown(
                    hintText: "Category".i18n,
                    value: storeItemBloc.categoryValue.valueOrNull,
                    items: storeItemBloc.resItemCategoryCollectionModel.data!.list!
                        .map((CategoryCollection item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item.name!,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      storeItemBloc.categoryValue.add(val!);
                      storeItemBloc.getSubcategory(val.id!);
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              buildSubCategoryWidget(),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: storeItemBloc.itemTypeValue,
                builder: (context, snapshot) {
                  return AppDropdown(
                    hintText: "Item Type".i18n,
                    value: storeItemBloc.itemTypeValue.valueOrNull,
                    items: storeItemBloc.resStoreItemTypeCollectionModel.data!.list!
                        .map((ItemTypeCollection item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item.name!,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      storeItemBloc.itemTypeValue.add(val!);
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: storeItemBloc.taxSlabValue,
                builder: (context, snapshot) {
                  return AppDropdown(
                    hintText: "Tax".i18n,
                    value: storeItemBloc.taxSlabValue.valueOrNull,
                    items: storeItemBloc.resTaxSlabModel.data!.list!.map((TaxSlab item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item.name!,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      storeItemBloc.taxSlabValue.add(val!);
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: storeItemBloc.scanDataValue,
                builder: (context, snapshot) {
                  return AppDropdown(
                    hintText: "Scan Data".i18n,
                    value: storeItemBloc.scanDataValue.valueOrNull,
                    items: storeItemBloc.resScanDataModel.data!.list!.map((Scan item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item.name!,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      storeItemBloc.scanDataValue.add(val!);
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Autocomplete(
                displayStringForOption: (val) {
                  return val.name!;
                },
                onSelected: (value) {
                  storeItemBloc.distributorCompanyData = value;
                },
                fieldViewBuilder: (
                  BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted,
                ) {
                  return Focus(
                    onFocusChange: (val) {
                      storeItemBloc.companyFieldFocus.add(val);
                    },
                    child: AppTextField(
                      textEditingController: textEditingController,
                      label: "Distributor Company Name".i18n,
                      isFocused: storeItemBloc.companyFieldFocus.value,
                      showError: false,
                      focusNode: focusNode,
                    ),
                  );
                },
                optionsBuilder: (value) async {
                  List<Distributor> matches = [];
                  try {
                    var res = await ApiManager().dio()!.get(
                      ApiConstants.distributorCompany,
                      queryParameters: {
                        "IncludeInactive": false,
                        "PageSize": 10,
                        "PageNumber": 1,
                        "Usage": 0,
                        "Name": value.text,
                      },
                    );

                    var t = ResDistributorModel.fromJson(res.data);
                    if (t.data?.list?.isNotEmpty ?? false) {
                      matches.addAll(t.data!.list!);
                      matches.retainWhere((element) {
                        return element.name!.toLowerCase().contains(value.text.toLowerCase());
                      });
                    }
                    return matches;
                  } catch (e) {
                    debugPrint(e.toString());
                    return matches;
                  }
                },
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                "Tax Filters".i18n,
                style: const TextStyle(color: AppColors.colorBlack),
              ),
              const SizedBox(
                height: 12,
              ),
              StreamBuilder(
                stream: storeItemBloc.taxValue,
                builder: (context, snapshot) {
                  return Row(
                    children: storeItemBloc.taxFilters.map((e) {
                      return Padding(
                        padding: AppPaddingConstants().right8,
                        child: AppRadioOption(
                          groupValue: storeItemBloc.taxValue.value,
                          value: e,
                          text: e.label,
                          onChanged: (val) {
                            storeItemBloc.taxValue.add(val);
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Other Filters".i18n,
                style: const TextStyle(color: AppColors.colorBlack),
              ),
              const SizedBox(
                height: 12,
              ),
              Column(
                children: storeItemBloc.otherFilters.asMap().entries.map((e) {
                  return StreamBuilder(
                    stream: storeItemBloc.otherFilter[e.key],
                    builder: (context, snapshot) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: AppCheckBox(
                          onChanged: (value) {
                            storeItemBloc.otherFilter[e.key].add(value);
                          },
                          value: storeItemBloc.otherFilter[e.key].value,
                          label: e.value,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: "RESET",
                      labelColor: AppColors.colorBlack,
                      onPressed: () {
                        storeItemBloc.isAppliedClick = false;
                        Navigator.pop(context);
                        storeItemBloc.resetValue();
                        storeItemBloc.getStoreItem();
                      },
                      color: AppColors.colorWhite,
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: AppButton(
                      label: "APPLY".i18n,
                      onPressed: () {
                        storeItemBloc.isAppliedClick = true;
                        Navigator.pop(context);
                        storeItemBloc.getItemFilteredData();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          );
        },
      ),
    ).showBottomSheet();
  }

  Widget buildSubCategoryWidget() {
    return StreamBuilder(
      stream: storeItemBloc.isSubCategoryCalled,
      builder: (context, snapshot) {
        return AppDropdown(
          hintText: "Sub Category".i18n,
          value: storeItemBloc.subCategoryValue.valueOrNull,
          items: storeItemBloc.resSubCategoryModel.data!.list!.map((Subcategory item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item.name ?? "",
              ),
            );
          }).toList(),
          onChanged: (val) {
            storeItemBloc.subCategoryValue.add(val);
            storeItemBloc.isSubCategoryCalled.add(true);
          },
        );
      },
    );
  }

  Shimmer buildFilterLoading(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.loadingColor,
      highlightColor: AppColors.loadingLightColor,
      child: ListView.builder(
        itemCount: 6,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, __) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 4,
              child: Column(
                children: [
                  Container(
                    height: 25,
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
    );
  }
}
