import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ptecpos_mobile/core/base/base_bloc.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/widget/multi_select_widget/multi_select_flutter.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/model/req_edit_standard_model.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/model/req_standard_model.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/model/res_standard_discount_model.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/model/res_standard_store_model.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/repo/standard_discount_repo.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/state/standard_discount_state.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/req_delete_trigger_model.dart';
import 'package:rxdart/rxdart.dart';

class StandardDiscountBloc extends BaseBloc {
  late BehaviorSubject<StandardDiscountState> discountState;
  final StandardDiscountRepo _standardDiscountRepo = StandardDiscountRepo();
  late ResStandardDiscountModel resStandardDiscountModel;

  late BehaviorSubject<StandardDiscountState> filterDiscountState;
  late BehaviorSubject<bool> loadingState;

  int pageSize = 30;
  int pageNumber = 1;

  ScrollController scrollController = ScrollController();
  TextEditingController searchController = SearchController();
  late BehaviorSubject<bool> isSearchEnabled;

  List<String> addType = ["Add".i18n, "Add to Multiple Store".i18n];
  late BehaviorSubject<String> addTypeValue;

  ///Add discount variables
  late BehaviorSubject<bool> discountTap;
  late BehaviorSubject<bool> percentageTap;

  late BehaviorSubject<bool> discountError;
  late BehaviorSubject<bool> percentageError;

  String percentageErrorMsg = "Percentage is required".i18n;

  TextEditingController discountNameController = TextEditingController();
  TextEditingController percentageNameController = TextEditingController();
  final addFormKey = GlobalKey<FormState>();

  /// Add to multiple store
  late BehaviorSubject<StandardDiscountState> addState;
  late ResStandardStoresModel resStandardStoresModel;
  final addMultiFormKey = GlobalKey<FormState>();

  List<MultiSelectItem<StandardStores>> standardStores = [];
  late BehaviorSubject<List<StandardStores>> standardStoresValue;

  /// Edit standard variables
  late BehaviorSubject<StandardDiscountState> editState;

  StandardDiscountBloc() {
    discountState = subjectManager.createSubject<StandardDiscountState>(key: "discountState");
    filterDiscountState = subjectManager.createSubject<StandardDiscountState>(
      key: "filterDiscountState",
      seedValue: StandardDiscountState.completed(true),
    );
    loadingState = subjectManager.createSubject<bool>(key: "loadingState", seedValue: false);
    isSearchEnabled = subjectManager.createSubject<bool>(key: "isSearchEnabled", seedValue: false);
    addTypeValue = subjectManager.createSubject<String>(key: "addTypeValue", seedValue: addType.first);
    discountTap = subjectManager.createSubject(key: "discountTap", seedValue: false);
    discountError = subjectManager.createSubject(key: "discountError", seedValue: false);
    percentageTap = subjectManager.createSubject(key: "percentageTap", seedValue: false);
    percentageError = subjectManager.createSubject(key: "percentageError", seedValue: false);
    addState = subjectManager.createSubject(key: "addState");
    standardStoresValue = subjectManager.createSubject(key: "standardStoreValue");
    editState = subjectManager.createSubject(key: "editState");
  }

