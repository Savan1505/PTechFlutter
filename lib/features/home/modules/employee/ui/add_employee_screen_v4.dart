import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/core/widget/app_toggle_switch.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/bloc/employee_bloc.dart';

class AddEmployeeV4 extends StatefulWidget {
  final EmployeeBloc employeeBloc;

  const AddEmployeeV4({super.key, required this.employeeBloc});

  @override
  State<AddEmployeeV4> createState() => _AddEmployeeV4State();
}

class _AddEmployeeV4State extends State<AddEmployeeV4> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.employeeBloc.formKeyV4,
      child: Padding(
        padding: AppPaddingConstants().leftRight25,
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            StreamBuilder(
              stream: widget.employeeBloc.posUser,
              builder: (context, snapshot) {
                return AppToggleSwitch(
                  value: widget.employeeBloc.posUser.value,
                  title: "POS User".i18n,
                  onChange: (val) {
                    widget.employeeBloc.posUser.add(val);
                  },
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: widget.employeeBloc.posUser,
              builder: (context, snapshot) {
                if (widget.employeeBloc.posUser.value) {
                  return Column(
                    children: [
                      StreamBuilder(
                        stream: widget.employeeBloc.pinTap,
                        builder: (context, snapshot) {
                          return Focus(
                            onFocusChange: (val) {
                              widget.employeeBloc.pinTap.add(val);
                            },
                            child: Column(
                              children: [
                                AppTextField(
                                  isFocused: widget.employeeBloc.pinTap.value,
                                  label: "Pin".i18n,
                                  textEditingController: widget.employeeBloc.posPinController,
                                  showError: widget.employeeBloc.pinError.value,
                                  obscureText: widget.employeeBloc.isPinObscured,
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      widget.employeeBloc.isPinObscured =
                                          !widget.employeeBloc.isPinObscured;
                                      widget.employeeBloc.pinTap.add(widget.employeeBloc.pinTap.value);
                                    },
                                    child: widget.employeeBloc.isPinObscured
                                        ? const Icon(Icons.visibility_off)
                                        : const Icon(Icons.visibility),
                                  ),
                                  validatorFunction: (value) {
                                    if (widget.employeeBloc.posUser.value) {
                                      if (value == null || value.isEmpty) {
                                        widget.employeeBloc.pinTap.add(widget.employeeBloc.pinTap.value);
                                        widget.employeeBloc.pinError.add(true);
                                      } else {
                                        widget.employeeBloc.pinTap.add(widget.employeeBloc.pinTap.value);
                                        widget.employeeBloc.pinError.add(false);
                                      }
                                    }
                                    return null;
                                  },
                                  inputFormatters: [LengthLimitingTextInputFormatter(4)],
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                StreamBuilder(
                                  stream: widget.employeeBloc.pinError,
                                  builder: (context, snapshot) {
                                    return Visibility(
                                      visible: widget.employeeBloc.pinError.value,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Enter a valid pin code'.i18n,
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
                        height: 10,
                      ),
                      StreamBuilder(
                        stream: widget.employeeBloc.confirmPinTap,
                        builder: (context, snapshot) {
                          return Focus(
                            onFocusChange: (val) {
                              widget.employeeBloc.confirmPinTap.add(val);
                            },
                            child: Column(
                              children: [
                                AppTextField(
                                  isFocused: widget.employeeBloc.confirmPinTap.value,
                                  label: "Confirm Pin".i18n,
                                  textEditingController: widget.employeeBloc.posConfirmPinController,
                                  showError: widget.employeeBloc.confirmPinError.value,
                                  obscureText: widget.employeeBloc.isConfirmPinObscured,
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      widget.employeeBloc.isConfirmPinObscured =
                                          !widget.employeeBloc.isConfirmPinObscured;
                                      widget.employeeBloc.confirmPinTap
                                          .add(widget.employeeBloc.confirmPinTap.value);
                                    },
                                    child: widget.employeeBloc.isConfirmPinObscured
                                        ? const Icon(Icons.visibility_off)
                                        : const Icon(Icons.visibility),
                                  ),
                                  validatorFunction: (value) {
                                    if (widget.employeeBloc.posUser.value) {
                                      if (value == null || value.isEmpty) {
                                        widget.employeeBloc.confirmPinTap
                                            .add(widget.employeeBloc.confirmPinTap.value);
                                        widget.employeeBloc.confirmPinError.add(true);
                                      } else {
                                        if (widget.employeeBloc.posPinController.text.compareTo(
                                              widget.employeeBloc.posConfirmPinController.text,
                                            ) !=
                                            0) {
                                          widget.employeeBloc.confirmPinErrorMessage =
                                              "Confirm pin does not match".i18n;
                                          widget.employeeBloc.confirmPinTap
                                              .add(widget.employeeBloc.confirmPinTap.value);
                                          widget.employeeBloc.confirmPinError.add(true);
                                        } else {
                                          widget.employeeBloc.confirmPinErrorMessage =
                                              "Enter a valid confirm pin code".i18n;
                                          widget.employeeBloc.confirmPinTap
                                              .add(widget.employeeBloc.confirmPinTap.value);
                                          widget.employeeBloc.confirmPinError.add(false);
                                        }
                                      }
                                    }
                                    return null;
                                  },
                                  inputFormatters: [LengthLimitingTextInputFormatter(4)],
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                StreamBuilder(
                                  stream: widget.employeeBloc.confirmPinError,
                                  builder: (context, snapshot) {
                                    return Visibility(
                                      visible: widget.employeeBloc.confirmPinError.value,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          widget.employeeBloc.confirmPinErrorMessage,
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
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
