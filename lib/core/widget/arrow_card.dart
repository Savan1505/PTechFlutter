import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';

class ArrowCard extends StatelessWidget {
  final void Function()? onTap;
  final Widget trailing;
  final Text label;

  const ArrowCard({super.key, this.onTap, required this.label, this.trailing = const SizedBox.shrink()});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
              Padding(padding: AppPaddingConstants().left25, child: label),
              const Spacer(),
              trailing,
              Padding(
                padding: AppPaddingConstants().right10,
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: AppColors.colorLightGrey100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
