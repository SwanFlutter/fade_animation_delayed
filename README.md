# FadeAnimationDelayed

FadeAnimationDelayed is a custom Flutter widget that allows you to display content with a delay and various animations. It's perfect for creating dynamic and engaging user interfaces.

## Features

- Display content with adjustable delay
- Multiple animation types including fade, slide, scale, and rotation
- Repeatable animations
- Controllable animations (pause, resume, and reset)
- Support for custom animations

- ![animatins](https://github.com/user-attachments/assets/871502c1-ec47-494c-9831-7f90e688761f)


## Installation

To use this package, add `fade_animation_delayed` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  fade_animation_delayed: ^0.0.2
```

- Usage
To use FadeAnimationDelayed, import it in your Dart code:

```dart
import 'package:fade_animation_delayed/fade_animation_delayed.dart';

```

Then you can use it in your widgets:

```dart

FadeAnimationDelayed(
  delay: Duration(seconds: 1),
  child: Text('Hello, World!'),
)

```

## Advanced Examples
- Using Multiple Animations

```dart
final GlobalKey<FadeAnimationDelayedState> delayedDisplayKey = GlobalKey<FadeAnimationDelayedState>();

FadeAnimationDelayed(
  stateKey: delayedDisplayKey,
  delay: Duration(seconds: 1),
  fadingDuration: Duration(milliseconds: 500),
  slidingCurve: Curves.easeInOut,
  slidingBeginOffset: Offset(0.0, 0.1),
  enableScaling: true,
  enableRotation: true,
  child: Text('Text with multiple animations'),
)
```

- Repeating Animation

```dart

DelayedDisplay(
  delay: Duration(seconds: 1),
  repeat: true,
  repeatInterval: Duration(seconds: 3),
  child: Icon(Icons.favorite),
)

```

- Controlling Animation

```dart
final GlobalKey<FadeAnimationDelayedState> delayedDisplayKey = GlobalKey<FadeAnimationDelayedState>();

// Somewhere in your code
ElevatedButton(
  onPressed: () => delayedDisplayKey.currentState?.pauseAnimation(),
  child: Text('Pause'),
),
ElevatedButton(
  onPressed: () => delayedDisplayKey.currentState?.resumeAnimation(),
  child: Text('Resume'),
),
ElevatedButton(
  onPressed: () => delayedDisplayKey.currentState?.resetAnimation(),
  child: Text('Reset'),
),
```

- Custom Animation

```dart
FadeAnimationDelayed(
  customAnimationBuilder: (context, child, animation) {
    return FadeTransition(
      opacity: animation,
      child: Transform(
        transform: Matrix4.rotationZ(animation.value * 2 * pi),
        alignment: Alignment.center,
        child: child,
      ),
    );
  },
  child: Text('Custom Animation'),
)
```

- Use Extension

```dart


 Center(
      child: const Text(
          "Hello",
            style: TextStyle(fontSize: 40),
        ).animate(
        delay: const Duration(seconds: 1),
        fadeIn: true,
         easingType: EasingType.bounceOut,
       repeat: false,
        repeatInterval: const Duration(seconds: 1),
   ),
 )

```

## Example Complete

```dart
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DelayedDisplay Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Screen(),
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  final GlobalKey<FadeAnimationDelayedState> _delayedDisplayKey = GlobalKey<FadeAnimationDelayedState>();
  bool _isVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _delayedDisplayKey.currentState?.pauseAnimation(),
                child: const Text('Pause'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _delayedDisplayKey.currentState?.resumeAnimation(),
                child: const Text('Resume'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _delayedDisplayKey.currentState?.resetAnimation(),
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Example 1: Fade In with Slide from Bottom to Top
          FadeAnimationDelayed(
            delay: const Duration(seconds: 1),
            animationDuration: const Duration(seconds: 2),
            animationType: AnimationType.slideFromOutside,
            slideDirection: SlideDirection.bottomToTop,
            fadeIn: true,
            child: _buildExampleCard('Slide + Fade In (Bottom to Top)'),
          ),

          const SizedBox(height: 20),

          // Example 2: Zoom In Animation
          FadeAnimationDelayed(
            //  stateKey: _delayedDisplayKey,
            delay: const Duration(seconds: 1),
            animationDuration: const Duration(seconds: 2),
            animationType: AnimationType.zoomIn,
            enableScaling: true,
            minScale: 0.5,
            maxScale: 1.0,
            child: _buildExampleCard('Zoom In Animation'),
          ),

          const SizedBox(height: 20),

          // Example 3: Rotation Animation
          FadeAnimationDelayed(
            stateKey: _delayedDisplayKey,
            delay: const Duration(seconds: 1),
            animationDuration: const Duration(seconds: 2),
            animationType: AnimationType.rotation,
            enableRotation: true,
            minRotation: 0.0,
            maxRotation: 360,
            child: _buildExampleCard('Rotation Animation'),
          ),

          const SizedBox(height: 20),

          // Example 4: Bounce Out with Slide from Left to Right
          FadeAnimationDelayed(
            delay: const Duration(seconds: 1),
            animationDuration: const Duration(seconds: 2),
            easingType: EasingType.bounceOut,
            animationType: AnimationType.slideFromOutside,
            slideDirection: SlideDirection.leftToRight,
            child: _buildExampleCard('Bounce Out + Slide (Left to Right)'),
          ),

          const SizedBox(height: 20),

          // Example 5: Elastic Out with Fade In
          FadeAnimationDelayed(
            delay: const Duration(milliseconds: 500),
            animationDuration: const Duration(seconds: 3),
            easingType: EasingType.elasticOut,
            animationType: AnimationType.fadeIn,
            minOpacity: 0.2,
            maxOpacity: 1.0,
            child: _buildExampleCard('Elastic Out + Fade In'),
          ),

          const SizedBox(height: 20),

          // Example 6: Repeated Slide and Fade
          FadeAnimationDelayed(
            delay: const Duration(milliseconds: 500),
            animationDuration: const Duration(seconds: 1),
            repeat: false,
            repeatInterval: const Duration(seconds: 4),
            animationType: AnimationType.slide,
            slideDirection: SlideDirection.topToBottom,
            child: _buildExampleCard('Repeated Slide + Fade (Top to Bottom)'),
          ),

          const SizedBox(height: 20),

          // Example 7: Custom Animation Builder
          FadeAnimationDelayed(
            delay: const Duration(milliseconds: 500),
            animationDuration: const Duration(seconds: 2),
            customAnimationBuilder: (context, child, animationController) {
              return FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animationController),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.5, end: 1.0).animate(animationController),
                  child: child,
                ),
              );
            },
            child: _buildExampleCard('Custom Animation Builder'),
          ),

          Center(
            child: const Text(
              "Hello",
              style: TextStyle(fontSize: 40),
            ).animate(
              delay: const Duration(seconds: 1),
              fadeIn: true,
              easingType: EasingType.bounceOut,
              repeat: false,
              repeatInterval: const Duration(seconds: 1),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isVisible = !_isVisible;
              });
            },
            child: Text(_isVisible ? 'Hide' : 'Show'),
          ),
          const SizedBox(height: 20),
          Center(
            child: FadeAnimationDelayed(
              delay: const Duration(milliseconds: 500),
              animationDuration: const Duration(milliseconds: 500),
              fadeIn: _isVisible,
              child: const Text(
                'This text can be hidden or shown',
                style: TextStyle(fontSize: 35),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(String text) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

```

- Contributing
Your contributions to this project are highly appreciated. Please open an issue for any problems, suggestions, or improvements, or submit a pull request.
