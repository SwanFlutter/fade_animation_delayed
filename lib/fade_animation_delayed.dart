library;

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

  /// Opacity range for fade animations
  final double maxOpacity;

  /// The child widget to be animated
  final Widget child;

  /// Callback when animation completes
  final VoidCallback? onCompleted;

  /// Whether to track animation state across instances
  final bool useGlobalState;

  /// Whether to run animation only once
  final bool runOnce;

  /// Whether to reset animation on rebuild
  final bool resetOnRebuild;

  /// Unique identifier for this animation instance
  final String? instanceKey;

  /// Whether to start animation immediately
  final bool autoStart;

  /// Whether animation should be paused initially
  final bool initiallyPaused;

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
    this.maxRotation = 2 * pi / 180,
    this.minOpacity = 0.0,
    this.maxOpacity = 1.0,
    this.onCompleted,
    this.useGlobalState = false,
    this.runOnce = false,
    this.resetOnRebuild = false,
    this.instanceKey,
    this.autoStart = true,
    this.initiallyPaused = false,
    Key? key,
  }) : super(key: stateKey ?? key);

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
  bool _isAnimationCompleted = false;

  // Static tracking for global state
  static bool _hasAnimatedOnce = false;
  static final Map<String, bool> _instanceStates = {};

  @override
  void initState() {
    super.initState();

    // Create animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animationController.addStatusListener(_handleAnimationStatus);

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

    // Check if we should run the animation (based on global/instance state)
    if (_shouldRunAnimation()) {
      if (widget.autoStart && !widget.initiallyPaused) {
        _runAnimation();
      } else if (widget.initiallyPaused) {
        // Set to initial state but don't start
        if (widget.fadeIn) {
          _animationController.value = 0;
        } else {
          _animationController.value = 1;
        }
      }
    } else {
      // Animation should not run, set to completed state
      if (widget.fadeIn) {
        _animationController.value = 1;
      } else {
        _animationController.value = 0;
      }
      _isAnimationCompleted = true;
    }
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
    final double distance = widget.slideDistance * 8.0;
    switch (widget.slideDirection) {
      case SlideDirection.leftToRight:
        return Offset(-distance, 0.0); // Off-screen to the left
      case SlideDirection.rightToLeft:
        return Offset(distance, 0.0); // Off-screen to the right
      case SlideDirection.topToBottom:
        return Offset(0.0, -distance); // Off-screen from the top
      case SlideDirection.bottomToTop:
        return Offset(0.0, distance); // Off-screen from the bottom
    }
  }

  @override
  void dispose() {
    _animationController.removeStatusListener(_handleAnimationStatus);
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(FadeAnimationDelayed oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if any animation properties changed
    bool shouldRebuild = oldWidget.fadeIn != widget.fadeIn ||
        oldWidget.animationType != widget.animationType ||
        oldWidget.slideDirection != widget.slideDirection ||
        oldWidget.animationDuration != widget.animationDuration ||
        oldWidget.easingType != widget.easingType;

    // If the key changed, we should rebuild
    if (oldWidget.instanceKey != widget.instanceKey) {
      shouldRebuild = true;
    }

    if (shouldRebuild && widget.resetOnRebuild) {
      _resetAnimations();
      _runAnimation();
    }
  }

  // Reset all animations to initial state
  void _resetAnimations() {
    // Recreate animation with current properties
    final CurvedAnimation curvedAnimation = CurvedAnimation(
      curve: _getEasingCurve(),
      parent: _animationController,
    );

    _slideAnimationOffset = Tween<Offset>(
      begin: _getSlideBeginOffset(),
      end: Offset.zero,
    ).animate(curvedAnimation);

    _scaleAnimation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(curvedAnimation);

    _rotationAnimation = Tween<double>(
      begin: widget.minRotation,
      end: widget.maxRotation,
    ).animate(curvedAnimation);

    _opacityAnimation = Tween<double>(
      begin: widget.minOpacity,
      end: widget.maxOpacity,
    ).animate(curvedAnimation);

    // Reset controller
    _animationController.reset();
    _isAnimationCompleted = false;
  }

  // Run the animation with optional delay and repetition
  void _runAnimation() {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(widget.delay, () {
      if (mounted) {
        if (widget.repeat) {
          _animationController.repeat(
              reverse: true, period: widget.repeatInterval);
        } else {
          widget.fadeIn
              ? _animationController.forward()
              : _animationController.reverse();
        }
      }
    });
  }

  // Pause the current animation
  void pauseAnimation() {
    _animationController.stop();
  }

  // Resume the animation from current position
  void resumeAnimation() {
    if (_isAnimationCompleted) {
      _isAnimationCompleted = false;
      _animationController.reset();
    }
    if (widget.fadeIn) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  // Reset and restart the animation
  void resetAnimation() {
    _isAnimationCompleted = false;
    _animationController.reset();
    _runAnimation();
  }

  // Force animation to complete immediately
  void completeAnimation() {
    if (widget.fadeIn) {
      _animationController.animateTo(1.0, duration: Duration.zero);
    } else {
      _animationController.animateTo(0.0, duration: Duration.zero);
    }
    _isAnimationCompleted = true;
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed ||
        status == AnimationStatus.dismissed) {
      _isAnimationCompleted = true;

      // Update global or instance state
      if (widget.runOnce) {
        if (widget.useGlobalState) {
          _hasAnimatedOnce = true;
        } else {
          final key = widget.instanceKey ?? widget.stateKey?.toString() ?? '';
          if (key.isNotEmpty) {
            _instanceStates[key] = true;
          }
        }
      }

      widget.onCompleted?.call();
    }
  }

  bool _shouldRunAnimation() {
    // Always run if resetOnRebuild is true
    if (widget.resetOnRebuild) return true;

    // Check if animation should run only once
    if (widget.runOnce) {
      if (widget.useGlobalState) {
        return !_hasAnimatedOnce;
      } else {
        final key = widget.instanceKey ?? widget.stateKey?.toString() ?? '';
        return key.isEmpty || _instanceStates[key] != true;
      }
    }

    return true;
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
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: child,
          ),
        );
        break;
      case AnimationType.rotation:
        child = RotationTransition(
          turns: _rotationAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: child,
          ),
        );
        break;
    }

    // Optional additional transformations
    if (widget.enableScaling && widget.animationType != AnimationType.zoomIn) {
      child = ScaleTransition(
        scale: _scaleAnimation,
        child: child,
      );
    }

    if (widget.enableRotation &&
        widget.animationType != AnimationType.rotation) {
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
    VoidCallback? onCompleted,
    bool useGlobalState = false,
    bool runOnce = false,
    bool resetOnRebuild = false,
    String? instanceKey,
    bool autoStart = true,
    bool initiallyPaused = false,
    Key? key,
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
      onCompleted: onCompleted,
      useGlobalState: useGlobalState,
      runOnce: runOnce,
      resetOnRebuild: resetOnRebuild,
      instanceKey: instanceKey,
      autoStart: autoStart,
      initiallyPaused: initiallyPaused,
      key: key,
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
    String? instanceKey,
    bool useGlobalState = false,
    bool runOnce = false,
    Key? key,
  }) {
    Widget animatedChild = child;

    for (var animationType in animationTypes.reversed) {
      animatedChild = FadeAnimationDelayed(
        delay: delay,
        animationDuration: animationDuration,
        easingType: easingType,
        animationType: animationType,
        slideDirection: slideDirection,
        instanceKey: instanceKey,
        useGlobalState: useGlobalState,
        runOnce: runOnce,
        key: key,
        child: animatedChild,
      );
    }

    return animatedChild;
  }
}

