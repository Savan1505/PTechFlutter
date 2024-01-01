import 'package:flutter/material.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/widget/progressbar/circle_progress_painter.dart';
import 'package:rxdart/rxdart.dart';

class CircleProgressWidget extends StatefulWidget {
  final double value;

  const CircleProgressWidget({super.key, required this.value});

  @override
  State<CircleProgressWidget> createState() => _CircleProgressWidgetState();
}

class _CircleProgressWidgetState extends State<CircleProgressWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController progressController;
  late Animation animation;
  BehaviorSubject<bool> animateState = BehaviorSubject<bool>.seeded(false);

  @override
  void dispose() {
    progressController.dispose();
    animateState.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    progressController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1700));
    animation = Tween<double>(begin: 0.0, end: widget.value).animate(progressController)
      ..addListener(() {
        animateState.add(true);
      });
    progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: animateState,
      builder: (context, snapshot) {
        return CustomPaint(
          foregroundPainter: CircleProgressPainter(animation.value.toDouble()),
          child: SizedBox(
            width: 63,
            height: 63,
            child: Center(
              child: Text(
                "${animation.value.toInt().toString()}%",
                style: const TextStyle(
                  color: AppColors.colorBlack,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
