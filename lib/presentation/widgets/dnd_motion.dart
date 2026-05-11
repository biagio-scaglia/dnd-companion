import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Wrapper per applicare animazioni di ingresso fluide agli elementi.
/// Privilegia l'uso di animazioni implicite per non appesantire il codice.
class DndAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final bool isScale;
  final bool isFade;
  final bool isSlide;
  final Offset slideOffset;

  const DndAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
    this.isScale = false,
    this.isFade = true,
    this.isSlide = false,
    this.slideOffset = const Offset(0, 0.1),
  });

  @override
  State<DndAnimation> createState() => _DndAnimationState();
}

class _DndAnimationState extends State<DndAnimation> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _isVisible = true);
      });
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) setState(() => _isVisible = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget current = widget.child;

    if (widget.isScale) {
      current = AnimatedScale(
        scale: _isVisible ? 1.0 : 0.95,
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        child: current,
      );
    }

    if (widget.isSlide) {
      current = AnimatedSlide(
        offset: _isVisible ? Offset.zero : widget.slideOffset,
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        child: current,
      );
    }

    if (widget.isFade) {
      current = AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        child: current,
      );
    }

    return current;
  }
}

/// Extension per applicare le animazioni direttamente sui widget
/// riducendo il boilerplate.
extension DndAnimationExtension on Widget {
  Widget fadeIn({
    Duration duration = const Duration(milliseconds: 300),
    Duration delay = Duration.zero,
  }) {
    return DndAnimation(
      duration: duration,
      delay: delay,
      isFade: true,
      child: this,
    );
  }

  Widget slideIn({
    Duration duration = const Duration(milliseconds: 300),
    Duration delay = Duration.zero,
    Offset offset = const Offset(0, 0.1),
  }) {
    return DndAnimation(
      duration: duration,
      delay: delay,
      isSlide: true,
      slideOffset: offset,
      child: this,
    );
  }

  Widget scaleIn({
    Duration duration = const Duration(milliseconds: 300),
    Duration delay = Duration.zero,
  }) {
    return DndAnimation(
      duration: duration,
      delay: delay,
      isScale: true,
      child: this,
    );
  }
}

/// Widget per creare l'effetto Shimmer (scheletro di caricamento)
/// coerente con lo stile dark fantasy.
class DndShimmer extends StatefulWidget {
  final Widget child;
  final bool isEnabled;

  const DndShimmer({
    super.key,
    required this.child,
    this.isEnabled = true,
  });

  @override
  State<DndShimmer> createState() => _DndShimmerState();
}

class _DndShimmerState extends State<DndShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    if (widget.isEnabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(DndShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEnabled && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isEnabled && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnabled) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                AppColors.surfaceSecondary,
                Color(0xFF4A3225), // Un marrone leggermente più chiaro
                AppColors.surfaceSecondary,
              ],
              stops: const [0.3, 0.5, 0.7],
              transform: _SlidingGradientTransform(slidePercent: _controller.value),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Helper per muovere il gradiente dello shimmer
class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * (slidePercent - 0.5) * 2, 0.0, 0.0);
  }
}
