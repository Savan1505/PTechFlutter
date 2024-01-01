import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';

class AppRadioOption<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final String? text;
  final void Function(T) onChanged;

  const AppRadioOption({
    super.key,
    required this.value,
    required this.groupValue,
    this.text,
    required this.onChanged,
  });

  Widget _buildText(bool isSelected) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text!,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isSelected ? AppColors.colorWhite : AppColors.colorBlack,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.concave,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(100)),
          color: isSelected ? AppColors.colorDarkPrimary : AppColors.colorWhite,
          intensity: 0.4,
          surfaceIntensity: 0.1,
        ),
        child: Center(
          child: _buildText(isSelected),
        ),
      ),
    );
  }
}
