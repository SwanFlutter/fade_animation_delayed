library fade_animation_delayed;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// Enum to define slide directions for animations
enum SlideDirection {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
}

/// Enum to define different animation types
enum AnimationType {
  slide,
  slideFromOutside,
  fadeIn,
  zoomIn,
  rotation,
}

/// Enum to define easing types for more animation variety
enum EasingType {
  linear,
  easeIn,
  easeOut,
  easeInOut,
  elasticOut,
  bounceOut,
}

/// Advanced Fade and Slide Animation Widget
class FadeAnimationDelayed extends StatefulWidget {
  /// The child widget to be animated
  final Widget child;

  /// Delay before starting the animation
  final Duration delay;

  /// Duration of the animation
  final Duration animationDuration;

  /// Type of easing to use for the animation
  final EasingType easingType;

  /// Whether to fade in or out
  final bool fadeIn;

  /// Enable scaling animation
  final bool enableScaling;

  /// Enable rotation animation
  final bool enableRotation;

  /// Repeat the animation
  final bool repeat;

  /// Interval between repetitions
  final Duration repeatInterval;

  /// Custom animation builder for maximum flexibility
  final Widget Function(BuildContext, Widget, AnimationController)?
      customAnimationBuilder;

  /// State key for external control
  final GlobalKey<FadeAnimationDelayedState>? stateKey;

  /// Slide direction for the animation
  final SlideDirection slideDirection;

  /// Distance of slide (as a fraction of screen size)
  final double slideDistance;

  /// Type of animation to apply
  final AnimationType animationType;

  /// Scale range for zoom animations
  final double minScale;
  final double maxScale;

  /// Rotation range
  final double minRotation;
  final double maxRotation;

  /// Opacity range for fade animations
  final double minOpacity;
  final double maxOpacity;

  const FadeAnimationDelayed({
    required this.child,
    this.stateKey,
    this.delay = Duration.zero,
    this.animationDuration = const Duration(milliseconds: 800),
    this.easingType = EasingType.easeOut,
    this.fadeIn = true,
    this.enableScaling = false,
    this.enableRotation = false,
    this.repeat = false,
    this.repeatInterval = const Duration(seconds: 5),
    this.customAnimationBuilder,
    this.slideDirection = SlideDirection.bottomToTop,
    this.slideDistance = 0.35,
    this.animationType = AnimationType.slide,
    this.minScale = 0.5,
    this.maxScale = 1.0,
    this.minRotation = 0.0,
    this.maxRotation = 2 / pi,
    this.minOpacity = 0.0,
    this.maxOpacity = 1.0,
  }) : super(key: stateKey);

  @override
  FadeAnimationDelayedState createState() => FadeAnimationDelayedState();
}

