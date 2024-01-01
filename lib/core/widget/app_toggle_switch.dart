import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';

class AppToggleSwitch extends StatelessWidget {
  final String title;
  final bool value;
  final void Function(bool)? onChange;

  const AppToggleSwitch({
    super.key,
    required this.title,
    required this.value,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: const NeumorphicStyle(
        shape: NeumorphicShape.concave,
        color: AppColors.colorWhite,
        surfaceIntensity: 0.2,
        intensity: 0.4,
        depth: 12,
      ),
      child: Container(
        height: 94,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: value
              ? Border.all(
                  color: AppColors.colorPrimary,
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: value ? AppColors.colorBlack : AppColors.colorLightGrey100,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              NeumorphicSwitch(
                value: value,
                height: 20,
                style: const NeumorphicSwitchStyle(
                  inactiveThumbColor: AppColors.colorShadowPrimary,
                  inactiveTrackColor: AppColors.colorWhite,
                  activeThumbColor: AppColors.colorPrimary,
                  activeTrackColor: AppColors.colorWhite,
                ),
                onChanged: onChange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
