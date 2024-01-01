import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';

class ModuleCard extends StatelessWidget {
  final void Function()? onTap;
  final Widget icon;
  final String label;
  final double height;
  final double width;
  final bool applyWidth;

  const ModuleCard({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
    this.height = 100,
    this.applyWidth = true,
    this.width = 100,
  });

  @override
  Widget build(BuildContext context) {
    if (applyWidth) {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            SizedBox(
              height: height,
              width: width,
              child: AppUtil.neuMorphicWidget(
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(
                    12,
                  ),
                ),
                depth: 3,
                topMargin: 7,
                backgroundColor: AppColors.colorSecondary,
                surfaceIntensity: 0.15,
                childWidget: Padding(
                  padding: AppPaddingConstants().homePageCardPadding,
                  child: Column(
                    children: [
                      icon,
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        label,
                        style: AppTextStyle().homeStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            height: height,
            child: AppUtil.neuMorphicWidget(
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(
                  12,
                ),
              ),
              depth: 3,
              topMargin: 7,
              backgroundColor: AppColors.colorSecondary,
              surfaceIntensity: 0.15,
              childWidget: Padding(
                padding: AppPaddingConstants().homePageCardPadding,
                child: Column(
                  children: [
                    icon,
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      label,
                      style: AppTextStyle().homeStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
