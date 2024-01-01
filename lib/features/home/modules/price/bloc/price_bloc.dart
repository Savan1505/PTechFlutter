import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ptecpos_mobile/core/base/base_bloc.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/utils/app_enum.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/utils/res_default_model.dart';
import 'package:ptecpos_mobile/features/home/modules/price/model/req_price_level_model.dart';
import 'package:ptecpos_mobile/features/home/modules/price/model/res_price_level_model.dart';
import 'package:ptecpos_mobile/features/home/modules/price/model/res_price_model.dart';
import 'package:ptecpos_mobile/features/home/modules/price/repo/price_level_repo.dart';
import 'package:ptecpos_mobile/features/home/modules/price/state/price_level_state.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/req_delete_trigger_model.dart';
import 'package:rxdart/rxdart.dart';

class PriceBloc extends BaseBloc {
  final PriceLevelRepo _priceLevelRepo = PriceLevelRepo();
  late ResPriceLevelModel resPriceLevelModel;

  late BehaviorSubject<PriceLevelState> priceState;

  late BehaviorSubject<PriceLevelState> filterPriceState;
  late BehaviorSubject<bool> loadingState;

  int pageSize = 30;
  int pageNumber = 1;

  ScrollController scrollController = ScrollController();
  TextEditingController searchController = SearchController();
  late BehaviorSubject<bool> isSearchEnabled;

  late BehaviorSubject<bool> nameTap;
  late BehaviorSubject<bool> nameError;
  TextEditingController nameController = TextEditingController();

  late BehaviorSubject<bool> reduceTap;
  late BehaviorSubject<bool> reduceError;
  TextEditingController reduceController = TextEditingController();
  String reduceMessage = "By percentages is required".i18n;

  List<String> reduceType = ["Percentage".i18n, "Amount".i18n];
  late BehaviorSubject<String> reduceTypeValue;

  List<String> addType = ["Add".i18n, "Deduct".i18n];
  late BehaviorSubject<String> addTypeValue;

  final formKey = GlobalKey<FormState>();

  /// Edit state
  late BehaviorSubject<PriceLevelState> editState;

  PriceBloc() {
    priceState = subjectManager.createSubject<PriceLevelState>(key: "priceState");
    isSearchEnabled = subjectManager.createSubject<bool>(key: "isSearchEnabled", seedValue: false);
    filterPriceState = subjectManager.createSubject<PriceLevelState>(
      key: "filterDiscountState",
      seedValue: PriceLevelState.completed(true),
    );
    loadingState = subjectManager.createSubject<bool>(key: "loadingState", seedValue: false);
    nameTap = subjectManager.createSubject(key: "nameTap", seedValue: false);
    nameError = subjectManager.createSubject(key: "nameError", seedValue: false);
    reduceTypeValue = subjectManager.createSubject(key: "reduceTypeValue", seedValue: reduceType.first);

    reduceTap = subjectManager.createSubject(key: "reduceTap", seedValue: false);
    reduceError = subjectManager.createSubject(key: "reduceError", seedValue: false);
    addTypeValue = subjectManager.createSubject(key: "addTypeValue", seedValue: addType.first);
    editState = subjectManager.createSubject(key: "editState");
  }

