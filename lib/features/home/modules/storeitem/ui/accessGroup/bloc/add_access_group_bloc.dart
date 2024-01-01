import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ptecpos_mobile/core/base/base_bloc.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/routes/tab_navigator.dart';
import 'package:ptecpos_mobile/core/utils/app_enum.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/utils/res_default_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_category_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_department_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_storeitem_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_sub_category_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/accessGroup/model/req_access_group_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/accessGroup/repo/access_repo.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/accessGroup/state/access_state.dart';
import 'package:rxdart/rxdart.dart';

class AddAccessGroupBloc extends BaseBloc {
  final AccessRepo _accessRepo = AccessRepo();

  late BehaviorSubject<bool> ringUpValue;

  late BehaviorSubject<bool> nameTap;
  late BehaviorSubject<bool> nameError;
  TextEditingController nameController = TextEditingController();

  late BehaviorSubject<bool> descTap;
  TextEditingController descController = TextEditingController();

  ///Search Items variable
  late BehaviorSubject<AccessState> accessState;
  late ResItemDepartmentModel resItemDepartmentModel;
  late ResItemCategoryModel resItemCategoryModel;
  late ResSubCategoryModel resSubCategoryModel;
  late ResStoreItemModel resStoreItemModel;
  late BehaviorSubject<bool> itemNameTap;

  TextEditingController itemNameController = TextEditingController();
  late BehaviorSubject<ItemDepartment?> itemDepartmentValue;
  late BehaviorSubject<ItemCategory?> itemCategoryValue;
  late BehaviorSubject<Subcategory?> itemSubCategoryValue;

  /// Quick item list variables
  late BehaviorSubject<List<StoreItemElement>> selectedItemList;
  bool areItemSelected = false;

  /// Edit quick features variables
  late BehaviorSubject<AccessState> editAccessState;

  AddAccessGroupBloc() {
    ringUpValue = subjectManager.createSubject(key: "ringUpValue", seedValue: false);
    nameTap = subjectManager.createSubject(key: "nameTap", seedValue: false);
    nameError = subjectManager.createSubject(key: "nameError", seedValue: false);
    descTap = subjectManager.createSubject(key: "descTap", seedValue: false);

    /// Search Items Variable
    accessState = subjectManager.createSubject(key: "accessState");
    itemNameTap = subjectManager.createSubject(key: "itemNameTap", seedValue: false);
    itemDepartmentValue =
        subjectManager.createNullableSubject<ItemDepartment?>(key: "itemDepartmentValue");
    itemCategoryValue = subjectManager.createNullableSubject<ItemCategory?>(key: "itemCategoryValue");
    itemSubCategoryValue =
        subjectManager.createNullableSubject<Subcategory?>(key: "itemSubCategoryValue");

    /// Quick item list variables
    selectedItemList =
        subjectManager.createSubject<List<StoreItemElement>>(key: "selectedItemList", seedValue: []);

    editAccessState = subjectManager.createSubject<AccessState>(
      key: "editAccessState",
      seedValue: AccessState.completed(true),
    );
  }

  void searchInitData() {
    accessState.add(AccessState.loading());

    subscription.add(
      ZipStream.zip3(
        _accessRepo.getDepartment(),
        _accessRepo.getCategory(),
        _accessRepo.getSubCategory(),
        (resItemDepartmentModel, resItemCategoryModel, resSubCategoryModel) {
          if (!(resItemDepartmentModel.error ?? true) &&
              !(resItemCategoryModel.error ?? true) &&
              !(resSubCategoryModel.error ?? true)) {
            this.resItemDepartmentModel = resItemDepartmentModel;
            this.resItemCategoryModel = resItemCategoryModel;
            this.resSubCategoryModel = resSubCategoryModel;
            itemNameController.clear();
            itemDepartmentValue.add(null);
            itemCategoryValue.add(null);
            itemSubCategoryValue.add(null);
            accessState.add(AccessState.completed(true));
            return;
          } else {
            AppUtil.showSnackBar(
              label: resItemDepartmentModel.message ??
                  resItemCategoryModel.message ??
                  resSubCategoryModel.message ??
                  "Something went wrong".i18n,
            );
            accessState.add(AccessState.error(true));
          }
        },
      ).onErrorReturnWith((error, stackTrace) {
        accessState.add(AccessState.error(true));
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        if (error is DioException) {
          var err = error;
          try {
            var res = ResItemDepartmentModel.fromJson(err.response?.data ?? {});
            if (!(res.error ?? true)) {
              AppUtil.showSnackBar(label: res.message ?? "Something went wrong".i18n);
            } else {
              if (err.error is SocketException) {
                var e = err.error as SocketException;
                AppUtil.showSnackBar(label: e.osError?.message ?? "Something went wrong".i18n);
              } else {
                AppUtil.showSnackBar(label: "Something went wrong".i18n);
              }
            }
          } catch (e) {
            debugPrint(e.toString());
            AppUtil.showSnackBar(label: "Something went wrong".i18n);
          }
        } else {
          AppUtil.showSnackBar(label: "Something went wrong".i18n);
        }
      }).listen((value) {}),
    );
  }

