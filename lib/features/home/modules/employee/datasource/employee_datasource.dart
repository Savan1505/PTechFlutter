import 'dart:convert';

import 'package:ptecpos_mobile/core/domain/datasource/api_manager.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/utils/api_constants.dart';
import 'package:ptecpos_mobile/core/utils/res_default_model.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/model/req_employee_access_model.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/model/req_employee_model.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/model/res_add_employee_model.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/model/res_employee_model.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/model/res_store_roles_model.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/model/res_zip_model.dart';

class EmployeeDatasource {
  Stream<ResEmployeeModel> getEmployeeList(int pageNumber, int pageSize) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.employeeListApi,
        queryParameters: {
          "Usage": 1,
          "StoreID": RootBloc.store?.id,
          "PageNumber": pageNumber,
          "PageSize": pageSize,
          "IncludeInactive": false,
        },
      ),
    ).map((event) {
      return ResEmployeeModel.fromJson(event.data);
    });
  }

  Stream<ResDefaultModel> updateEmployeeAccess(List<ReqEmployeeAccessModel> data, String employeeId) {
    return Stream.fromFuture(
      ApiManager().dio()!.patch(
            "${ApiConstants.employeeListApi}/$employeeId",
            data: json.encode(List<dynamic>.from(data.map((x) => x.toJson()))),
          ),
    ).map((event) {
      return ResDefaultModel.fromJson(event.data);
    });
  }

  Stream<ResEmployeeModel> getEmployeeFilterList(
    int pageNumber,
    int pageSize,
    String? name,
    String? contact,
    int? userType,
  ) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.employeeListApi,
        queryParameters: {
          "Usage": 1,
          "StoreID": RootBloc.store?.id,
          "PageNumber": pageNumber,
          "PageSize": pageSize,
          "IncludeInactive": false,
          "Name": name,
          "UserType": userType ?? 0,
          "ContactNo": contact,
        },
      ),
    ).map((event) {
      return ResEmployeeModel.fromJson(event.data);
    });
  }

  Stream<ResStoreRolesModel> getStoreRoles() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.storeRoles,
        queryParameters: {
          "IncludeInactive": false,
          "PageNumber": 1,
          "PageSize": 10000,
          "Usage": 0,
          "StrID": RootBloc.store?.id,
        },
      ),
    ).map((event) {
      return ResStoreRolesModel.fromJson(event.data);
    });
  }

  Stream<ResZipModel> getAddressData(String zipCode) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(ApiConstants.zipUtility, queryParameters: {"zip": zipCode}),
    ).map((event) {
      return ResZipModel.fromJson(event.data);
    });
  }

  Stream<ResAddEmployeeModel> addEmployee(ReqEmployeeModel employeeModel) {
    return Stream.fromFuture(
      ApiManager().dio()!.post(ApiConstants.addEmployee, data: employeeModel.toJson()),
    ).map((event) {
      return ResAddEmployeeModel.fromJson(event.data);
    });
  }

  Stream<ResDefaultModel> updateEmployee(ReqEmployeeModel employeeModel) {
    return Stream.fromFuture(
      ApiManager()
          .dio()!
          .put("${ApiConstants.addEmployee}/${employeeModel.id!}", data: employeeModel.toJson()),
    ).map((event) {
      return ResDefaultModel.fromJson(event.data);
    });
  }

  Stream<ResAddEmployeeModel> getEmployee(String employeeId) {
    return Stream.fromFuture(
      ApiManager().dio()!.get("${ApiConstants.addEmployee}/$employeeId"),
    ).map((event) {
      return ResAddEmployeeModel.fromJson(event.data);
    });
  }
}
