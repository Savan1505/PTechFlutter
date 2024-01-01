import 'package:ptecpos_mobile/core/utils/res_default_model.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/datasource/employee_datasource.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/model/req_employee_access_model.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/model/req_employee_model.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/model/res_add_employee_model.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/model/res_employee_model.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/model/res_store_roles_model.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/model/res_zip_model.dart';

class EmployeeRepo {
  final EmployeeDatasource employeeDatasource = EmployeeDatasource();

  Stream<ResEmployeeModel> getEmployeeList({required int pageNumber, required int pageSize}) {
    return employeeDatasource.getEmployeeList(pageNumber, pageSize);
  }

  Stream<ResDefaultModel> updateEmployeeAccess(List<ReqEmployeeAccessModel> data, String employeeId) {
    return employeeDatasource.updateEmployeeAccess(data, employeeId);
  }

  Stream<ResEmployeeModel> getEmployeeFilterList({
    required int pageNumber,
    required int pageSize,
    String? name,
    String? contact,
    int? userType,
  }) {
    return employeeDatasource.getEmployeeFilterList(pageNumber, pageSize, name, contact, userType);
  }

  Stream<ResStoreRolesModel> getStoreRoles() {
    return employeeDatasource.getStoreRoles();
  }

  Stream<ResZipModel> getAddressData(String zipCode) {
    return employeeDatasource.getAddressData(zipCode);
  }

  Stream<ResAddEmployeeModel> addEmployee(ReqEmployeeModel employeeModel) {
    return employeeDatasource.addEmployee(employeeModel);
  }

  Stream<ResDefaultModel> updateEmployee(ReqEmployeeModel employeeModel) {
    return employeeDatasource.updateEmployee(employeeModel);
  }

  Stream<ResAddEmployeeModel> getEmployee(String employeeId) {
    return employeeDatasource.getEmployee(employeeId);
  }
}