  Future<bool> navigateToListScreenCheck() async {
    if (itemNameController.text.isEmpty &&
        (itemDepartmentValue.valueOrNull == null) &&
        (itemCategoryValue.valueOrNull == null) &&
        (itemSubCategoryValue.valueOrNull == null)) {
      AppUtil.showSnackBar(label: "Please enter at least one of the field".i18n);
      return false;
    }
    bool returnValue = false;

    AppUtil.showLoader();
    await _accessRepo
        .getStoreItems(
      itemNameController.text,
      itemDepartmentValue.valueOrNull?.id,
      itemCategoryValue.valueOrNull?.id,
      itemSubCategoryValue.valueOrNull?.id,
    )
        .then((value) {
      AppUtil.hideMainContextLoader();
      if (!(value.error ?? true)) {
        resStoreItemModel = value;
        if (resStoreItemModel.data?.list?.isNotEmpty ?? false) {
          returnValue = true;
        } else {
          AppUtil.showSnackBar(label: "Items does not exists".i18n);
          returnValue = false;
        }
      } else {
        AppUtil.showSnackBar(label: value.message ?? "Something went wrong".i18n);
        returnValue = false;
      }
    }).onError((error, stackTrace) {
      AppUtil.hideMainContextLoader();
      debugPrint(error.toString());
      debugPrint(stackTrace.toString());
      if (error is DioException) {
        var err = error;
        try {
          var res = ResItemDepartmentModel.fromJson(err.response?.data ?? {});
          if (!(res.error ?? true)) {
            AppUtil.showSnackBar(label: res.message ?? "Something went wrong".i18n);
          } else {
            if (err.error is SocketException) {
              var e = err.error as SocketException;
              AppUtil.showSnackBar(label: e.osError?.message ?? "Something went wrong".i18n);
            } else {
              AppUtil.showSnackBar(label: "Something went wrong".i18n);
            }
          }
        } catch (e) {
          debugPrint(e.toString());
          AppUtil.showSnackBar(label: "Something went wrong".i18n);
        }
      } else {
        AppUtil.showSnackBar(label: "Something went wrong".i18n);
      }
      returnValue = false;
    });

    return returnValue;
  }

  void resetFilter() {
    itemNameController.clear();
    itemDepartmentValue.add(null);
    itemCategoryValue.add(null);
    itemSubCategoryValue.add(null);
    var t = selectedItemList.value;
    t.clear();
    selectedItemList.add(t);
  }