class FadeAnimationDelayedState extends State<FadeAnimationDelayed>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimationOffset;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Create animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    // Apply selected easing curve
    final CurvedAnimation curvedAnimation = CurvedAnimation(
      curve: _getEasingCurve(),
      parent: _animationController,
    );

    // Slide Animation
    _slideAnimationOffset = Tween<Offset>(
      begin: _getSlideBeginOffset(),
      end: Offset.zero,
    ).animate(curvedAnimation);

    // Scale Animation
    _scaleAnimation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(curvedAnimation);

    // Rotation Animation
    _rotationAnimation = Tween<double>(
      begin: widget.minRotation,
      end: widget.maxRotation,
    ).animate(curvedAnimation);

    // Opacity Animation
    _opacityAnimation = Tween<double>(
      begin: widget.minOpacity,
      end: widget.maxOpacity,
    ).animate(curvedAnimation);

    // Run initial animation
    _runAnimation();
  }

  // Get appropriate easing curve based on EasingType
  Curve _getEasingCurve() {
    switch (widget.easingType) {
      case EasingType.linear:
        return Curves.linear;
      case EasingType.easeIn:
        return Curves.easeIn;
      case EasingType.easeOut:
        return Curves.easeOut;
      case EasingType.easeInOut:
        return Curves.easeInOut;
      case EasingType.elasticOut:
        return Curves.elasticOut;
      case EasingType.bounceOut:
        return Curves.bounceOut;
    }
  }

  // Determine slide start offset based on direction
  Offset _getSlideBeginOffset() {
    // Start from the absolute edge of the screen
    switch (widget.slideDirection) {
      case SlideDirection.leftToRight:
        return const Offset(-8.0, 0.0); // Far off-screen to the left
      case SlideDirection.rightToLeft:
        return const Offset(8.0, 0.0); // Far off-screen to the right
      case SlideDirection.topToBottom:
        return const Offset(0.0, -8.0); // Far off-screen from the top
      case SlideDirection.bottomToTop:
        return const Offset(0.0, 8.0); // Far off-screen from the bottom
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(FadeAnimationDelayed oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fadeIn != widget.fadeIn) {
      _runAnimation();
    }
  }

  // Run the animation with optional delay and repetition
  void _runAnimation() {
    _timer = Timer(widget.delay, () {
      if (widget.repeat) {
        _animationController.repeat(
            reverse: true, period: widget.repeatInterval);
      } else {
        widget.fadeIn
            ? _animationController.forward()
            : _animationController.reverse();
      }
    });
  }

  // Pause the current animation
  void pauseAnimation() {
    _animationController.stop();
  }

  // Resume the animation from current position
  void resumeAnimation() {
    _animationController.forward();
  }

  // Reset and restart the animation
  void resetAnimation() {
    _animationController.reset();
    _runAnimation();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;

    // Use custom animation builder if provided
    if (widget.customAnimationBuilder != null) {
      return widget.customAnimationBuilder!(
          context, child, _animationController);
    }

    // Apply animations based on selected type
    switch (widget.animationType) {
      case AnimationType.slide:
        child = SlideTransition(
          position: _slideAnimationOffset,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: child,
          ),
        );
        break;
      case AnimationType.slideFromOutside:
        child = SlideTransition(
          position: _slideAnimationOffset,
          child: child,
        );
        break;
      case AnimationType.fadeIn:
        child = FadeTransition(
          opacity: _opacityAnimation,
          child: child,
        );
        break;
      case AnimationType.zoomIn:
        child = ScaleTransition(
          scale: _scaleAnimation,
          child: child,
        );
        break;
      case AnimationType.rotation:
        child = RotationTransition(
          turns: _rotationAnimation,
          child: child,
        );
        break;
    }

    // Optional additional transformations
    if (widget.enableScaling) {
      child = ScaleTransition(
        scale: _scaleAnimation,
        child: child,
      );
    }

    if (widget.enableRotation) {
      child = RotationTransition(
        turns: _rotationAnimation,
        child: child,
      );
    }

    return child;
  }
}

/// Extension method to easily apply enhanced animation to any widget
extension EnhancedAnimationExtension on Widget {
  /// Apply enhanced animation with default or custom parameters
  Widget animate({
    final GlobalKey<FadeAnimationDelayedState>? stateKey,
    Duration delay = Duration.zero,
    Duration animationDuration = const Duration(milliseconds: 800),
    EasingType easingType = EasingType.easeOut,
    bool fadeIn = true,
    bool enableScaling = false,
    bool enableRotation = false,
    bool repeat = false,
    Duration repeatInterval = const Duration(seconds: 5),
    SlideDirection slideDirection = SlideDirection.bottomToTop,
    double slideDistance = 0.35,
    AnimationType animationType = AnimationType.slide,
  }) {
    return FadeAnimationDelayed(
      stateKey: stateKey,
      delay: delay,
      animationDuration: animationDuration,
      easingType: easingType,
      fadeIn: fadeIn,
      enableScaling: enableScaling,
      enableRotation: enableRotation,
      repeat: repeat,
      repeatInterval: repeatInterval,
      slideDirection: slideDirection,
      slideDistance: slideDistance,
      animationType: animationType,
      child: this,
    );
  }
}

/// Utility class for creating complex animations with multiple effects
class AnimationComposer {
  /// Compose multiple animation effects
  static Widget composeAnimations({
    required Widget child,
    Duration delay = Duration.zero,
    Duration animationDuration = const Duration(milliseconds: 800),
    List<AnimationType> animationTypes = const [
      AnimationType.slide,
      AnimationType.fadeIn
    ],
    EasingType easingType = EasingType.easeOut,
    SlideDirection slideDirection = SlideDirection.bottomToTop,
  }) {
    Widget animatedChild = child;

    for (var animationType in animationTypes) {
      animatedChild = FadeAnimationDelayed(
        delay: delay,
        animationDuration: animationDuration,
        easingType: easingType,
        animationType: animationType,
        slideDirection: slideDirection,
        child: animatedChild,
      );
    }

    return animatedChild;
  }
}
