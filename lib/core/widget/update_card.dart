import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/widget/progressbar/circle_progress_widget.dart';

class UpdatesCard extends StatelessWidget {
  final void Function() onPressed;
  final double value;
  final String label;

  const UpdatesCard({
    super.key,
    required this.value,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 266,
      child: Stack(
        alignment: const Alignment(-1.0, 1.2),
        children: [
          AppUtil.neuMorphicWidget(
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
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: AppColors.colorBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 19,
                      ),
                      const Text(
                        "\$1250.00",
                        style: TextStyle(
                          color: AppColors.colorPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 46,
                      ),
                    ],
                  ),
                  const Spacer(),
                  const CircleProgressWidget(
                    value: 50,
                  ),
                ],
              ),
            ),
          ),
          NeumorphicButton(
            style: const NeumorphicStyle(
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.circle(),
              color: AppColors.colorWhite,
            ),
            onPressed: onPressed,
            child: const Icon(
              Icons.arrow_forward,
              color: AppColors.colorPrimary,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
