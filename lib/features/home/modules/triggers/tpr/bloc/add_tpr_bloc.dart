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
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_storeitem_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/req_trigger_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/req_trigger_update_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/res_trigger_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/res_trptriggers_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/repo/tpr_repo.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/state/tpr_state.dart';
import 'package:rxdart/rxdart.dart';

class AddTprBloc extends BaseBloc {
  bool updateCall = false;

  late BehaviorSubject<bool> qtyTap;
  late BehaviorSubject<bool> amtCalTap;
  late BehaviorSubject<TprState> tprState;

  late BehaviorSubject<bool> storeItemValueError;
  late BehaviorSubject<bool> packageItemValueError;
  late BehaviorSubject<bool> amtCalError;
  late BehaviorSubject<StoreItemElement?> storeItemValue;

  late BehaviorSubject<bool> startDateError;
  late BehaviorSubject<bool> endDateError;
  late BehaviorSubject<bool> qtyError;

  final TprRepo _tprRepo = TprRepo();

  late ResStoreItemModel resStoreItemModel;

  TextEditingController packageName = TextEditingController();

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController amtCalController = TextEditingController();

  late DateTime startDate;
  late DateTime endDate;

  List<TrpTriggers> primaryPackages = [];
  List<TrpTriggers> secondaryPackages = [];
  List<TrpTriggers> tertiaryPackages = [];
  late BehaviorSubject<TrpTriggers?> trpTriggers;
  late BehaviorSubject<Trigger?> trpTriggersPackage;

  List<String> amtCal = ["By Percentages".i18n, "By Amount".i18n];

  BehaviorSubject<String> amtCalValue = BehaviorSubject<String>();

  final formKey = GlobalKey<FormState>();

  AddTprBloc() {
    qtyTap = subjectManager.createSubject<bool>(key: "firstNameTap", seedValue: false);
    tprState = subjectManager.createSubject<TprState>(key: "tprState");
    storeItemValueError =
        subjectManager.createSubject<bool>(key: "storeItemValueError", seedValue: false);
    packageItemValueError =
        subjectManager.createSubject<bool>(key: "packageItemValueError", seedValue: false);
    storeItemValue = subjectManager.createSubject<StoreItemElement?>(key: "storeItemValue");
    trpTriggers = subjectManager.createSubject<TrpTriggers?>(key: "trpTriggers");
    trpTriggersPackage = subjectManager.createSubject<Trigger?>(key: "trpTriggersPackage");
    startDateError = subjectManager.createSubject<bool>(key: "startDateError", seedValue: false);
    endDateError = subjectManager.createSubject<bool>(key: "endDateError", seedValue: false);
    qtyError = subjectManager.createSubject<bool>(key: "qtyError", seedValue: false);
    amtCalValue = subjectManager.createSubject<String>(key: "amtCalValue", seedValue: amtCal.first);
    amtCalTap = subjectManager.createSubject<bool>(key: "amtCalTap", seedValue: false);
    amtCalError = subjectManager.createSubject<bool>(key: "amtCalError", seedValue: false);
  }

