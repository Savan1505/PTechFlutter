import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/features/home/modules/employee/bloc/employee_bloc.dart';

class AddEmployeePage extends StatefulWidget {
  final EmployeeBloc employeeBloc;

  const AddEmployeePage({
    super.key,
    required this.employeeBloc,
  });

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.employeeBloc.formKeyV1,
      child: SingleChildScrollView(
        child: Padding(
          padding: AppPaddingConstants().leftRight25,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              StreamBuilder(
                stream: widget.employeeBloc.pickedImage,
                builder: (context, snapshot) {
                  if (widget.employeeBloc.pickedImage.valueOrNull != null) {
                    File file = File(widget.employeeBloc.pickedImage.value!.path);
                    return GestureDetector(
                      onTap: () async {
                        var temp =
                            await widget.employeeBloc.picker.pickImage(source: ImageSource.gallery);
                        if (temp != null) {
                          widget.employeeBloc.pickedImage.add(temp);
                        }
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 67,
                            backgroundColor: AppColors.blueColor,
                            backgroundImage: FileImage(file),
                          ),
                          Positioned(
                            top: 93,
                            left: 80,
                            child: Container(
                              padding: const EdgeInsets.all(11),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: AppColors.colorPrimary,
                              ),
                              child: const Icon(
                                Icons.camera_enhance_outlined,
                                color: AppColors.colorWhite,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return GestureDetector(
                    onTap: () async {
                      var temp = await widget.employeeBloc.picker.pickImage(source: ImageSource.gallery);
                      if (temp != null) {
                        widget.employeeBloc.pickedImage.add(temp);
                      }
                    },
                    child: Stack(
                      children: [
                        Neumorphic(
                          padding: const EdgeInsets.all(44),
                          style: NeumorphicStyle(
                            boxShape: const NeumorphicBoxShape.circle(),
                            depth: NeumorphicTheme.embossDepth(context),
                            shadowDarkColorEmboss: const Color.fromRGBO(0, 0, 0, 0.30196078431372547),
                            shadowLightColorEmboss: AppColors.colorWhite,
                            color: AppColors.colorLightGreen,
                            border: const NeumorphicBorder.none(),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: AppColors.colorPrimary,
                            size: 50,
                          ),
                        ),
                        Positioned(
                          top: 87,
                          left: 97,
                          child: Container(
                            padding: const EdgeInsets.all(11),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: AppColors.colorPrimary,
                            ),
                            child: const Icon(
                              Icons.camera_enhance_outlined,
                              color: AppColors.colorWhite,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 30,
              ),
              StreamBuilder(
                stream: widget.employeeBloc.firstNameTap.stream,
                builder: (context, snapshot) {
                  return Focus(
                    onFocusChange: (val) {
                      widget.employeeBloc.firstNameTap.add(val);
                    },
                    child: Column(
                      children: [
                        AppTextField(
                          isFocused: widget.employeeBloc.firstNameTap.value,
                          label: "First Name".i18n,
                          textEditingController: widget.employeeBloc.firstNameController,
                          showError: widget.employeeBloc.firstNameShowError.value,
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              widget.employeeBloc.firstNameTap
                                  .add(widget.employeeBloc.firstNameTap.value);
                              widget.employeeBloc.firstNameShowError.add(true);
                            } else {
                              widget.employeeBloc.firstNameTap
                                  .add(widget.employeeBloc.firstNameTap.value);
                              widget.employeeBloc.firstNameShowError.add(false);
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        StreamBuilder(
                          stream: widget.employeeBloc.firstNameShowError,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: widget.employeeBloc.firstNameShowError.value,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Please Enter First Name'.i18n,
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
                stream: widget.employeeBloc.lastNameTap.stream,
                builder: (context, snapshot) {
                  return Focus(
                    onFocusChange: (val) {
                      widget.employeeBloc.lastNameTap.add(val);
                    },
                    child: Column(
                      children: [
                        AppTextField(
                          isFocused: widget.employeeBloc.lastNameTap.value,
                          label: "Last Name".i18n,
                          textEditingController: widget.employeeBloc.lastNameController,
                          showError: widget.employeeBloc.lastNameShowError.value,
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              widget.employeeBloc.lastNameTap.add(widget.employeeBloc.lastNameTap.value);
                              widget.employeeBloc.lastNameShowError.add(true);
                            } else {
                              widget.employeeBloc.lastNameTap.add(widget.employeeBloc.lastNameTap.value);
                              widget.employeeBloc.lastNameShowError.add(false);
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        StreamBuilder(
                          stream: widget.employeeBloc.lastNameShowError,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: widget.employeeBloc.lastNameShowError.value,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Please Enter Last Name',
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
                stream: widget.employeeBloc.contactNoTap.stream,
                builder: (context, snapshot) {
                  return Focus(
                    onFocusChange: (val) {
                      widget.employeeBloc.contactNoTap.add(val);
                    },
                    child: Column(
                      children: [
                        AppTextField(
                          isFocused: widget.employeeBloc.contactNoTap.value,
                          label: "Primary Contact Number".i18n,
                          textEditingController: widget.employeeBloc.contactNoController,
                          showError: widget.employeeBloc.contactNoShowError.value,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              widget.employeeBloc.contactNoTap
                                  .add(widget.employeeBloc.contactNoTap.value);
                              widget.employeeBloc.contactNoShowError.add(true);
                            } else {
                              widget.employeeBloc.contactNoTap
                                  .add(widget.employeeBloc.contactNoTap.value);
                              widget.employeeBloc.contactNoShowError.add(false);
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        StreamBuilder(
                          stream: widget.employeeBloc.contactNoShowError,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: widget.employeeBloc.contactNoShowError.value,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Please Enter Primary Contact Number'.i18n,
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
                stream: widget.employeeBloc.emailTap.stream,
                builder: (context, snapshot) {
                  return Focus(
                    onFocusChange: (val) {
                      widget.employeeBloc.emailTap.add(val);
                    },
                    child: Column(
                      children: [
                        AppTextField(
                          isFocused: widget.employeeBloc.emailTap.value,
                          label: "Primary Email Address".i18n,
                          textEditingController: widget.employeeBloc.emailController,
                          showError: widget.employeeBloc.emailShowError.value,
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              widget.employeeBloc.emailTap.add(widget.employeeBloc.emailTap.value);
                              widget.employeeBloc.emailShowError.add(true);
                            } else {
                              if (!AppUtil().isEmailValid(value)) {
                                widget.employeeBloc.emailTap.add(widget.employeeBloc.emailTap.value);
                                widget.employeeBloc.emailErrorMessage =
                                    "Please enter a valid email id".i18n;
                                widget.employeeBloc.emailShowError.add(true);
                              } else {
                                widget.employeeBloc.emailErrorMessage =
                                    "Please Enter Primary Email Address".i18n;
                                widget.employeeBloc.emailTap.add(widget.employeeBloc.emailTap.value);
                                widget.employeeBloc.emailShowError.add(false);
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        StreamBuilder(
                          stream: widget.employeeBloc.emailShowError,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: widget.employeeBloc.emailShowError.value,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.employeeBloc.emailErrorMessage,
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
                stream: widget.employeeBloc.altContactTap.stream,
                builder: (context, snapshot) {
                  return Focus(
                    onFocusChange: (val) {
                      widget.employeeBloc.altContactTap.add(val);
                    },
                    child: AppTextField(
                      isFocused: widget.employeeBloc.altContactTap.value,
                      label: "Alternate Contact Number".i18n,
                      textEditingController: widget.employeeBloc.altContactController,
                      showError: false,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
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
}
