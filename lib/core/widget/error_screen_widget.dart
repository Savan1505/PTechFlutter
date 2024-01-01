import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';

class ErrorWidgetScreen extends StatelessWidget {
  const ErrorWidgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppUtil.neuMorphicWidget(
      backgroundColor: AppColors.colorBackGround,
      topMargin: TextSelectionToolbar.kHandleSize,
      boxShape: NeumorphicBoxShape.roundRect(
        const BorderRadius.only(
          topLeft: Radius.circular(
            20,
          ),
          topRight: Radius.circular(
            20,
          ),
        ),
      ),
      depth: -5,
      childWidget: const Center(
        child: Text("Error"),
      ),
    );
  }
}
