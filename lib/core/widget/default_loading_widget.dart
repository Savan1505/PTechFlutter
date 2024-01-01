import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/widget/shimmer_widget.dart';

class DefaultLoadingWidget extends StatelessWidget {
  final int loadingBars;

  const DefaultLoadingWidget({super.key, this.loadingBars = 6});

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
      childWidget: Padding(
        padding: AppPaddingConstants().loadingPadding,
        child: Shimmer.fromColors(
          baseColor: AppColors.loadingColor,
          highlightColor: AppColors.loadingLightColor,
          child: ListView.builder(
            itemCount: loadingBars,
            shrinkWrap: true,
            itemBuilder: (_, __) {
              return Padding(
                padding: AppPaddingConstants().all8,
                child: Material(
                  elevation: 4,
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        color: AppColors.colorWhite,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 10,
                        width: MediaQuery.of(context).size.width,
                        color: AppColors.colorWhite,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 10,
                        width: MediaQuery.of(context).size.width,
                        color: AppColors.colorWhite,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 10,
                        width: MediaQuery.of(context).size.width,
                        color: AppColors.colorWhite,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
