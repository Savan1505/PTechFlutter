import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:ptecpos_mobile/core/base/base_bloc.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/model/res_employee_model.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/repo/employee_repo.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/state/employee_state.dart';
import 'package:rxdart/rxdart.dart';

class EmployeeListBloc extends BaseBloc {
  BehaviorSubject<EmployeeState> employeeState = BehaviorSubject<EmployeeState>();
  BehaviorSubject<EmployeeState> filterEmployeeState =
      BehaviorSubject<EmployeeState>.seeded(EmployeeState.completed(true));
  BehaviorSubject<bool> isSearchEnabled = BehaviorSubject<bool>.seeded(false);

  ScrollController scrollController = ScrollController();

  ///Filter variables
  TextEditingController contactController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  BehaviorSubject<bool> contactField = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<String> accessValue = BehaviorSubject<String>();
  List<String> access = ["Web Access".i18n, "Pos Access".i18n];

  bool isAppliedClick = false;
  BehaviorSubject<bool> loadingEmployees = BehaviorSubject<bool>.seeded(false);

  final EmployeeRepo _employeeRepo = EmployeeRepo();
  int pageNumber = 1;
  int pageSize = 10;
  late ResEmployeeModel resEmployeeModel;

  void getEmployee() {
    employeeState.add(EmployeeState.loading());
    pageNumber = 1;
    subscription.add(
      _employeeRepo.getEmployeeList(pageNumber: pageNumber, pageSize: pageSize).map((event) {
        if (!(event.error ?? true)) {
          resEmployeeModel = event;
          employeeState.add(EmployeeState.completed(true));
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
          employeeState.add(EmployeeState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        employeeState.add(EmployeeState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResEmployeeModel.fromJson(err.response?.data ?? {});
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

  void filteredEmployee({bool pageReset = true}) {
    if (pageReset) {
      pageNumber = 1;
      filterEmployeeState.add(EmployeeState.loading());
    }

    subscription.add(
      _employeeRepo
          .getEmployeeFilterList(
        pageNumber: pageNumber,
        pageSize: pageSize,
        contact: contactController.text,
        userType: getUserType(),
        name: nameController.text,
      )
          .map((event) {
        if (!(event.error ?? true)) {
          if (pageReset) {
            resEmployeeModel = event;
          } else {
            resEmployeeModel.data!.list!.addAll(event.data!.list!);
          }
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
        }
        if (pageReset) {
          filterEmployeeState.add(EmployeeState.completed(true));
        } else {
          employeeState.add(EmployeeState.completed(true));
        }
        loadingEmployees.add(false);
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        loadingEmployees.add(false);
      }).listen((event) {}),
    );
  }

  void applyFilteredEmployee() {
    pageNumber = 1;
    filterEmployeeState.add(EmployeeState.loading());

    subscription.add(
      _employeeRepo
          .getEmployeeFilterList(
        pageNumber: pageNumber,
        pageSize: pageSize,
        contact: contactController.text,
        userType: getUserType(),
        name: nameController.text,
      )
          .map((event) {
        if (!(event.error ?? true)) {
          resEmployeeModel = event;
          filterEmployeeState.add(EmployeeState.completed(true));
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
          filterEmployeeState.add(EmployeeState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        filterEmployeeState.add(EmployeeState.error(true));
      }).listen((event) {}),
    );
  }

  void scrollListener() {
    if (resEmployeeModel.data!.list!.length < resEmployeeModel.data!.count! && !loadingEmployees.value) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        loadingEmployees.add(true);
        ++pageNumber;

        getEmployeePaginated();
      }
    }
  }

  void getEmployeePaginated() {
    if (isAppliedClick) {
      filteredEmployee(pageReset: false);
    } else {
      searchedFilteredEmployee(pageReset: false);
    }
  }

  void searchedFilteredEmployee({bool pageReset = true}) {
    if (pageReset) {
      pageNumber = 1;
      filterEmployeeState.add(EmployeeState.loading());
    }

    subscription.add(
      _employeeRepo
          .getEmployeeFilterList(
        pageNumber: pageNumber,
        pageSize: pageSize,
        name: nameController.text,
      )
          .map((event) {
        if (!(event.error ?? true)) {
          if (pageReset) {
            resEmployeeModel = event;
          } else {
            resEmployeeModel.data!.list!.addAll(event.data!.list!);
          }
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
        }
        if (pageReset) {
          filterEmployeeState.add(EmployeeState.completed(true));
        } else {
          employeeState.add(EmployeeState.completed(true));
        }
        loadingEmployees.add(false);
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        loadingEmployees.add(false);
      }).listen((event) {}),
    );
  }

  int? getUserType() {
    if (isAppliedClick) {
      if (accessValue.value.compareTo("Web Access".i18n) == 0) {
        return 2;
      }
      return 1;
    }
    return null;
  }
}
