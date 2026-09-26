import 'package:flutter/material.dart';

class MeloPulseAnimation extends StatefulWidget {
  const MeloPulseAnimation({
    super.key,
    required this.child,
    this.period = const Duration(seconds: 4),
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.isPulsing = true,
  });

  final Widget child;
  final Duration period;
  final double minScale;
  final double maxScale;
  final bool isPulsing;

  @override
  State<MeloPulseAnimation> createState() => _MeloPulseAnimationState();
}

class _MeloPulseAnimationState extends State<MeloPulseAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period);

    _scaleAnimation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));

    if (widget.isPulsing) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant MeloPulseAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPulsing != oldWidget.isPulsing) {
      if (widget.isPulsing) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations || !widget.isPulsing) {
      return widget.child;
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}
