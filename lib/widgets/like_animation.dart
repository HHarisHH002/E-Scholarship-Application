import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isanimating;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smalllike;
  const LikeAnimation({
    Key? key,
    required this.child,
    required this.isanimating,
    this.duration = const Duration(milliseconds: 150),
    this.onEnd,
    this.smalllike = false,
  }) : super(key: key);

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2));
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isanimating != oldWidget.isanimating) {
      startanimation();
    }
  }

  void startanimation() async {
    if (widget.isanimating || widget.smalllike) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(
        const Duration(microseconds: 200),
      );
      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
