import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/widget/custom_text_widget.dart';

class CustomButtonWidget extends StatelessWidget {
  final String? text;
  final Color? textColor;
  final double? fontSize;
  final VoidCallback? onTapCallback;
  final double? height;
  final double? width;
  final FontWeight? fontWeight;
  final double? letterSpacing;

  const CustomButtonWidget({
    Key? key,
    this.text,
    this.onTapCallback,
    this.height,
    this.width,
    this.fontSize,
    this.textColor = AppColors.colorSecondary,
    this.fontWeight,
    this.letterSpacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapCallback ?? () {},
      child: SizedBox(
        height: height ?? 0,
        width: width ?? 0,
        child: AppUtil.neuMorphicWidget(
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(
              20,
            ),
          ),
          backgroundColor: AppColors.colorPrimary,
          childWidget: AppUtil.neuMorphicWidget(
            backgroundColor: AppColors.colorPrimary,
            boxShape: const NeumorphicBoxShape.rect(),
            childWidget: Center(
              child: CustomTextWidget(
                text: text ?? "",
                fontSize: fontSize ?? 16,
                fontWeight: fontWeight ?? FontWeight.w400,
                textColor: textColor ?? AppColors.colorBlack,
                letterSpacing: letterSpacing ?? 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