/// A manager class to handle multiple animations simultaneously
class AnimationGroupManager {
  final Map<String, GlobalKey<FadeAnimationDelayedState>> _animationKeys = {};

  /// Register a new animation with a unique identifier
  GlobalKey<FadeAnimationDelayedState> registerAnimation(String id) {
    final key = GlobalKey<FadeAnimationDelayedState>();
    _animationKeys[id] = key;
    return key;
  }

  /// Get an existing animation key
  GlobalKey<FadeAnimationDelayedState>? getAnimationKey(String id) {
    return _animationKeys[id];
  }

  /// Pause a specific animation
  void pauseAnimation(String id) {
    _animationKeys[id]?.currentState?.pauseAnimation();
  }

  /// Resume a specific animation
  void resumeAnimation(String id) {
    _animationKeys[id]?.currentState?.resumeAnimation();
  }

  /// Reset a specific animation
  void resetAnimation(String id) {
    _animationKeys[id]?.currentState?.resetAnimation();
  }

  /// Pause all registered animations
  void pauseAll() {
    for (var key in _animationKeys.values) {
      key.currentState?.pauseAnimation();
    }
  }

  /// Resume all registered animations
  void resumeAll() {
    for (var key in _animationKeys.values) {
      key.currentState?.resumeAnimation();
    }
  }

  /// Reset all registered animations
  void resetAll() {
    for (var key in _animationKeys.values) {
      key.currentState?.resetAnimation();
    }
  }

  /// Complete all animations immediately
  void completeAll() {
    for (var key in _animationKeys.values) {
      key.currentState?.completeAnimation();
    }
  }
}