  void initData({String? id}) {
    if (id != null) {
      tprState.add(TprState.loading());
      subscription.add(
        ZipStream.zip2(_tprRepo.getStoreItem(), _tprRepo.getTrigger(id),
            (resStoreItemModel, resTriggerUpdateModel) {
          if (!(resStoreItemModel.error ?? true) && !(resTriggerUpdateModel.error ?? true)) {
            subscription.add(
              ZipStream.zip2(
                  _tprRepo.getPackageTrigger(
                    storeItemId: resTriggerUpdateModel.data!.storeItemId!,
                    packageId: resTriggerUpdateModel.data!.packReferenceId!,
                  ),
                  _tprRepo.getTriggerPackage(storeItemId: resTriggerUpdateModel.data!.storeItemId!),
                  (resTriggerModel, resTrpTriggersModel) {
                if (!(resTriggerModel.error ?? true) && !(resTrpTriggersModel.error ?? true)) {
                  this.resStoreItemModel = resStoreItemModel;
                  var storeItem = resStoreItemModel.data!.list!.firstWhere(
                    (element) => element.id!.compareTo(resTriggerUpdateModel.data!.storeItemId!) == 0,
                  );
                  storeItemValue.add(storeItem);
                  packageName.text = resTriggerUpdateModel.data!.packReferenceName!;
                  updateCall = true;

                  /// packageDetails
                  if (resTriggerModel.data!.list!.isNotEmpty) {
                    trpTriggersPackage.add(resTriggerModel.data!.list!.first);
                    startDateController.text = AppUtil.displayDateFormat(
                      dateTime: resTriggerModel.data!.list!.first.startDate!,
                    )!;
                    startDate = resTriggerModel.data!.list!.first.startDate!;

                    endDateController.text = AppUtil.displayDateFormat(
                      dateTime: resTriggerModel.data!.list!.first.endDate!,
                    )!;
                    endDate = resTriggerModel.data!.list!.first.endDate!;

                    qtyController.text = resTriggerModel.data!.list!.first.quantity!.toInt().toString();
                    if (resTriggerModel.data!.list!.first.reduceType == ReduceType.percentage) {
                      amtCalValue.add("By Percentages".i18n);
                      amtCalController.text =
                          resTriggerModel.data!.list!.first.reduceBy!.toInt().toString();
                    } else {
                      amtCalValue.add("By Amount".i18n);
                      amtCalController.text =
                          resTriggerModel.data!.list!.first.reduceBy!.toInt().toString();
                    }
                  }

                  /// ----- packageDetails

                  ///
                  var t1 = resTrpTriggersModel.data!.list!.firstWhere(
                    (element) => element.packageId == resTriggerUpdateModel.data!.packReferenceId!,
                  );
                  trpTriggers.add(t1);

                  ///

                  startDate = resTriggerUpdateModel.data!.startDate!;
                  startDateController.text =
                      AppUtil.displayDateFormat(dateTime: resTriggerUpdateModel.data!.startDate!)!;

                  endDate = resTriggerUpdateModel.data!.endDate!;
                  endDateController.text =
                      AppUtil.displayDateFormat(dateTime: resTriggerUpdateModel.data!.endDate!)!;
                  if (resTriggerUpdateModel.data!.reduceType == ReduceType.percentage) {
                    amtCalValue.add(amtCal.first);
                  } else {
                    amtCalValue.add(amtCal[1]);
                  }
                  amtCalController.text = resTriggerUpdateModel.data!.reduceBy.toInt().toString();

                  tprState.add(TprState.completed(true));
                } else {
                  updateCall = false;
                  tprState.add(TprState.error(true));
                  AppUtil.showSnackBar(
                    label: resStoreItemModel.message ??
                        resTriggerUpdateModel.message ??
                        "Something went wrong".i18n,
                  );
                }
              }).listen((value) {}),
            );
          } else {
            updateCall = false;
            tprState.add(TprState.error(true));
            AppUtil.showSnackBar(
              label: resStoreItemModel.message ??
                  resTriggerUpdateModel.message ??
                  "Something went wrong".i18n,
            );
          }
        }).onErrorReturnWith((error, stackTrace) {
          debugPrint(error.toString());
          debugPrint(stackTrace.toString());
          tprState.add(TprState.error(true));
          if (error is DioException) {
            var err = error;
            var res = ResStoreItemModel.fromJson(err.response?.data ?? {});
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
    } else {
      tprState.add(TprState.loading());
      subscription.add(
        _tprRepo.getStoreItem().map((event) {
          if (!(event.error ?? true)) {
            resStoreItemModel = event;
            tprState.add(TprState.completed(true));
          } else {
            tprState.add(TprState.error(true));
            AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
          }
        }).onErrorReturnWith((error, stackTrace) {
          debugPrint(error.toString());
          debugPrint(stackTrace.toString());
          tprState.add(TprState.error(true));
          if (error is DioException) {
            var err = error;
            var res = ResStoreItemModel.fromJson(err.response?.data ?? {});
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
  }

  void getPackageDetails(String storeItemID) {
    subscription.add(
      _tprRepo.getTriggerPackage(storeItemId: storeItemID).map((event) {
        if (!(event.error ?? true)) {
          primaryPackages = event.data!.list!
              .where((element) => element.packageType == StoreItemPackageType.primary)
              .toList();

          secondaryPackages = event.data!.list!
              .where((element) => element.packageType == StoreItemPackageType.secondary)
              .toList();
          tertiaryPackages = event.data!.list!
              .where((element) => element.packageType == StoreItemPackageType.tertiary)
              .toList();
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        AppUtil.showSnackBar(label: "Something went wrong".i18n);
      }).listen((event) {}),
    );
  }

  void packageDetails({required String storeItemId, required String packageId}) {
    subscription.add(
      _tprRepo.getPackageTrigger(storeItemId: storeItemId, packageId: packageId).map((event) {
        if (!(event.error ?? true)) {
          if (event.data!.list!.isNotEmpty) {
            updateCall = true;
            trpTriggersPackage.add(event.data!.list!.first);
            startDateController.text =
                AppUtil.displayDateFormat(dateTime: event.data!.list!.first.startDate!)!;
            startDate = event.data!.list!.first.startDate!;

            endDateController.text =
                AppUtil.displayDateFormat(dateTime: event.data!.list!.first.endDate!)!;
            endDate = event.data!.list!.first.endDate!;

            qtyController.text = event.data!.list!.first.quantity!.toInt().toString();
            if (event.data!.list!.first.reduceType == ReduceType.percentage) {
              amtCalValue.add("By Percentages".i18n);
              amtCalController.text = event.data!.list!.first.reduceBy!.toInt().toString();
            } else {
              amtCalValue.add("By Amount".i18n);
              amtCalController.text = event.data!.list!.first.reduceBy!.toInt().toString();
            }
          }
        } else {
          updateCall = false;
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        updateCall = false;
      }).listen((event) {}),
    );
  }

  bool checkValidation() {
    if ((!qtyError.value && qtyController.text.isNotEmpty) &&
        (!amtCalError.value && amtCalController.text.isNotEmpty)) {
      if (storeItemValue.valueOrNull == null) {
        storeItemValueError.add(true);
        return false;
      }
      if (packageName.text.isEmpty) {
        packageItemValueError.add(true);
        return false;
      }
      if (startDateController.text.isEmpty) {
        startDateError.add(true);
        return false;
      }
      if (endDateController.text.isEmpty) {
        endDateError.add(true);
        return false;
      }
      if (trpTriggers.valueOrNull != null) {
        if (amtCalValue.value.compareTo(amtCal.first) == 0) {
          String price = (trpTriggers.value!.retailPrice! -
                  ((trpTriggers.value!.retailPrice!) * double.parse(amtCalController.text)) / 100)
              .toStringAsFixed(2);
          if (double.parse(price) < trpTriggers.value!.unitCost!) {
            AppUtil.showSnackBar(
              label: "Can not be less than Unit Cost (${trpTriggers.value!.unitCost}) $price",
            );
            return false;
          }
        } else {
          if (double.parse(amtCalController.text) >= trpTriggers.value!.unitCost!) {
            if (trpTriggers.value!.retailPrice! < double.parse(amtCalController.text)) {
              /// show snack bar
              if (double.parse(amtCalController.text) > trpTriggers.value!.retailPrice!) {
                AppUtil.showSnackBar(
                  label: "Can not be greater than Retail Price (${trpTriggers.value!.retailPrice})",
                );
              } else {
                AppUtil.showSnackBar(
                  label: "Can not be less than Retail Price (${trpTriggers.value!.retailPrice})",
                );
              }

              return false;
            }
          } else {
            /// Show snack bar
            AppUtil.showSnackBar(
              label: "Can not be less than Unit Price (${trpTriggers.value!.unitCost})",
            );
            return false;
          }
        }
      }

      endDateError.add(false);
      startDateError.add(false);
      packageItemValueError.add(false);
      storeItemValueError.add(false);
      return true;
    }

    /// False condition
    if (storeItemValue.valueOrNull == null) {
      storeItemValueError.add(true);
    } else {
      storeItemValueError.add(false);
    }
    if (packageName.text.isEmpty) {
      packageItemValueError.add(true);
    } else {
      packageItemValueError.add(false);
    }
    if (startDateController.text.isEmpty) {
      startDateError.add(true);
    } else {
      startDateError.add(false);
    }
    if (endDateController.text.isEmpty) {
      endDateError.add(true);
    } else {
      endDateError.add(false);
    }
    return false;
  }

  void addTrigger() {
    if (!updateCall) {
      AppUtil.showLoader();
      ReqTriggerModel reqTriggerModel = ReqTriggerModel(
        storeItemId: storeItemValue.value?.id,
        storeId: RootBloc.store?.id,
        startDate: AppUtil.backendDateFormat(dateTime: startDate),
        endDate: AppUtil.backendDateFormat(dateTime: endDate),
        quantity: int.tryParse(qtyController.text).toString(),
        reduceType: amtCalValue.value.compareTo("By Percentages".i18n) == 0
            ? ReduceType.percentage.toString()
            : ReduceType.amount.toString(),
        reduceBy: amtCalController.text,
        tprStoreItemPackageList: [
          TprStoreItemPackageList(
            packReferenceId: trpTriggers.value?.packageId,
            packReferenceType: trpTriggers.value?.packageType,
          ),
        ],
      );
      subscription.add(
        _tprRepo.postTrigger(reqTriggerModel).map((event) {
          AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
          if (!(event.error ?? true)) {
            AppUtil.showSnackBar(label: "TPR added successfully".i18n);
            TabNavigatorRouter(
              navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
              currentPageKey: AppRouteManager.currentPage,
            ).pop();
          } else {
            AppUtil.showSnackBar(
              label: event.message ?? "Something went wrong".i18n,
            );
          }
        }).onErrorReturnWith((error, stackTrace) {
          debugPrint(error.toString());
          debugPrint(stackTrace.toString());
          AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentState!.context);
          AppUtil.showSnackBar(
            label: "Something went wrong".i18n,
          );
        }).listen((event) {}),
      );
    } else {
      AppUtil.showLoader();
      ReqTriggerUpdateModel model = ReqTriggerUpdateModel(
        id: trpTriggersPackage.value?.id,
        reduceBy: amtCalValue.value.compareTo(amtCal.first) == 0
            ? int.tryParse(amtCalController.text)
            : amtCalController.text,
        reduceType: amtCalValue.value.compareTo(amtCal.first) == 0
            ? ReduceType.percentage.toString()
            : ReduceType.amount.toString(),
        quantity: int.parse(qtyController.text),
        startDate: AppUtil.backendDateFormat(dateTime: startDate),
        endDate: AppUtil.backendDateFormat(dateTime: endDate),
        storeItemId: storeItemValue.value?.id,
        tprStoreItemPackageList: [
          TprStoreItemPackageList(
            packReferenceId: trpTriggers.value?.packageId,
            packReferenceType: trpTriggers.value?.packageType,
          ),
        ],
      );
      subscription.add(
        _tprRepo.updateTrigger(model, trpTriggersPackage.value!.id!).map((event) {
          AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
          if (!(event.error ?? true)) {
            AppUtil.showSnackBar(label: "TPR updated successfully".i18n);
            TabNavigatorRouter(
              navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
              currentPageKey: AppRouteManager.currentPage,
            ).pop();
          } else {
            AppUtil.showSnackBar(
              label: event.message ?? "Something went wrong".i18n,
            );
          }
        }).onErrorReturnWith((error, stackTrace) {
          debugPrint(error.toString());
          debugPrint(stackTrace.toString());
          AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentState!.context);
          AppUtil.showSnackBar(
            label: "Something went wrong".i18n,
          );
        }).listen((event) {}),
      );
    }
  }

  void resetValue() {
    packageName.clear();
    trpTriggers.add(null);
    startDateController.clear();
    endDateController.clear();
    qtyController.clear();
    amtCalController.clear();
    amtCalValue.add(amtCal.first);
  }
}