  void initData() {
    priceState.add(PriceLevelState.loading());
    subscription.add(
      _priceLevelRepo.getPriceLevel(pageSize, pageNumber).map((event) {
        if (!(event.error ?? true)) {
          resPriceLevelModel = event;
          priceState.add(PriceLevelState.completed(true));
        } else {
          AppUtil.showSnackBar(
            label: event.message ?? "Something went wrong".i18n,
          );
          priceState.add(PriceLevelState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        priceState.add(PriceLevelState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResPriceLevelModel.fromJson(err.response?.data ?? {});
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
    filterPriceState.add(PriceLevelState.loading());
    subscription.add(
      _priceLevelRepo.getSearchedPriceLevel(pageSize, pageNumber, searchController.text).map((event) {
        if (!(event.error ?? true)) {
          resPriceLevelModel = event;
          filterPriceState.add(PriceLevelState.completed(true));
        } else {
          filterPriceState.add(PriceLevelState.error(true));
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        filterPriceState.add(PriceLevelState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResPriceLevelModel.fromJson(err.response?.data ?? {});
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
    if (resPriceLevelModel.data!.list!.length < resPriceLevelModel.data!.count! && !loadingState.value) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        loadingState.add(true);
        ++pageNumber;
        getPricePaginated();
      }
    }
  }

  void getPricePaginated() {
    if (isSearchEnabled.value) {
      getSearchedPaginated();
    } else {
      getPaginatedData();
    }
  }

  void getSearchedPaginated() {
    subscription.add(
      _priceLevelRepo.getSearchedPriceLevel(pageSize, pageNumber, searchController.text).map((event) {
        loadingState.add(false);
        if (!(event.error ?? true)) {
          resPriceLevelModel.data!.list!.addAll(event.data!.list!);
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
      _priceLevelRepo.getPriceLevel(pageSize, pageNumber).map((event) {
        loadingState.add(false);
        if (!(event.error ?? true)) {
          resPriceLevelModel.data!.list!.addAll(event.data!.list!);
        }
      }).onErrorReturnWith((error, stackTrace) {
        loadingState.add(false);
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
      }).listen((event) {}),
    );
  }

  bool checkValidation() {
    if ((!nameError.value && nameController.text.isNotEmpty) &&
        (!reduceError.value && reduceController.text.isNotEmpty)) {
      if (reduceTypeValue.value.compareTo(reduceType.first) == 0) {
        if (double.parse(reduceController.text) > 100) {
          reduceMessage = "Percentage must be in percentage".i18n;
          reduceError.add(true);
          return false;
        }
      }
      reduceMessage = "Percentage is required".i18n;
      reduceError.add(false);
      return true;
    }

    return false;
  }

  void addPriceLevel() {
    AppUtil.showLoader();
    ReqPriceLevelModel model = ReqPriceLevelModel(
      name: nameController.text,
      type: 0,
      price: "",
      rateType: reduceTypeValue.value.compareTo(reduceType.first) == 0
          ? ReduceType.percentage.toString()
          : ReduceType.amount.toString(),
      rateAdd: addTypeValue.value.compareTo(addType.first) == 0,
      rate: double.tryParse(reduceController.text),
    );
    subscription.add(
      _priceLevelRepo.addPriceLevel(model).map((event) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (!(event.error ?? true)) {
          AppUtil.showSnackBar(label: "Price levels have been added successfully".i18n);
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
          try {
            var res = ResPriceModel.fromJson(err.response?.data ?? {});
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

  void getPriceLevel(String id) {
    editState.add(PriceLevelState.loading());
    subscription.add(
      _priceLevelRepo.getPriceLevelById(id).map((event) {
        if (!(event.error ?? true)) {
          nameController.text = event.data!.name!;
          reduceController.text = event.data!.rate!.toString();
          if (event.data!.rateType! == ReduceType.percentage) {
            reduceTypeValue.add(reduceType.first);
          } else {
            reduceTypeValue.add(reduceType.last);
          }
          if (event.data!.rateAdd!) {
            addTypeValue.add(addType.first);
          } else {
            addTypeValue.add(addType.last);
          }
          editState.add(PriceLevelState.completed(true));
        } else {
          editState.add(PriceLevelState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        editState.add(PriceLevelState.error(true));
      }).listen((event) {}),
    );
  }

  void editPriceLevel(String id) {
    AppUtil.showLoader();
    ReqPriceLevelModel model = ReqPriceLevelModel(
      name: nameController.text,
      type: 0,
      price: "",
      rateType: reduceTypeValue.value.compareTo(reduceType.first) == 0
          ? ReduceType.percentage.toString()
          : ReduceType.amount.toString(),
      rateAdd: addTypeValue.value.compareTo(addType.first) == 0,
      rate: double.tryParse(reduceController.text),
    );
    subscription.add(
      _priceLevelRepo.editPriceLevel(model, id).map((event) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (!(event.error ?? true)) {
          AppUtil.showSnackBar(label: "Price levels have been updated successfully".i18n);
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

  void deletePriceLevel(String id) {
    AppUtil.showLoader();
    ReqCrudOperationModel model = ReqCrudOperationModel(
      op: "Replace",
      path: "/Active",
      value: "false",
    );
    subscription.add(
      _priceLevelRepo.deletePriceLevel(id, model).map((event) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (!(event.error ?? true)) {
          AppUtil.showSnackBar(label: "Price level deleted".i18n);
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

  void addReset() {
    nameController.clear();
    nameTap.add(false);
    nameError.add(false);

    reduceTap.add(false);
    reduceError.add(false);
    if (reduceTypeValue.value.compareTo(reduceType.first) == 0) {
      reduceMessage = "By percentages is required".i18n;
    } else {
      reduceMessage = "By amount is required".i18n;
    }
    reduceController.clear();
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    nameController.dispose();
    reduceController.dispose();
    super.dispose();
  }
}
