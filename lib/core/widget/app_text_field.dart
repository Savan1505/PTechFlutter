import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController textEditingController;
  final int maxLines;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? onChangeFunction;
  final String? Function(String?)? validatorFunction;
  final bool isFocused;
  final bool showError;
  final bool readOnly;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final bool obscureText;
  final bool enabled;
  final void Function()? onTap;

  const AppTextField({
    super.key,
    required this.textEditingController,
    required this.label,
    this.inputFormatters,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.onChangeFunction,
    this.validatorFunction,
    required this.isFocused,
    required this.showError,
    this.readOnly = false,
    this.suffixIcon,
    this.focusNode,
    this.obscureText = false,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: isFocused
          ? const NeumorphicStyle(
              depth: -4,
              color: AppColors.colorWhite,
              shadowDarkColorEmboss: AppColors.colorInnerShadowPrimary,
              surfaceIntensity: 1,
              intensity: 1,
            )
          : const NeumorphicStyle(
              shape: NeumorphicShape.concave,
              color: AppColors.colorWhite,
              surfaceIntensity: 0.01,
              intensity: 0.4,
            ),
      child: TextFormField(
        cursorColor: AppColors.colorBlack,
        keyboardType: keyboardType,
        controller: textEditingController,
        onTap: onTap,
        focusNode: focusNode,
        style: TextStyle(
          fontSize: 16,
          color: isFocused ? AppColors.colorHint : AppColors.colorBlack,
        ),
        readOnly: readOnly,
        obscureText: obscureText,
        enabled: enabled,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
          suffixIcon: suffixIcon,
          isDense: true,
          hintStyle: const TextStyle(
            color: AppColors.colorTextHintColor,
            fontSize: 16,
          ),
          enabledBorder: (showError)
              ? const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      12,
                    ),
                  ),
                  borderSide: BorderSide(
                    color: AppColors.colorError,
                  ),
                )
              : null,
          focusedBorder: (showError)
              ? const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      12,
                    ),
                  ),
                  borderSide: BorderSide(
                    color: AppColors.colorError,
                  ),
                )
              : null,
          contentPadding: const EdgeInsets.only(
            left: 25,
            top: 15,
            bottom: 15,
          ),
        ),
        inputFormatters: inputFormatters,
        validator: validatorFunction,
        maxLines: maxLines,
        onChanged: onChangeFunction,
      ),
    );
  }
}
