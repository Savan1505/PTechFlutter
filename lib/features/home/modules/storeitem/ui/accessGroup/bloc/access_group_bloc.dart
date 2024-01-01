import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:ptecpos_mobile/core/base/base_bloc.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/accessGroup/model/res_access_group_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/accessGroup/repo/access_repo.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/accessGroup/state/access_state.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/req_delete_trigger_model.dart';
import 'package:rxdart/rxdart.dart';

class AccessGroupBloc extends BaseBloc {
  late BehaviorSubject<AccessState> accessState;
  late BehaviorSubject<AccessState> filterAccessState;
  late BehaviorSubject<bool> loadingAccess;
  late BehaviorSubject<bool> includeInactive;
  final AccessRepo _accessRepo = AccessRepo();

  late BehaviorSubject<bool> nameTap;

  TextEditingController nameController = TextEditingController();
  ScrollController scrollController = ScrollController();

  int pageNumber = 1;
  int pageSize = 30;

  late ResAccessGroupModel resAccessGroupModel;

  bool isAppliedClicked = false;

  AccessGroupBloc() {
    accessState = subjectManager.createSubject<AccessState>(key: "accessState");
    filterAccessState = subjectManager.createSubject<AccessState>(
      key: "filterAccessState",
      seedValue: AccessState.completed(true),
    );
    loadingAccess = subjectManager.createSubject<bool>(key: "loadingAccess", seedValue: false);
    nameTap = subjectManager.createSubject<bool>(key: "nameTap", seedValue: false);
    includeInactive = subjectManager.createSubject<bool>(key: "includeInactive", seedValue: false);
  }

  void initData() {
    accessState.add(AccessState.loading());
    isAppliedClicked = false;
    pageNumber = 1;
    subscription.add(
      _accessRepo.getAccessGroup(pageSize, pageNumber).map((event) {
        if (!(event.error ?? true)) {
          resAccessGroupModel = event;
          accessState.add(AccessState.completed(true));
        } else {
          accessState.add(AccessState.error(true));
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        accessState.add(AccessState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResAccessGroupModel.fromJson(err.response?.data ?? {});
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
    nameController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void getFilterData() {
    isAppliedClicked = true;
    pageNumber = 1;
    filterAccessState.add(AccessState.loading());
    subscription.add(
      _accessRepo
          .getFilteredAccessGroup(
        pageSize: pageSize,
        pageNumber: pageNumber,
        name: nameController.text,
        inActive: includeInactive.value,
      )
          .map((event) {
        if (!(event.error ?? true)) {
          resAccessGroupModel = event;
          filterAccessState.add(AccessState.completed(true));
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
          filterAccessState.add(AccessState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        filterAccessState.add(AccessState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResAccessGroupModel.fromJson(err.response?.data ?? {});
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

  void undoDeleteAccess({required String id, bool delete = false}) {
    AppUtil.showLoader();
    ReqCrudOperationModel model = ReqCrudOperationModel(
      op: "Replace",
      path: "/Active",
      value: delete ? "false" : "true",
    );
    subscription.add(
      _accessRepo.undoAccess(id, model).map((event) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext!);
        if (!(event.error ?? true)) {
          if (event.data ?? false) {
            if (isAppliedClicked) {
              getFilterData();
              return;
            } else {
              initData();
              return;
            }
          } else {
            AppUtil.showSnackBar(label: "Something went wrong".i18n);
          }
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

  void scrollListener() {
    if (resAccessGroupModel.data!.list!.length < resAccessGroupModel.data!.count! &&
        !loadingAccess.value) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        loadingAccess.add(true);
        ++pageNumber;
        getPaginatedAccess();
      }
    }
  }

  void getPaginatedAccess() {
    if (isAppliedClicked) {
      getFilteredPaginatedData();
    } else {
      getPaginatedData();
    }
  }

  void getPaginatedData() {
    subscription.add(
      _accessRepo
          .getAccessGroup(pageSize, pageNumber)
          .map((event) {
            loadingAccess.add(false);
            if (!(event.error ?? true)) {
              resAccessGroupModel.data!.list!.addAll(event.data!.list!);
              filterAccessState.add(AccessState.completed(true));
            }
          })
          .onErrorReturnWith((error, stackTrace) => null)
          .listen((event) {}),
    );
  }

  void getFilteredPaginatedData() {
    subscription.add(
      _accessRepo
          .getFilteredAccessGroup(
        pageSize: pageSize,
        pageNumber: pageNumber,
        name: nameController.text,
        inActive: includeInactive.value,
      )
          .map((event) {
        loadingAccess.add(false);
        if (!(event.error ?? true)) {
          resAccessGroupModel.data!.list!.addAll(event.data!.list!);
          filterAccessState.add(AccessState.completed(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        loadingAccess.add(false);
      }).listen((event) {}),
    );
  }

  void resetValue() {
    isAppliedClicked = false;
    nameController.clear();
    includeInactive.add(false);
  }
}
