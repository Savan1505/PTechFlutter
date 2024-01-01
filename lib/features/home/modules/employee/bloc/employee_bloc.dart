import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ptecpos_mobile/core/base/base_bloc.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/routes/tab_navigator.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/utils/flavors.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/model/req_employee_model.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/model/res_store_roles_model.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/repo/employee_repo.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/state/employee_state.dart';
import 'package:rxdart/rxdart.dart';

class EmployeeBloc extends BaseBloc {
  ///Repo
  final EmployeeRepo _employeeRepo = EmployeeRepo();

  ///State
  BehaviorSubject<EmployeeState> employeeState = BehaviorSubject<EmployeeState>();

  ///Store roles
  late ResStoreRolesModel resStoreRolesModel;

  ///V1 Page Variables
  BehaviorSubject<bool> firstNameTap = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> lastNameTap = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> contactNoTap = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> emailTap = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> altContactTap = BehaviorSubject<bool>.seeded(false);

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController altContactController = TextEditingController();

  BehaviorSubject<bool> firstNameShowError = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> lastNameShowError = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> contactNoShowError = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> emailShowError = BehaviorSubject<bool>.seeded(false);

  String emailErrorMessage = "Please Enter Primary Email Address".i18n;
  String altEmailErrorMessage = "Please Enter Alternate Email Address".i18n;
  BehaviorSubject<XFile?> pickedImage = BehaviorSubject<XFile?>();
  final ImagePicker picker = ImagePicker();

  final formKeyV1 = GlobalKey<FormState>();

  ///V2 Page Variables
  BehaviorSubject<bool> altEmailTap = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<GenderOption> gender = BehaviorSubject<GenderOption>.seeded(GenderOption.gender);
  BehaviorSubject<bool> showGenderBox = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<String> selectedGender =
      BehaviorSubject<String>.seeded(GenderOption.gender.displayTitle);
  BehaviorSubject<bool> street1Tap = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> street2Tap = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> zipCodeTap = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> cityTap = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> stateTap = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> countryTap = BehaviorSubject<bool>.seeded(false);

  TextEditingController altEmailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  DateTime? dob;

  TextEditingController street1Controller = TextEditingController();
  TextEditingController street2Controller = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  BehaviorSubject<bool> altEmailShowError = BehaviorSubject<bool>.seeded(false);

  // BehaviorSubject<bool> dobShowError = BehaviorSubject<bool>.seeded(false);
  // BehaviorSubject<bool> genderShowError = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> street1Error = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> street2Error = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> zipCodeShowError = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> cityShowError = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> stateShowError = BehaviorSubject<bool>.seeded(false);

  bool isZipCodeValid = false;

  final formKeyV2 = GlobalKey<FormState>();

  ///V3 Page Variables
  BehaviorSubject<bool> bloodGroupTap = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> languageTap = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> payRoleAmountTap = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<Role> payRoleValue = BehaviorSubject<Role>();
  BehaviorSubject<String> payRoleTypeValue = BehaviorSubject<String>.seeded("None");

  TextEditingController countryController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController joinDateController = TextEditingController();
  DateTime? joinDate;
  TextEditingController payRoleAmountController = TextEditingController();

  BehaviorSubject<bool> countryShowError = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> joinDateError = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> payRoleValueError = BehaviorSubject<bool>.seeded(false);

  List<String> payRoleType = [
    "None".i18n,
    "Daily".i18n,
    "Hourly".i18n,
    "Weekly".i18n,
    "Monthly".i18n,
  ];

  final formKeyV3 = GlobalKey<FormState>();

  ///V4 Page Variables

  final formKeyV4 = GlobalKey<FormState>();

  BehaviorSubject<bool> posUser = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> pinTap = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> confirmPinTap = BehaviorSubject<bool>.seeded(false);

  TextEditingController posPinController = TextEditingController();
  TextEditingController posConfirmPinController = TextEditingController();

  BehaviorSubject<bool> pinError = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> confirmPinError = BehaviorSubject<bool>.seeded(false);

