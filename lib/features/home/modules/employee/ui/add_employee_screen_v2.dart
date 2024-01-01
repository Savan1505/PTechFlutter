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
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/bloc/employee_bloc.dart';

class AddEmployeeV2 extends StatefulWidget {
  final EmployeeBloc employeeBloc;

  const AddEmployeeV2({super.key, required this.employeeBloc});

  @override
  State<AddEmployeeV2> createState() => _AddEmployeeV2State();
}

class _AddEmployeeV2State extends State<AddEmployeeV2> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.employeeBloc.formKeyV2,
      child: Padding(
        padding: AppPaddingConstants().leftRight25,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 35,
              ),
              StreamBuilder(
                stream: widget.employeeBloc.altEmailTap.stream,
                builder: (context, snapshot) {
                  return Focus(
                    onFocusChange: (val) {
                      widget.employeeBloc.altEmailTap.add(val);
                    },
                    child: Column(
                      children: [
                        AppTextField(
                          isFocused: widget.employeeBloc.altEmailTap.value,
                          label: "Alternate Email Address".i18n,
                          textEditingController: widget.employeeBloc.altEmailController,
                          showError: widget.employeeBloc.altEmailShowError.value,
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              widget.employeeBloc.altEmailTap.add(widget.employeeBloc.altEmailTap.value);
                              widget.employeeBloc.altEmailShowError.add(false);
                            } else {
                              if (!AppUtil().isEmailValid(value)) {
                                widget.employeeBloc.altEmailTap
                                    .add(widget.employeeBloc.altEmailTap.value);
                                widget.employeeBloc.altEmailErrorMessage =
                                    "Please enter a valid alt email id".i18n;
                                widget.employeeBloc.altEmailShowError.add(true);
                              } else {
                                widget.employeeBloc.altEmailErrorMessage =
                                    "Please Enter Alternate Email Address".i18n;
                                widget.employeeBloc.altEmailTap
                                    .add(widget.employeeBloc.altEmailTap.value);
                                widget.employeeBloc.altEmailShowError.add(false);
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        StreamBuilder(
                          stream: widget.employeeBloc.altEmailShowError,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: widget.employeeBloc.altEmailShowError.value,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.employeeBloc.altEmailErrorMessage,
                                  style: AppTextStyle().errorStyle,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              AppTextField(
                isFocused: false,
                label: "DOB".i18n,
                readOnly: true,
                suffixIcon: GestureDetector(
                  onTap: () async {
                    DateTime? dateTime = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().subtract(const Duration(days: 1)),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now().subtract(const Duration(days: 1)),
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
                      widget.employeeBloc.dobController.text = formattedDate;
                      widget.employeeBloc.dob = dateTime;
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

                textEditingController: widget.employeeBloc.dobController,
                showError: false,
                // validatorFunction: (value) {
                //   if (value == null || value.isEmpty) {
                //     widget.employeeBloc.dobShowError.add(true);
                //   } else {
                //     widget.employeeBloc.dobShowError.add(false);
                //   }
                //   return null;
                // },
              ),
              const SizedBox(
                height: 20,
              ),
              genderBoxWidget(),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: widget.employeeBloc.street1Tap.stream,
                builder: (context, snapshot) {
                  return Focus(
                    onFocusChange: (val) {
                      widget.employeeBloc.street1Tap.add(val);
                    },
                    child: Column(
                      children: [
                        AppTextField(
                          isFocused: widget.employeeBloc.street1Tap.value,
                          label: "Street 1".i18n,
                          textEditingController: widget.employeeBloc.street1Controller,
                          showError: widget.employeeBloc.street1Error.value,
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              widget.employeeBloc.street1Tap.add(widget.employeeBloc.street1Tap.value);
                              widget.employeeBloc.street1Error.add(true);
                            } else {
                              widget.employeeBloc.street1Tap.add(widget.employeeBloc.street1Tap.value);
                              widget.employeeBloc.street1Error.add(false);
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        StreamBuilder(
                          stream: widget.employeeBloc.street1Error,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: widget.employeeBloc.street1Error.value,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Street1 can’t be left blank.'.i18n,
                                  style: AppTextStyle().errorStyle,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: widget.employeeBloc.street2Tap.stream,
                builder: (context, snapshot) {
                  return Focus(
                    onFocusChange: (val) {
                      widget.employeeBloc.street2Tap.add(val);
                    },
                    child: Column(
                      children: [
                        AppTextField(
                          isFocused: widget.employeeBloc.street2Tap.value,
                          label: "Street 2".i18n,
                          textEditingController: widget.employeeBloc.street2Controller,
                          showError: widget.employeeBloc.street2Error.value,
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              widget.employeeBloc.street2Tap.add(widget.employeeBloc.street2Tap.value);
                              widget.employeeBloc.street2Error.add(true);
                            } else {
                              widget.employeeBloc.street2Tap.add(widget.employeeBloc.street2Tap.value);
                              widget.employeeBloc.street2Error.add(false);
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        StreamBuilder(
                          stream: widget.employeeBloc.street2Error,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: widget.employeeBloc.street2Error.value,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Street2 can’t be left blank.'.i18n,
                                  style: AppTextStyle().errorStyle,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: widget.employeeBloc.zipCodeTap.stream,
                builder: (context, snapshot) {
                  return Focus(
                    onFocusChange: (val) {
                      widget.employeeBloc.zipCodeTap.add(val);
                    },
                    child: Column(
                      children: [
                        AppTextField(
                          isFocused: widget.employeeBloc.zipCodeTap.value,
                          label: "Zip Code".i18n,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          textEditingController: widget.employeeBloc.zipCodeController,
                          showError: widget.employeeBloc.zipCodeShowError.value,
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              widget.employeeBloc.zipCodeTap.add(widget.employeeBloc.zipCodeTap.value);
                              widget.employeeBloc.zipCodeShowError.add(true);
                            } else {
                              widget.employeeBloc.zipCodeTap.add(widget.employeeBloc.zipCodeTap.value);
                              widget.employeeBloc.zipCodeShowError.add(false);
                            }
                            return null;
                          },
                          onChangeFunction: (val) {
                            if (val != null) {
                              if ((val.length >= 5)) {
                                widget.employeeBloc.zipCode(val);
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        StreamBuilder(
                          stream: widget.employeeBloc.zipCodeShowError,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: widget.employeeBloc.zipCodeShowError.value,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Enter a valid ZIP code'.i18n,
                                  style: AppTextStyle().errorStyle,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: widget.employeeBloc.cityTap.stream,
                builder: (context, snapshot) {
                  return Focus(
                    onFocusChange: (val) {
                      widget.employeeBloc.cityTap.add(val);
                    },
                    child: Column(
                      children: [
                        AppTextField(
                          isFocused: widget.employeeBloc.cityTap.value,
                          label: "City".i18n,
                          textEditingController: widget.employeeBloc.cityController,
                          showError: widget.employeeBloc.cityShowError.value,
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              widget.employeeBloc.cityTap.add(widget.employeeBloc.cityTap.value);
                              widget.employeeBloc.cityShowError.add(true);
                            } else {
                              widget.employeeBloc.cityTap.add(widget.employeeBloc.cityTap.value);
                              widget.employeeBloc.cityShowError.add(false);
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        StreamBuilder(
                          stream: widget.employeeBloc.cityShowError,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: widget.employeeBloc.cityShowError.value,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Enter a valid city name'.i18n,
                                  style: AppTextStyle().errorStyle,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: widget.employeeBloc.stateTap.stream,
                builder: (context, snapshot) {
                  return Focus(
                    onFocusChange: (val) {
                      widget.employeeBloc.stateTap.add(val);
                    },
                    child: Column(
                      children: [
                        AppTextField(
                          isFocused: widget.employeeBloc.stateTap.value,
                          label: "State".i18n,
                          textEditingController: widget.employeeBloc.stateController,
                          showError: widget.employeeBloc.stateShowError.value,
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              widget.employeeBloc.stateTap.add(widget.employeeBloc.stateTap.value);
                              widget.employeeBloc.stateShowError.add(true);
                            } else {
                              widget.employeeBloc.stateTap.add(widget.employeeBloc.stateTap.value);
                              widget.employeeBloc.stateShowError.add(false);
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        StreamBuilder(
                          stream: widget.employeeBloc.stateShowError,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: widget.employeeBloc.stateShowError.value,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Enter a valid state name'.i18n,
                                  style: AppTextStyle().errorStyle,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: widget.employeeBloc.countryTap.stream,
                builder: (context, snapshot) {
                  return Focus(
                    onFocusChange: (val) {
                      widget.employeeBloc.countryTap.add(val);
                    },
                    child: Column(
                      children: [
                        AppTextField(
                          isFocused: widget.employeeBloc.countryTap.value,
                          label: "Country".i18n,
                          textEditingController: widget.employeeBloc.countryController,
                          showError: widget.employeeBloc.countryShowError.value,
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              widget.employeeBloc.countryTap.add(widget.employeeBloc.countryTap.value);
                              widget.employeeBloc.countryShowError.add(true);
                            } else {
                              widget.employeeBloc.countryTap.add(widget.employeeBloc.countryTap.value);
                              widget.employeeBloc.countryShowError.add(false);
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        StreamBuilder(
                          stream: widget.employeeBloc.countryShowError,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: widget.employeeBloc.countryShowError.value,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Enter a valid Country name'.i18n,
                                  style: AppTextStyle().errorStyle,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 130,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget genderBoxWidget() {
    return Focus(
      autofocus: true,
      onFocusChange: (value) {
        if (!value) {
          widget.employeeBloc.showGenderBox.add(false);
        }
      },
      child: StreamBuilder(
        stream: widget.employeeBloc.showGenderBox.stream,
        builder: (context, snapshot) {
          if (widget.employeeBloc.showGenderBox.value) {
            return Neumorphic(
              style: const NeumorphicStyle(
                depth: -4,
                color: AppColors.colorWhite,
                shadowDarkColorEmboss: AppColors.colorInnerShadowPrimary,
                surfaceIntensity: 1,
                intensity: 1,
              ),
              child: Container(
                color: AppColors.colorWhite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.employeeBloc.showGenderBox.add(!widget.employeeBloc.showGenderBox.value);
                      },
                      child: Container(
                        color: AppColors.colorTransparent,
                        child: Row(
                          children: [
                            Padding(
                              padding: AppPaddingConstants().left25,
                              child: StreamBuilder(
                                stream: widget.employeeBloc.selectedGender,
                                builder: (context, snapshot) {
                                  return Text(
                                    widget.employeeBloc.selectedGender.value,
                                    style: AppTextStyle().homeStyle.copyWith(
                                          fontSize: 16,
                                        ),
                                  );
                                },
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: AppPaddingConstants().right10,
                              child: const Icon(
                                Icons.keyboard_arrow_up_rounded,
                                size: 35,
                                color: AppColors.colorLightGrey100,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.employeeBloc.selectedGender.add(GenderOption.male.displayTitle);
                        widget.employeeBloc.showGenderBox.add(!widget.employeeBloc.showGenderBox.value);
                        // widget.employeeBloc.genderShowError.add(false);
                      },
                      child: Container(
                        color: AppColors.colorTransparent,
                        width: double.infinity,
                        child: Padding(
                          padding: AppPaddingConstants().left25,
                          child: Text(
                            "Male".i18n,
                            style: AppTextStyle().lightTextStyle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.employeeBloc.selectedGender.add(GenderOption.female.displayTitle);
                        widget.employeeBloc.showGenderBox.add(!widget.employeeBloc.showGenderBox.value);
                        // widget.employeeBloc.genderShowError.add(false);
                      },
                      child: Container(
                        color: AppColors.colorTransparent,
                        width: double.infinity,
                        child: Padding(
                          padding: AppPaddingConstants().left25,
                          child: Text(
                            "Female".i18n,
                            style: AppTextStyle().lightTextStyle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.employeeBloc.selectedGender.add(GenderOption.other.displayTitle);
                        widget.employeeBloc.showGenderBox.add(!widget.employeeBloc.showGenderBox.value);
                        // widget.employeeBloc.genderShowError.add(false);
                      },
                      child: Container(
                        color: AppColors.colorTransparent,
                        width: double.infinity,
                        child: Padding(
                          padding: AppPaddingConstants().left25,
                          child: Text(
                            "Rather not to say".i18n,
                            style: AppTextStyle().lightTextStyle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            );
          }
          return GestureDetector(
            onTap: () {
              widget.employeeBloc.showGenderBox.add(!widget.employeeBloc.showGenderBox.value);
            },
            child: Neumorphic(
              style: const NeumorphicStyle(
                shape: NeumorphicShape.concave,
                color: AppColors.colorWhite,
                surfaceIntensity: 0.02,
                intensity: 0.43,
              ),
              child: Container(
                height: 52,
                color: AppColors.colorWhite,
                child: Row(
                  children: [
                    Padding(
                      padding: AppPaddingConstants().left25,
                      child: StreamBuilder(
                        stream: widget.employeeBloc.selectedGender,
                        builder: (context, snapshot) {
                          return Text(
                            widget.employeeBloc.selectedGender.value,
                            style: AppTextStyle().lightTextStyle.copyWith(
                                  color: AppColors.colorLightGrey100,
                                ),
                          );
                        },
                      ),
                    ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 35,
                        color: AppColors.colorLightGrey100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