  void addQuickAccessGroup() {
    AppUtil.showLoader();
    ReqQuickAccessGroupModel model = ReqQuickAccessGroupModel(
      name: nameController.text,
      storeIdList: [RootBloc.store!.id!],
      description: descController.text,
      favorite: true,
      show: ringUpValue.value,
      storeItemIdList: selectedItemList.value
          .map(
            (e) => StoreItemIdList(
              name: e.name,
              storeItemId: e.id,
              actionFlag: ActionFlagEnum.insert,
            ),
          )
          .toList(),
    );
    subscription.add(
      _accessRepo.addQuickAccessGroup(model).map((event) {
        AppUtil.hideMainContextLoader();
        if (!(event.error ?? true)) {
          AppUtil.showSnackBar(label: "Quick access group added successfully".i18n);
          TabNavigatorRouter(
            navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
            currentPageKey: AppRouteManager.currentPage,
          ).pop();
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        AppUtil.hideMainContextLoader();
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        if (error is DioException) {
          var err = error;
          try {
            var res = ResItemDepartmentModel.fromJson(err.response?.data ?? {});
            if (!(res.error ?? true)) {
              AppUtil.showSnackBar(label: res.message ?? "Something went wrong".i18n);
            } else {
              if (err.error is SocketException) {
                var e = err.error as SocketException;
                AppUtil.showSnackBar(label: e.osError?.message ?? "Something went wrong".i18n);
              } else {
                AppUtil.showSnackBar(label: "Something went wrong".i18n);
              }
            }
          } catch (e) {
            debugPrint(e.toString());
            AppUtil.showSnackBar(label: "Something went wrong".i18n);
          }
        } else {
          AppUtil.showSnackBar(label: "Something went wrong".i18n);
        }
      }).listen((event) {}),
    );
  }

  void getQuickAccess(String id) {
    editAccessState.add(AccessState.loading());
    subscription.add(
      _accessRepo.getQuickAccess(id).map((event) {
        if (!(event.error ?? true)) {
          nameController.text = event.data!.name!;
          ringUpValue.add(event.data!.show!);
          descController.text = event.data!.description!;
          var t = event.data!.storeItems!.map((e) {
            return StoreItemElement(
              name: e.name!,
              id: e.storeItemId,
            );
          }).toList();
          selectedItemList.add(t);
          editAccessState.add(AccessState.completed(true));
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
          editAccessState.add(AccessState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        editAccessState.add(AccessState.error(true));
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        if (error is DioException) {
          var err = error;
          try {
            var res = ResItemDepartmentModel.fromJson(err.response?.data ?? {});
            if (!(res.error ?? true)) {
              AppUtil.showSnackBar(label: res.message ?? "Something went wrong".i18n);
            } else {
              if (err.error is SocketException) {
                var e = err.error as SocketException;
                AppUtil.showSnackBar(label: e.osError?.message ?? "Something went wrong".i18n);
              } else {
                AppUtil.showSnackBar(label: "Something went wrong".i18n);
              }
            }
          } catch (e) {
            debugPrint(e.toString());
            AppUtil.showSnackBar(label: "Something went wrong".i18n);
          }
        } else {
          AppUtil.showSnackBar(label: "Something went wrong".i18n);
        }
      }).listen((event) {}),
    );
  }

  void updateQuickAccessGroup(String id) {
    AppUtil.showLoader();
    ReqQuickAccessGroupModel model = ReqQuickAccessGroupModel(
      name: nameController.text,
      storeIdList: [RootBloc.store!.id!],
      description: descController.text,
      favorite: true,
      show: ringUpValue.value,
      storeItemIdList: selectedItemList.value
          .map(
            (e) => StoreItemIdList(
              name: e.name,
              storeItemId: e.id,
              actionFlag: ActionFlagEnum.insert,
            ),
          )
          .toList(),
    );
    subscription.add(
      _accessRepo.updateQuickAccessGroup(id, model).map((event) {
        AppUtil.hideMainContextLoader();
        if (!(event.error ?? true)) {
          AppUtil.showSnackBar(label: "Quick access group updated successfully".i18n);
          TabNavigatorRouter(
            navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
            currentPageKey: AppRouteManager.currentPage,
          ).pop();
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        AppUtil.hideMainContextLoader();
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        if (error is DioException) {
          var err = error;
          try {
            var res = ResDefaultModel.fromJson(err.response?.data ?? {});
            if (!(res.error ?? true)) {
              AppUtil.showSnackBar(label: res.message ?? "Something went wrong".i18n);
            } else {
              if (err.error is SocketException) {
                var e = err.error as SocketException;
                AppUtil.showSnackBar(label: e.osError?.message ?? "Something went wrong".i18n);
              } else {
                AppUtil.showSnackBar(label: "Something went wrong".i18n);
              }
            }
          } catch (e) {
            debugPrint(e.toString());
            AppUtil.showSnackBar(label: "Something went wrong".i18n);
          }
        } else {
          AppUtil.showSnackBar(label: "Something went wrong".i18n);
        }
      }).listen((event) {}),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    itemNameController.dispose();
    super.dispose();
  }
}