  bool isPinObscured = true;
  bool isConfirmPinObscured = true;
  String confirmPinErrorMessage = "Enter a valid confirm pin code".i18n;

  ///Common Variables
  PageController pageViewController = PageController();
  BehaviorSubject<int> currentPageIndex = BehaviorSubject<int>.seeded(0);
  String? employeeId;

  void initData(String? employeeId) {
    if (employeeId?.isEmpty ?? true) {
      employeeState.add(EmployeeState.loading());
      subscription.add(
        _employeeRepo.getStoreRoles().map((event) {
          if (!(event.error ?? true)) {
            resStoreRolesModel = event;
            employeeState.add(EmployeeState.completed(true));
          } else {
            AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
            employeeState.add(EmployeeState.error(true));
          }
        }).onErrorReturnWith((error, stackTrace) {
          debugPrint(error.toString());
          debugPrint(stackTrace.toString());
          employeeState.add(EmployeeState.error(true));
          if (error is DioException) {
            var err = error;
            var res = ResStoreRolesModel.fromJson(err.response?.data ?? {});
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
      this.employeeId = employeeId;
      employeeState.add(EmployeeState.loading());
      subscription.add(
        ZipStream.zip2(_employeeRepo.getStoreRoles(), _employeeRepo.getEmployee(employeeId!),
            (resStoreRolesModel, resAddEmployeeModel) {
          if (!(resStoreRolesModel.error ?? true) && !(resAddEmployeeModel.error ?? true)) {
            this.resStoreRolesModel = resStoreRolesModel;
            firstNameController.text = resAddEmployeeModel.data!.firstName!;
            lastNameController.text = resAddEmployeeModel.data!.lastName!;
            contactNoController.text = resAddEmployeeModel.data!.primaryMobile!;
            emailController.text = resAddEmployeeModel.data!.primaryEmail!;
            altEmailController.text = resAddEmployeeModel.data?.secondaryEmail ?? "";
            altContactController.text = resAddEmployeeModel.data?.secondaryMobile ?? "";
            if (resAddEmployeeModel.data!.gender == 1) {
              selectedGender.add("Male".i18n);
            } else if (resAddEmployeeModel.data!.gender == 2) {
              selectedGender.add("Female".i18n);
            } else if (resAddEmployeeModel.data!.gender == 3) {
              selectedGender.add("Rather not to say".i18n);
            } else {
              selectedGender.add("Gender".i18n);
            }
            Role role = this
                .resStoreRolesModel
                .data!
                .list!
                .where((element) => element.id!.compareTo(resAddEmployeeModel.data!.storeRoleId!) == 0)
                .first;
            payRoleValue.add(role);
            posUser.add(resAddEmployeeModel.data!.posUser!);
            if (resAddEmployeeModel.data?.dob != null) {
              if (resAddEmployeeModel.data?.dob.toString().isNotEmpty ?? false) {
                dobController.text =
                    AppUtil.displayDateFormat(dateTime: resAddEmployeeModel.data!.dob!)!;
                dob = resAddEmployeeModel.data!.dob!;
              }
            }
            bloodGroupController.text = resAddEmployeeModel.data?.bloodGroup ?? "";
            if (resAddEmployeeModel.data?.joinDate != null) {
              if (resAddEmployeeModel.data?.joinDate.toString().isNotEmpty ?? false) {
                joinDateController.text =
                    AppUtil.displayDateFormat(dateTime: resAddEmployeeModel.data!.joinDate!)!;
                joinDate = resAddEmployeeModel.data!.joinDate!;
              }
            }
            if (resAddEmployeeModel.data?.payroleAmount.toString().isNotEmpty ?? false) {
              payRoleAmountController.text =
                  ((resAddEmployeeModel.data?.payroleAmount?.toString().isNotEmpty ?? false)
                      ? resAddEmployeeModel.data!.payroleAmount?.toInt().toString()
                      : "0")!;
            }
            if (resAddEmployeeModel.data?.payroleType != null) {
              if (resAddEmployeeModel.data?.payroleType == 0) {
                payRoleTypeValue.add("None".i18n);
              } else if (resAddEmployeeModel.data?.payroleType == 1) {
                payRoleTypeValue.add("Daily".i18n);
              } else if (resAddEmployeeModel.data?.payroleType == 2) {
                payRoleTypeValue.add("Hourly".i18n);
              } else if (resAddEmployeeModel.data?.payroleType == 3) {
                payRoleTypeValue.add("Weekly".i18n);
              } else {
                payRoleTypeValue.add("Monthly".i18n);
              }
            }
            languageController.text = resAddEmployeeModel.data?.language ?? "";
            zipCodeController.text = resAddEmployeeModel.data?.pinCode ?? "";
            if (zipCodeController.text.isNotEmpty) {
              isZipCodeValid = true;
            } else {
              isZipCodeValid = false;
            }
            cityController.text = resAddEmployeeModel.data?.city ?? "";
            stateController.text = resAddEmployeeModel.data?.state ?? "";
            countryController.text = resAddEmployeeModel.data?.country ?? "";
            street1Controller.text = resAddEmployeeModel.data?.street1 ?? "";
            street2Controller.text = resAddEmployeeModel.data?.street2 ?? "";
            employeeState.add(EmployeeState.completed(true));
          }
        }).onErrorReturnWith((error, stackTrace) {
          debugPrint(error.toString());
          employeeState.add(EmployeeState.error(true));
          if (error is DioException) {
            var err = error;
            var res = ResStoreRolesModel.fromJson(err.response?.data ?? {});
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

  bool checkV1Validation() {
    if ((!firstNameShowError.value && firstNameController.text.isNotEmpty) &&
        (!lastNameShowError.value && lastNameController.text.isNotEmpty) &&
        (!contactNoShowError.value && contactNoController.text.isNotEmpty) &&
        (!emailShowError.value && emailController.text.isNotEmpty)) {
      return true;
    }
    return false;
  }

  bool checkV2Validation() {
    if ((!altEmailShowError.value) &&
        // (!dobShowError.value && dobController.text.isNotEmpty) &&
        // (!genderShowError.value &&
        //     (selectedGender.value.compareTo(GenderOption.gender.displayTitle) == 1)) &&
        (!street1Error.value && street1Controller.text.isNotEmpty) &&
        (!street2Error.value && street2Controller.text.isNotEmpty) &&
        (!zipCodeShowError.value && zipCodeController.text.isNotEmpty) &&
        (!cityShowError.value && cityController.text.isNotEmpty) &&
        (!stateShowError.value && stateController.text.isNotEmpty) &&
        (!countryShowError.value && countryController.text.isNotEmpty)) {
      if (!isZipCodeValid) {
        // AppUtil.showSnackBar(
        //   label: "Enter a valid zip code".i18n,
        // );
        return false;
      }
      return true;
    }
    return false;
  }

  bool checkV3Validation() {
    if ((!joinDateError.value && joinDateController.text.isNotEmpty)) {
      if (payRoleValue.valueOrNull == null) {
        payRoleValueError.add(true);
      } else {
        payRoleValueError.add(false);
        return true;
      }
    }
    if (payRoleValue.valueOrNull == null) {
      payRoleValueError.add(true);
    } else {
      payRoleValueError.add(false);
    }
    return false;
  }

  bool checkV4Validation() {
    if (posUser.value) {
      if ((!pinError.value && posPinController.text.isNotEmpty) &&
          (!confirmPinError.value && posConfirmPinController.text.isNotEmpty)) {
        return true;
      }
      return false;
    }
    return true;
  }

  void zipCode(String zipCode) {
    subscription.add(
      _employeeRepo.getAddressData(zipCode).map((event) {
        if (!(event.error ?? true)) {
          if (event.data != null) {
            cityController.text = event.data!.city!;
            stateController.text = event.data!.state!;
            countryController.text = event.data!.country!;
            isZipCodeValid = true;
          } else {
            isZipCodeValid = false;
            AppUtil.showSnackBar(
              label: "Please enter a valid zipcode".i18n,
            );
          }
        } else {
          isZipCodeValid = false;
          AppUtil.showSnackBar(
            label: "Please enter a valid zipcode".i18n,
          );
        }
      }).onErrorReturnWith((error, stackTrace) {
        isZipCodeValid = false;
        AppUtil.showSnackBar(
          label: "Please enter a valid zipcode".i18n,
        );
      }).listen((event) {}),
    );
  }

  Future<void> postData() async {
    AppUtil.showLoader();
    ReqEmployeeModel reqEmployeeModel = ReqEmployeeModel(
      id: employeeId?.isNotEmpty ?? false ? employeeId : Flavors.getGuid(),
      authUserId: null,
      storeId: RootBloc.store?.id,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      primaryMobile: contactNoController.text,
      primaryEmail: emailController.text,
      secondaryMobile: altContactController.text,
      secondaryEmail: altEmailController.text,
      gender: getGenderEnum(),
      storeRoleId: payRoleValue.value.id!,
      webUser: !posUser.value,
      posUser: posUser.value,
      dob: AppUtil.backendDateFormat(dateTime: dob),
      bloodGroup: bloodGroupController.text,
      userName: "",
      password: "",
      confirmPassword: "",
      pin: posPinController.text,
      confirmPin: posConfirmPinController.text,
      joinDate: AppUtil.backendDateFormat(dateTime: joinDate),
      payroleAmount:
          payRoleAmountController.text.isNotEmpty ? int.tryParse(payRoleAmountController.text) : 0,
      payroleType: payRoleTypeEnum(),
      language: languageController.text,
      area: "",
      pinCode: zipCodeController.text,
      city: cityController.text,
      state: stateController.text,
      country: countryController.text,
      addressId: Flavors.getGuid(),
      image: await _getUserImage(),
      additionalData: "",
      street1: street1Controller.text,
      street2: street2Controller.text,
      landmark: "",
      pinHash: "",
    );
    if (employeeId?.isNotEmpty ?? false) {
      subscription.add(
        _employeeRepo.updateEmployee(reqEmployeeModel).map((event) {
          AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
          if (!(event.error ?? true)) {
            AppUtil.showSnackBar(label: "Employee updated successfully".i18n);
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
          AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
          AppUtil.showSnackBar(
            label: "Something went wrong".i18n,
          );
        }).listen((event) {}),
      );
    } else {
      subscription.add(
        _employeeRepo.addEmployee(reqEmployeeModel).map((event) {
          AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
          if (!(event.error ?? true)) {
            AppUtil.showSnackBar(label: "Employee added successfully".i18n);
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
          AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
          AppUtil.showSnackBar(
            label: "Something went wrong".i18n,
          );
        }).listen((event) {}),
      );
    }
  }

  int payRoleTypeEnum() {
    if (payRoleTypeValue.value.compareTo("None".i18n) == 0) {
      return 0;
    } else if (payRoleTypeValue.value.compareTo("Daily".i18n) == 0) {
      return 1;
    } else if (payRoleTypeValue.value.compareTo("Hourly".i18n) == 0) {
      return 2;
    } else if (payRoleTypeValue.value.compareTo("Weekly".i18n) == 0) {
      return 3;
    } else {
      return 4;
    }
  }

  int getGenderEnum() {
    if (selectedGender.value.compareTo("Male") == 0) {
      return 1;
    } else if (selectedGender.value.compareTo("Female") == 0) {
      return 2;
    } else {
      return 3;
    }
  }

  Future<String?> _getUserImage() async {
    if (pickedImage.valueOrNull != null) {
      List<int> imageBytes = await pickedImage.value!.readAsBytes();
      return base64Encode(imageBytes);
    }
    return "";
  }
}

enum GenderOption { male, female, other, gender }

extension ToString on GenderOption {
  String get displayTitle {
    switch (this) {
      case GenderOption.male:
        return 'Male'.i18n;
      case GenderOption.female:
        return 'Female'.i18n;
      case GenderOption.other:
        return 'Rather not to say'.i18n;
      default:
        return 'Gender'.i18n;
    }
  }
}
