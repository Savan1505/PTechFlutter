// ignore_for_file: deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/utils/image_path.dart';
import 'package:ptecpos_mobile/core/widget/app_dropdown.dart';
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/bloc/employee_bloc.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/model/res_store_roles_model.dart';

class AddEmployeeV3 extends StatefulWidget {
  final EmployeeBloc employeeBloc;

  const AddEmployeeV3({super.key, required this.employeeBloc});

  @override
  State<AddEmployeeV3> createState() => _AddEmployeeV3State();
}

class _AddEmployeeV3State extends State<AddEmployeeV3> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.employeeBloc.formKeyV3,
      child: SingleChildScrollView(
        child: Padding(
          padding: AppPaddingConstants().leftRight25,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              StreamBuilder(
                stream: widget.employeeBloc.bloodGroupTap.stream,
                builder: (context, snapshot) {
                  return Focus(
                    onFocusChange: (val) {
                      widget.employeeBloc.bloodGroupTap.add(val);
                    },
                    child: AppTextField(
                      isFocused: widget.employeeBloc.bloodGroupTap.value,
                      label: "Blood Group".i18n,
                      textEditingController: widget.employeeBloc.bloodGroupController,
                      showError: false,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: widget.employeeBloc.languageTap.stream,
                builder: (context, snapshot) {
                  return Focus(
                    onFocusChange: (val) {
                      widget.employeeBloc.languageTap.add(val);
                    },
                    child: AppTextField(
                      isFocused: widget.employeeBloc.languageTap.value,
                      label: "Languages".i18n,
                      textEditingController: widget.employeeBloc.languageController,
                      showError: false,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: widget.employeeBloc.payRoleValue,
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      StreamBuilder(
                        stream: widget.employeeBloc.payRoleValueError,
                        builder: (context, snapshot) {
                          return AppDropdown(
                            hintText: "Role".i18n,
                            value: widget.employeeBloc.payRoleValue.valueOrNull,
                            borderColor: widget.employeeBloc.payRoleValueError.value
                                ? AppColors.redColor
                                : AppColors.colorTransparent,
                            items: widget.employeeBloc.resStoreRolesModel.data!.list!.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e.name!),
                              );
                            }).toList(),
                            onChanged: (Role? value) {
                              widget.employeeBloc.payRoleValue.add(value!);
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      StreamBuilder(
                        stream: widget.employeeBloc.payRoleValueError,
                        builder: (context, snapshot) {
                          return Visibility(
                            visible: widget.employeeBloc.payRoleValueError.value,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Select the role'.i18n,
                                style: AppTextStyle().errorStyle,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  AppTextField(
                    isFocused: false,
                    label: "Join Date".i18n,
                    readOnly: true,
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        DateTime? dateTime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppColors.colorPrimary,
                                ),
                              ),
                              child: child ?? Container(),
                            );
                          },
                        );

                        if (dateTime != null) {
                          String formattedDate = AppUtil.displayDateFormat(dateTime: dateTime)!;
                          widget.employeeBloc.joinDateController.text = formattedDate;
                          widget.employeeBloc.joinDate = dateTime;
                        }
                      },
                      child: SizedBox(
                        height: 16,
                        width: 16,
                        child: Padding(
                          padding: AppPaddingConstants().employeePagePadding1,
                          child: SvgPicture.asset(
                            icCalendarIcon,
                            color: AppColors.colorLightGrey100,
                          ),
                        ),
                      ),
                    ),
                    textEditingController: widget.employeeBloc.joinDateController,
                    showError: widget.employeeBloc.joinDateError.value,
                    validatorFunction: (value) {
                      if (value == null || value.isEmpty) {
                        widget.employeeBloc.joinDateError.add(true);
                      } else {
                        widget.employeeBloc.joinDateError.add(false);
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  StreamBuilder(
                    stream: widget.employeeBloc.joinDateError,
                    builder: (context, snapshot) {
                      return Visibility(
                        visible: widget.employeeBloc.joinDateError.value,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Select your joining date.'.i18n,
                            style: AppTextStyle().errorStyle,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: widget.employeeBloc.payRoleTypeValue,
                builder: (context, snapshot) {
                  return AppDropdown(
                    hintText: "Pay Role Type".i18n,
                    value: widget.employeeBloc.payRoleTypeValue.value,
                    items: widget.employeeBloc.payRoleType.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (value) {
                      widget.employeeBloc.payRoleTypeValue.add(value!);
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: widget.employeeBloc.payRoleAmountTap.stream,
                builder: (context, snapshot) {
                  return Focus(
                    onFocusChange: (val) {
                      widget.employeeBloc.payRoleAmountTap.add(val);
                    },
                    child: AppTextField(
                      isFocused: widget.employeeBloc.payRoleAmountTap.value,
                      label: "Pay Role Amount".i18n,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textEditingController: widget.employeeBloc.payRoleAmountController,
                      showError: false,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
