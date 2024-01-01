import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/widget/custom_text_widget.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final FocusNode? focusNode;
  final String? hint;
  final TextInputType? inputTypes;
  final Widget? suffixIcon;
  final bool? filled;
  final bool? obscureText;
  final bool isClickable;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextInputAction? textInputAction;
  final int? maxLine;
  final int? minLine;
  final double? height;
  final double? width;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double? topPadding;
  final double? leftPadding;
  final double? rightPadding;
  final bool autocorrect;
  final Color? backgroundColor;
  final double? elevation;
  final double? letterSpacing;
  final int? maxLength;
  final TextAlign? textAlign;
  final bool? readOnly;
  final ValueChanged<String>? onChangedMethod;
  final Color? cardBackgroundColor;
  final TextCapitalization? textCapitalization;
  final double? radius;
  final bool isError;
  final String errorMessage;

  const CustomTextFieldWidget({
    required this.textEditingController,
    this.hint,
    this.inputTypes,
    this.focusNode,
    this.suffixIcon,
    this.filled,
    this.obscureText,
    this.fontSize,
    this.isClickable = false,
    this.fontWeight,
    this.textInputAction,
    this.maxLine = 1,
    this.minLine = 1,
    this.height,
    this.width,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.topPadding,
    this.leftPadding,
    this.rightPadding,
    this.autocorrect = false,
    this.backgroundColor,
    this.elevation,
    this.letterSpacing,
    this.maxLength,
    this.textAlign,
    this.readOnly,
    this.onChangedMethod,
    this.cardBackgroundColor,
    this.textCapitalization,
    this.radius,
    this.isError = false,
    this.errorMessage = "",
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: AppUtil.neuMorphicStyle(
        backgroundColor: backgroundColor ?? AppColors.colorTransparent,
        boxShape: NeumorphicBoxShape.roundRect(
          const BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
        ),
        depth: 0.1,
        surfaceIntensity: 0.12,
      ),
      margin: AppUtil.allMargin(
        left: left ?? 0,
        right: right ?? 0,
        top: top ?? 0,
        bottom: bottom ?? 0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isClickable
              ? Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: CustomTextWidget(
                    text: hint ?? "",
                    textColor: AppColors.colorSecondary,
                    fontSize: fontSize ?? 14,
                    fontWeight: fontWeight ?? FontWeight.w400,
                    textAlign: TextAlign.center,
                    letterSpacing: letterSpacing ?? -1,
                  ),
                )
              : Container(
                  height: maxLine == 1 ? 40 : height,
                  width: width ?? double.infinity,
                  padding: AppUtil.allPadding(
                    left: leftPadding ?? 0,
                    right: rightPadding ?? 0,
                    top: topPadding ?? 0,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.colorLightGray,
                        AppColors.colorSecondary,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [-10, 0.5],
                    ),
                  ),
                  child: TextFormField(
                    readOnly: readOnly ?? false,
                    maxLength: maxLength,
                    autocorrect: autocorrect,
                    maxLines: maxLine ?? 1,
                    minLines: minLine ?? 0,
                    textAlignVertical: TextAlignVertical.top,
                    obscureText: obscureText ?? false,
                    controller: textEditingController,
                    focusNode: focusNode,
                    keyboardType: inputTypes ?? TextInputType.text,
                    textAlign: textAlign ?? TextAlign.start,
                    cursorColor: textEditingController.text.isNotEmpty
                        ? AppColors.colorBlack
                        : AppColors.colorGray,
                    textInputAction: textInputAction ?? TextInputAction.done,
                    style: AppUtil.textStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                      textColor: AppColors.colorBlack,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(
                        20,
                        10,
                        20,
                        15,
                      ),
                      counterText: "",
                      suffixIcon: suffixIcon,
                      border: InputBorder.none,
                      filled: filled ?? false,
                      hintText: hint ?? "",
                      hintStyle: AppUtil.textStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        letterSpacing: 0,
                        textColor: AppColors.colorHint.withOpacity(0.7),
                      ),
                    ),
                    onChanged: onChangedMethod,
                    textCapitalization: textCapitalization ?? TextCapitalization.none,
                  ),
                ),
          isError
              ? CustomTextWidget(
                  left: 20,
                  text: errorMessage,
                  textColor: AppColors.colorError,
                  fontSize: 12,
                  textAlign: TextAlign.left,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
