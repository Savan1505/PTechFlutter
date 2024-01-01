import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';

class CustomTextWidget extends StatelessWidget {
  final String? text;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final double? letterSpacing;
  final TextAlign? textAlign;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;

  const CustomTextWidget({
    this.text,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.textDecoration,
    this.letterSpacing,
    this.textAlign,
    this.top,
    this.left,
    this.right,
    this.bottom,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      textAlign: textAlign ?? TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: AppUtil.textStyle(
        letterSpacing: letterSpacing ?? 0.5,
        fontSize: fontSize ?? 16,
        textColor: textColor ?? AppColors.colorBlack,
        fontWeight: fontWeight ?? FontWeight.w400,
        textDecoration: textDecoration ?? TextDecoration.none,
      ),
    );
  }
}
