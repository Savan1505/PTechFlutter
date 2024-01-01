import 'package:flutter/material.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';

class AppBottomSheet {
  final Widget child;

  AppBottomSheet({required this.child});

  Future<void> showBottomSheet() async {
    await showModalBottomSheet(
      context: AppRouteManager.navigatorKey.currentContext!,
      isScrollControlled: true,
      backgroundColor: AppColors.colorTransparent,
      isDismissible: false,
      barrierColor: AppColors.colorPrimary.withOpacity(0.8),
      builder: (ctx) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Column(
            children: [
              Container(
                color: AppColors.colorTransparent,
                width: MediaQuery.of(AppRouteManager.navigatorKey.currentContext!).size.width,
                padding: EdgeInsets.zero,
                child: Stack(
                  children: [
                    Positioned.fill(
                      top: 26,
                      bottom: -1,
                      child: Container(
                        width: MediaQuery.of(
                          AppRouteManager.navigatorKey.currentContext!,
                        ).size.width,
                        height: 21,
                        decoration: const BoxDecoration(
                          color: AppColors.colorWhite,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(AppRouteManager.navigatorKey.currentContext!);
                        },
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: const BoxDecoration(
                            color: AppColors.colorPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.close,
                              color: AppColors.colorWhite,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: AppColors.colorWhite,
                width: double.infinity,
                padding: EdgeInsets.zero,
                child: Padding(
                  padding: AppPaddingConstants().leftRight25,
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
