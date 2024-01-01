import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';

class AppCircleRadioOption<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final String? text;
  final void Function(T) onChanged;

  const AppCircleRadioOption({
    super.key,
    required this.value,
    this.groupValue,
    this.text,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        children: [
          SizedBox(
            height: 32,
            width: 32,
            child: Neumorphic(
              style: const NeumorphicStyle(
                surfaceIntensity: 0.15,
                color: AppColors.colorWhite,
                depth: 3,
                boxShape: NeumorphicBoxShape.circle(),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        height: 19,
                        width: 19,
                        decoration: const BoxDecoration(
                          color: AppColors.colorPrimary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.colorShadowPrimary,
                              blurRadius: 12,
                              offset: Offset(10, 10),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          const SizedBox(
            width: 13,
          ),
          Text(
            text!,
            textAlign: TextAlign.center,
            style: AppTextStyle().darkTextStyle,
          ),
        ],
      ),
    );
  }
}
