// ignore_for_file: deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/domain/datasource/api_manager.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/routes/tab_navigator.dart';
import 'package:ptecpos_mobile/core/utils/api_constants.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';
import 'package:ptecpos_mobile/core/utils/route_constants.dart';
import 'package:ptecpos_mobile/core/widget/app_button.dart';
import 'package:ptecpos_mobile/core/widget/app_dropdown.dart';
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/core/widget/arrow_card.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/bloc/item_bloc.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_age_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_country_model.dart';

class AddItemV2 extends StatefulWidget {
  final ItemBloc itemBloc;
  final void Function() onTap;

  const AddItemV2({
    super.key,
    required this.itemBloc,
    required this.onTap,
  });

  @override
  State<AddItemV2> createState() => _AddItemV2State();
}

class _AddItemV2State extends State<AddItemV2> {
  late final void Function() bottomButtonBehaviour = widget.onTap;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.itemBloc.rebuildPage2,
      builder: (context, snapshot) {
        return SingleChildScrollView(
          child: Padding(
            padding: AppPaddingConstants().leftRight25,
            child: Column(
              children: [
                const SizedBox(
                  height: 35,
                ),
                Autocomplete(
                  displayStringForOption: (val) {
                    return val.countryName!;
                  },
                  onSelected: (value) {
                    widget.itemBloc.itemCountrySelected = value;
                  },
                  fieldViewBuilder: (
                    BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted,
                  ) {
                    return Focus(
                      onFocusChange: (val) {
                        widget.itemBloc.countryTap.add(val);
                      },
                      child: AppTextField(
                        textEditingController: textEditingController,
                        label: "Country".i18n,
                        isFocused: widget.itemBloc.countryTap.value,
                        showError: false,
                        focusNode: focusNode,
                      ),
                    );
                  },
                  optionsBuilder: (value) async {
                    List<ItemCountry> matches = [];
                    try {
                      var res = await ApiManager().dio()!.get(
                        ApiConstants.itemCountry,
                        queryParameters: {
                          "IncludeInactive": false,
                          "PageSize": 10000,
                          "PageNumber": 1,
                          "Usage": 0,
                          "Name": value.text,
                          "StoreID": RootBloc.store!.id!,
                        },
                      );

                      var t = ResItemCountryModel.fromJson(res.data);
                      if (t.data?.list?.isNotEmpty ?? false) {
                        matches.addAll(t.data!.list!);
                        matches.retainWhere((element) {
                          return element.countryName!.toLowerCase().contains(value.text.toLowerCase());
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
                  height: 20,
                ),
                ArrowCard(
                  label: Text(
                    widget.itemBloc.itemRegionsValue.valueOrNull != null
                        ? widget.itemBloc.itemRegionsValue.value!.name!
                        : "Region".i18n,
                    style: TextStyle(
                      color: widget.itemBloc.itemRegionsValue.valueOrNull != null
                          ? AppColors.colorBlack
                          : AppColors.colorLightGrey100,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    TabNavigatorRouter(
                      navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                      currentPageKey: AppRouteManager.currentPage,
                    ).pushNamed(
                      AppRouteConstants.addItemRegionsScreen,
                      arguments: {"itemBloc": widget.itemBloc},
                    )?.then((value) {
                      RootBloc().changeBottomBarBehaviour(
                        onTap: bottomButtonBehaviour,
                        bottomBarIconPath: null,
                      );
                      widget.itemBloc.rebuildPage2.add(true);
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                  stream: widget.itemBloc.uomValue,
                  builder: (context, snapshot) {
                    return AppDropdown(
                      value: widget.itemBloc.uomValue.value,
                      items: widget.itemBloc.uomValues.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                          ),
                        );
                      }).toList(),
                      hintText: "Item UOM".i18n,
                      onChanged: (value) {
                        if (widget.itemBloc.uomValue.value.compareTo(value!) != 0) {
                          alertBox(context, value);
                        }
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ArrowCard(
                  label: Text(
                    widget.itemBloc.itemAbvValue.valueOrNull?.name ?? "Alcohol by volume".i18n,
                    style: TextStyle(
                      color: widget.itemBloc.itemAbvValue.valueOrNull != null
                          ? AppColors.colorBlack
                          : AppColors.colorLightGrey100,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    TabNavigatorRouter(
                      navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                      currentPageKey: AppRouteManager.currentPage,
                    ).pushNamed(
                      AppRouteConstants.addAbvScreen,
                      arguments: {"itemBloc": widget.itemBloc},
                    )?.then((value) {
                      RootBloc().changeBottomBarBehaviour(
                        onTap: bottomButtonBehaviour,
                        bottomBarIconPath: null,
                      );
                      widget.itemBloc.rebuildPage2.add(true);
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ArrowCard(
                  label: Text(
                    widget.itemBloc.itemFlavourValue.valueOrNull?.name ?? "Flavour".i18n,
                    style: TextStyle(
                      color: widget.itemBloc.itemFlavourValue.valueOrNull != null
                          ? AppColors.colorBlack
                          : AppColors.colorLightGrey100,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    TabNavigatorRouter(
                      navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                      currentPageKey: AppRouteManager.currentPage,
                    ).pushNamed(
                      AppRouteConstants.addFlavourScreen,
                      arguments: {"itemBloc": widget.itemBloc},
                    )?.then((value) {
                      RootBloc().changeBottomBarBehaviour(
                        onTap: bottomButtonBehaviour,
                        bottomBarIconPath: null,
                      );
                      widget.itemBloc.rebuildPage2.add(true);
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                  stream: widget.itemBloc.ageValue,
                  builder: (context, snapshot) {
                    return AppDropdown(
                      value: widget.itemBloc.ageValue.valueOrNull,
                      items: widget.itemBloc.resItemAgeModel.data!.list!.map((ItemAge item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item.name!,
                          ),
                        );
                      }).toList(),
                      hintText: "Age Required",
                      onChanged: (value) {
                        widget.itemBloc.ageValue.add(value!);
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                  stream: widget.itemBloc.itemShelfLifeTap.stream,
                  builder: (context, snapshot) {
                    return Focus(
                      onFocusChange: (val) {
                        widget.itemBloc.itemShelfLifeTap.add(val);
                      },
                      child: AppTextField(
                        isFocused: widget.itemBloc.itemShelfLifeTap.value,
                        label: "Item Shelf Life".i18n,
                        textEditingController: widget.itemBloc.itemShelfLifeController,
                        showError: false,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*'))],
                        validatorFunction: (value) {
                          if (value == null || value.isEmpty) {
                            widget.itemBloc.itemShelfLifeTap.add(widget.itemBloc.itemShelfLifeTap.value);
                          } else {
                            widget.itemBloc.itemShelfLifeTap.add(widget.itemBloc.itemShelfLifeTap.value);
                          }
                          return null;
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ArrowCard(
                  label: Text(
                    widget.itemBloc.itemFamilyValue.valueOrNull?.name ?? "Family".i18n,
                    style: TextStyle(
                      color: widget.itemBloc.itemFamilyValue.valueOrNull != null
                          ? AppColors.colorBlack
                          : AppColors.colorLightGrey100,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    TabNavigatorRouter(
                      navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                      currentPageKey: AppRouteManager.currentPage,
                    ).pushNamed(
                      AppRouteConstants.addFamilyScreen,
                      arguments: {"itemBloc": widget.itemBloc},
                    )?.then((value) {
                      RootBloc().changeBottomBarBehaviour(
                        onTap: bottomButtonBehaviour,
                        bottomBarIconPath: null,
                      );
                      widget.itemBloc.rebuildPage2.add(true);
                    });
                  },
                ),
                const SizedBox(
                  height: 130,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> alertBox(BuildContext context, String val) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Your Item UOM will be changed And Inserted packages will removed'.i18n),
          content: Text('Are you sure you want to do this?'.i18n),
          actions: [
            Padding(
              padding: AppPaddingConstants().bottom8,
              child: AppButton(
                label: "CANCEL".i18n,
                onPressed: () {
                  Navigator.pop(ctx);
                },
                labelColor: AppColors.colorPrimary,
                color: AppColors.colorWhite,
                height: 32,
              ),
            ),
            AppButton(
              label: "APPLY".i18n,
              onPressed: () {
                widget.itemBloc.uomValue.add(val);
                widget.itemBloc.itemPrimaryPackageList.clear();
                widget.itemBloc.resetPackageValue();
                Navigator.pop(ctx);
              },
              height: 32,
            ),
          ],
        );
      },
    );
  }
}
