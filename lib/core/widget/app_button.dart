import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';

class AppButton extends StatelessWidget {
  final Color? color;
  final String label;
  final Color? labelColor;
  final double? height;
  final void Function() onPressed;

  const AppButton({
    super.key,
    this.color,
    required this.label,
    required this.onPressed,
    this.labelColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 52,
      child: NeumorphicButton(
        style: NeumorphicStyle(
          shape: NeumorphicShape.concave,
          boxShape: const NeumorphicBoxShape.stadium(),
          color: color ?? AppColors.colorPrimary,
          surfaceIntensity: 0.1,
          intensity: 0.5,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        onPressed: onPressed,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: labelColor ?? AppColors.colorWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