  void initData() {
    discountState.add(StandardDiscountState.loading());
    pageNumber = 1;
    subscription.add(
      _standardDiscountRepo.getStandardDiscount(pageSize, pageNumber).map((event) {
        if (!(event.error ?? true)) {
          resStandardDiscountModel = event;
          discountState.add(StandardDiscountState.completed(true));
        } else {
          AppUtil.showSnackBar(
            label: event.message ?? "Something went wrong".i18n,
          );
          discountState.add(StandardDiscountState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        discountState.add(StandardDiscountState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResStandardDiscountModel.fromJson(err.response?.data ?? {});
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
        } else {
          AppUtil.showSnackBar(label: "Something went wrong".i18n);
        }
      }).listen((event) {}),
    );
  }

  void searchedData() {
    pageNumber = 1;
    filterDiscountState.add(StandardDiscountState.loading());
    subscription.add(
      _standardDiscountRepo
          .getSearchedStandardDiscount(pageSize, pageNumber, searchController.text)
          .map((event) {
        if (!(event.error ?? true)) {
          resStandardDiscountModel = event;
          filterDiscountState.add(StandardDiscountState.completed(true));
        } else {
          filterDiscountState.add(StandardDiscountState.error(true));
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        filterDiscountState.add(StandardDiscountState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResStandardDiscountModel.fromJson(err.response?.data ?? {});
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
        } else {
          AppUtil.showSnackBar(label: "Something went wrong".i18n);
        }
      }).listen((event) {}),
    );
  }

  void scrollListener() {
    if (resStandardDiscountModel.data!.list!.length < resStandardDiscountModel.data!.count! &&
        !loadingState.value) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        loadingState.add(true);
        ++pageNumber;
        getDiscountPaginated();
      }
    }
  }

  void getDiscountPaginated() {
    if (isSearchEnabled.value) {
      getSearchedPaginated();
    } else {
      getPaginatedData();
    }
  }

  void getSearchedPaginated() {
    subscription.add(
      _standardDiscountRepo
          .getSearchedStandardDiscount(pageSize, pageNumber, searchController.text)
          .map((event) {
        loadingState.add(false);
        if (!(event.error ?? true)) {
          resStandardDiscountModel.data!.list!.addAll(event.data!.list!);
        }
      }).onErrorReturnWith((error, stackTrace) {
        loadingState.add(false);
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
      }).listen((event) {}),
    );
  }

  void getPaginatedData() {
    subscription.add(
      _standardDiscountRepo.getStandardDiscount(pageSize, pageNumber).map((event) {
        loadingState.add(false);
        if (!(event.error ?? true)) {
          resStandardDiscountModel.data!.list!.addAll(event.data!.list!);
        }
      }).onErrorReturnWith((error, stackTrace) {
        loadingState.add(false);
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
      }).listen((event) {}),
    );
  }

  void addInitData() {
    addState.add(StandardDiscountState.loading());
    subscription.add(
      _standardDiscountRepo.getStandardStores().map((event) {
        if (!(event.error ?? true)) {
          resStandardStoresModel = event;
          standardStores = resStandardStoresModel.data!.list!.map((e) {
            return MultiSelectItem<StandardStores>(e, e.name!);
          }).toList();
          standardStoresValue.add([
            standardStores
                .firstWhere((element) => element.value.id!.compareTo(RootBloc.store!.id!) == 0)
                .value,
          ]);
          addState.add(StandardDiscountState.completed(true));
        } else {
          addState.add(StandardDiscountState.error(true));
          AppUtil.showSnackBar(
            label: event.message ?? "Something went wrong".i18n,
          );
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        addState.add(StandardDiscountState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResStandardStoresModel.fromJson(err.response?.data ?? {});
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
        } else {
          AppUtil.showSnackBar(label: "Something went wrong".i18n);
        }
      }).listen((event) {}),
    );
  }

  void addReset() {
    discountNameController.clear();
    discountTap.add(false);
    discountError.add(false);

    percentageNameController.clear();
    percentageTap.add(false);
    percentageError.add(false);
  }

  bool checkValidation() {
    if (addTypeValue.value.compareTo(addType.first) == 0) {
      if ((!discountError.value && discountNameController.text.isNotEmpty) &&
          (!percentageError.value && percentageNameController.text.isNotEmpty)) {
        if (double.parse(percentageNameController.text) > 100) {
          percentageErrorMsg = "Percentage must be in percentage".i18n;
          percentageError.add(true);
          return false;
        }
        percentageErrorMsg = "Percentage is required".i18n;
        percentageError.add(false);
        return true;
      }
      return false;
    }
    if ((!discountError.value && discountNameController.text.isNotEmpty) &&
        (!percentageError.value && percentageNameController.text.isNotEmpty)) {
      if (double.parse(percentageNameController.text) > 100) {
        percentageErrorMsg = "Percentage must be in percentage".i18n;
        percentageError.add(true);
        return false;
      } else if (standardStoresValue.value.isEmpty) {
        return false;
      }
      percentageErrorMsg = "Percentage is required".i18n;
      percentageError.add(false);
      return true;
    }
    return false;
  }

  void postStandard() {
    AppUtil.showLoader();
    // int per = double.tryParse(percentageNameController.text)?.toInt() ??
    //     int.tryParse(percentageNameController.text) ??
    //     0;
    ReqStandardModel model = ReqStandardModel(
      name: discountNameController.text,
      percentage: double.tryParse(percentageNameController.text),
      storeIdList: standardStoresValue.valueOrNull == null
          ? [RootBloc.store!.id!]
          : standardStoresValue.value.map((e) => e.id!).toList(),
    );
    subscription.add(
      _standardDiscountRepo.postStandard(model).map((event) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (!(event.error ?? true)) {
          AppUtil.showSnackBar(label: "Standard discount have been added successfully".i18n);
          initData();
          return;
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        if (error is DioException) {
          var err = error;
          var res = ResStandardDiscountModel.fromJson(err.response?.data ?? {});
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
        } else {
          AppUtil.showSnackBar(label: "Something went wrong".i18n);
        }
      }).listen((event) {}),
    );
  }

  void deleteStandard(String id) {
    AppUtil.showLoader();
    ReqCrudOperationModel model = ReqCrudOperationModel(
      op: "Replace",
      path: "/Active",
      value: "false",
    );
    subscription.add(
      _standardDiscountRepo.deleteStandard(id, model).map((event) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (!(event.error ?? true)) {
          AppUtil.showSnackBar(label: "Standard discount deleted".i18n);
          searchController.clear();
          isSearchEnabled.add(false);
          initData();
          return;
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        AppUtil.showSnackBar(label: "Something went wrong".i18n);
      }).listen((event) {}),
    );
  }

  void getStandard(String id) {
    editState.add(StandardDiscountState.loading());
    subscription.add(
      _standardDiscountRepo.getStandard(id).map((event) {
        if (!(event.error ?? true)) {
          discountNameController.text = event.data!.name!;
          percentageNameController.text = event.data!.percentage!.toString();
          editState.add(StandardDiscountState.completed(true));
        } else {
          editState.add(StandardDiscountState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        editState.add(StandardDiscountState.error(true));
      }).listen((event) {}),
    );
  }

  void editStandard(String id) {
    AppUtil.showLoader();

    ReqEditStandardModel model = ReqEditStandardModel(
      name: discountNameController.text,
      percentage: double.tryParse(percentageNameController.text),
      storeIdList: [RootBloc.store!.id!],
      id: id,
    );
    subscription.add(
      _standardDiscountRepo.editStandard(model).map((event) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (!(event.error ?? true)) {
          AppUtil.showSnackBar(label: "Standard discount have been updated successfully".i18n);
          if (searchController.text.isEmpty) {
            initData();
          } else {
            searchedData();
          }
          return;
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        if (error is DioException) {
          var err = error;
          var res = ResStandardDiscountModel.fromJson(err.response?.data ?? {});
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
        } else {
          AppUtil.showSnackBar(label: "Something went wrong".i18n);
        }
      }).listen((event) {}),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    discountNameController.dispose();
    super.dispose();
  }
}
