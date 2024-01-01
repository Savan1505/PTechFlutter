import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';

class SimpleCard extends StatelessWidget {
  final String name;
  final Widget? trailing;

  const SimpleCard({
    super.key,
    required this.name,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return AppUtil.neuMorphicWidget(
      boxShape: NeumorphicBoxShape.roundRect(
        BorderRadius.circular(
          12,
        ),
      ),
      border: const NeumorphicBorder(
        color: AppColors.colorTransparent,
        width: 0.5,
      ),
      depth: 9,
      topMargin: 7,
      backgroundColor: AppColors.colorSecondary,
      childWidget: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        leading: AppUtil.circularTextAndImageWidget(
          childWidget: AppUtil.circularProfileNameWidget(
            profileName: name[0],
          ),
        ),
        trailing: trailing,
        title: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.storeHeaderTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
