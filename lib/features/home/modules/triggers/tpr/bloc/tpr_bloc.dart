import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ptecpos_mobile/core/base/base_bloc.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/req_delete_trigger_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/res_trigger_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/repo/tpr_repo.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/state/tpr_state.dart';
import 'package:rxdart/rxdart.dart';

class TprBloc extends BaseBloc {
  final TprRepo _tprRepo = TprRepo();
  late BehaviorSubject<TprState> tprState;

  late BehaviorSubject<TprState> filterTprState;
  late BehaviorSubject<bool> loadingTriggers;
  late BehaviorSubject<String?> numberFilterValue;

  TextEditingController startDateController = TextEditingController();
  DateTime? startDate;
  TextEditingController endDateController = TextEditingController();
  DateTime? endDate;

  late ResTriggerModel resTriggerModel;
  ScrollController scrollController = ScrollController();

  List<String> numberFilter = ["By percentages".i18n, "By Amount".i18n];

  ///---------Is applied clicked ----------------
  bool isAppliedClick = false;

  int pageNumber = 1;
  int pageSize = 30;

  TprBloc() {
    tprState = subjectManager.createSubject<TprState>(key: "tprState");
    filterTprState =
        subjectManager.createSubject(key: "filterTprState", seedValue: TprState.completed(true));
    loadingTriggers = subjectManager.createSubject(key: "loadingTriggers", seedValue: false);

    numberFilterValue = subjectManager.createSubject<String?>(key: "accessValue");
  }

  void initData() {
    pageNumber = 1;
    pageSize = 30;
    tprState.add(TprState.loading());
    subscription.add(
      _tprRepo.getTriggers(pageSize, pageNumber).map((event) {
        if (!(event.error ?? true)) {
          resTriggerModel = event;
          tprState.add(TprState.completed(true));
          return;
        } else {
          AppUtil.showSnackBar(
            label: event.message ?? "Something went wrong".i18n,
          );
          tprState.add(TprState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        tprState.add(TprState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResTriggerModel.fromJson(err.response?.data ?? {});
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

  void filterData() {
    isAppliedClick = true;
    pageNumber = 1;
    filterTprState.add(TprState.loading());
    int? type = numberFilterValue.valueOrNull != null
        ? (numberFilterValue.value?.compareTo(numberFilter[0]) == 0 ? 1 : 2)
        : null;
    subscription.add(
      _tprRepo
          .getFilterTriggers(
        pageSize: pageSize,
        pageNumber: pageNumber,
        startDate: AppUtil.backendDateFormat(dateTime: startDate),
        endDate: AppUtil.backendDateFormat(dateTime: endDate),
        type: type,
      )
          .map((event) {
        if (!(event.error ?? true)) {
          resTriggerModel = event;
          filterTprState.add(TprState.completed(true));
        } else {
          filterTprState.add(TprState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        tprState.add(TprState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResTriggerModel.fromJson(err.response?.data ?? {});
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
    if (resTriggerModel.data!.list!.length < resTriggerModel.data!.count! && !loadingTriggers.value) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        loadingTriggers.add(true);
        ++pageNumber;
        getPaginatedTriggers();
      }
    }
  }

  void getPaginatedTriggers() {
    if (isAppliedClick) {
      getFilteredPaginatedData();
    } else {
      getPaginatedData();
    }
  }

  void getPaginatedData() {
    subscription.add(
      _tprRepo.getTriggers(pageSize, pageNumber).map((event) {
        loadingTriggers.add(false);
        if (!(event.error ?? true)) {
          resTriggerModel.data!.list!.addAll(event.data!.list!);
          filterTprState.add(TprState.completed(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        loadingTriggers.add(false);
      }).listen((event) {}),
    );
  }

  void getFilteredPaginatedData() {
    int? type = numberFilterValue.valueOrNull != null
        ? (numberFilterValue.value?.compareTo(numberFilter[0]) == 0 ? 1 : 2)
        : null;
    subscription.add(
      _tprRepo
          .getFilterTriggers(
        pageSize: pageSize,
        pageNumber: pageNumber,
        startDate: AppUtil.backendDateFormat(dateTime: startDate),
        endDate: AppUtil.backendDateFormat(dateTime: endDate),
        type: type,
      )
          .map((event) {
        loadingTriggers.add(false);
        if (!(event.error ?? true)) {
          resTriggerModel.data!.list!.addAll(event.data!.list!);
          filterTprState.add(TprState.completed(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        loadingTriggers.add(false);
      }).listen((event) {}),
    );
  }

  void deleteTpr(String id) {
    AppUtil.showLoader();
    ReqCrudOperationModel model = ReqCrudOperationModel(
      op: "Replace",
      path: "/Active",
      value: "false",
    );
    subscription.add(
      _tprRepo.deleteTrigger(id, model).map((event) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext!);
        if (!(event.error ?? true)) {
          AppUtil.showSnackBar(label: "TPR deleted successfully".i18n);
          initData();
          return;
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext!);
        AppUtil.showSnackBar(label: "Something went wrong".i18n);
      }).listen((event) {}),
    );
  }

  void resetValue() {
    isAppliedClick = false;
    startDateController.clear();
    endDateController.clear();
    numberFilterValue.add(null);
    startDate = null;
    endDate = null;
  }

  @override
  void dispose() {
    endDateController.dispose();
    startDateController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
