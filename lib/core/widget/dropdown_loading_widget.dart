import 'package:flutter/material.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/widget/shimmer_widget.dart';

class DropdownLoadingWidget extends StatelessWidget {
  final String labelName;

  const DropdownLoadingWidget({
    super.key,
    required this.labelName,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.loadingColor,
      highlightColor: AppColors.loadingLightColor,
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Center(
          child: Text(labelName),
        ),
      ),
    );
  }
}
