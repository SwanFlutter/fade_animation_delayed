import 'package:fade_animation_delayed/fade_animation_delayed.dart';
import 'package:flutter/material.dart';

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
  final GlobalKey<FadeAnimationDelayedState> _delayedDisplayKey =
      GlobalKey<FadeAnimationDelayedState>();
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
                onPressed: () =>
                    _delayedDisplayKey.currentState?.pauseAnimation(),
                child: const Text('Pause'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () =>
                    _delayedDisplayKey.currentState?.resumeAnimation(),
                child: const Text('Resume'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () =>
                    _delayedDisplayKey.currentState?.resetAnimation(),
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
                opacity: Tween<double>(begin: 0.0, end: 1.0)
                    .animate(animationController),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.5, end: 1.0)
                      .animate(animationController),
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

// Import the animation package
/*
class AnimationShowcaseScreen extends StatefulWidget {
  const AnimationShowcaseScreen({super.key});

  @override
  _AnimationShowcaseScreenState createState() => _AnimationShowcaseScreenState();
}

class _AnimationShowcaseScreenState extends State<AnimationShowcaseScreen> with TickerProviderStateMixin {
  // Demo items to showcase different animations
  final List<Map<String, dynamic>> _animationDemos = [
    {
      'title': 'Slide from Bottom',
      'animationType': AnimationType.slideFromOutside,
      'slideDirection': SlideDirection.bottomToTop,
      'easingType': EasingType.easeOut,
    },
    {
      'title': 'Fade In with Zoom',
      'animationType': AnimationType.fadeIn,
      'enableScaling': true,
      'easingType': EasingType.elasticOut,
    },
    {
      'title': 'Rotation Animation',
      'animationType': AnimationType.zoomIn,
      'repeat': false,
      'repeatInterval': const Duration(seconds: 2),
      'easingType': EasingType.bounceOut,
    },
    {
      'title': 'Complex Slide and Fade',
      'animationTypes': [AnimationType.slide, AnimationType.fadeIn],
      'slideDirection': SlideDirection.rightToLeft,
      'easingType': EasingType.bounceOut,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced Animation Showcase'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _animationDemos.length,
        itemBuilder: (context, index) {
          final demo = _animationDemos[index];
          return _buildAnimationDemoCard(demo, index);
        },
      ),
    );
  }

  Widget _buildAnimationDemoCard(Map<String, dynamic> demo, int index) {
    return FadeAnimationDelayed(
      // Basic animation configuration
      delay: Duration(milliseconds: 200 * index), // Staggered delay
      animationDuration: const Duration(milliseconds: 1000),
      fadeIn: true,

      // Dynamic animation type handling
      animationType: demo['animationType'] ?? AnimationType.slide,

      // Optional additional configurations
      slideDirection: demo['slideDirection'] ?? SlideDirection.bottomToTop,
      easingType: demo['easingType'] ?? EasingType.easeOut,
      enableScaling: demo['enableScaling'] ?? false,
      repeat: demo['repeat'] ?? false,
      repeatInterval: demo['repeatInterval'] ?? const Duration(seconds: 5),

      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with custom animation
              Text(
                demo['title'],
                style: Theme.of(context).textTheme.titleLarge,
              ).animate(
                animationType: AnimationType.fadeIn,
                delay: const Duration(milliseconds: 300),
                easingType: EasingType.easeIn,
              ),
              const SizedBox(height: 8),

              // Detailed animation description
              Text(
                _getAnimationDescription(demo),
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              // Demonstration of complex animation composition
              if (demo['animationTypes'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: AnimationComposer.composeAnimations(
                    child: const FlutterLogo(size: 100),
                    animationTypes: demo['animationTypes'],
                    slideDirection: demo['slideDirection'] ?? SlideDirection.bottomToTop,
                    easingType: demo['easingType'] ?? EasingType.easeOut,
                  ),
                )
              else
                // Replace the FlutterLogo with a rotating logo
                AnimatedBuilder(
                  animation: Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: AnimationController(
                        vsync: this,
                        duration: const Duration(seconds: 2),
                      )..repeat(),
                      curve: Curves.linear,
                    ),
                  ),
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: 2 *
                          3.14159 *
                          Tween<double>(begin: 0.0, end: 1.0).evaluate(
                            CurvedAnimation(
                              parent: AnimationController(
                                vsync: this,
                                duration: const Duration(seconds: 2),
                              )..repeat(),
                              curve: Curves.linear,
                            ),
                          ),
                      child: const FlutterLogo(
                        size: 100,
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Generate a descriptive text for each animation demo
  String _getAnimationDescription(Map<String, dynamic> demo) {
    switch (demo['animationType']) {
      case AnimationType.slide:
        return 'A smooth sliding animation from ${_getDirectionName(demo['slideDirection'])}';
      case AnimationType.fadeIn:
        return 'A gentle fade-in effect with optional scaling';
      case AnimationType.rotation:
        return 'Continuous rotation animation with ${demo['repeat'] ? 'repetition' : 'single cycle'}';
      case AnimationType.zoomIn:
        return 'Zoom-in animation with elastic easing';
      default:
        return 'Demonstration of enhanced animation capabilities';
    }
  }

  // Helper method to convert slide direction to readable text
  String _getDirectionName(SlideDirection direction) {
    switch (direction) {
      case SlideDirection.bottomToTop:
        return 'bottom to top';
      case SlideDirection.topToBottom:
        return 'top to bottom';
      case SlideDirection.leftToRight:
        return 'left to right';
      case SlideDirection.rightToLeft:
        return 'right to left';
    }
  }
}

// Example of how to use the animation in a real widget
class AnimatedButtonExample extends StatelessWidget {
  const AnimatedButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animated Button Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Button with multiple animation effects
            ElevatedButton(
              onPressed: () {},
              child: const Text('Animated Interactive Button'),
            ).animate(
              animationType: AnimationType.slide,
              enableScaling: true,
              easingType: EasingType.elasticOut,
              delay: const Duration(milliseconds: 300),
            ),

            const SizedBox(height: 20),

            // Complex composed animation
            AnimationComposer.composeAnimations(
              child: const Text(
                'Advanced Animated Text',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              animationTypes: [AnimationType.slide, AnimationType.fadeIn, AnimationType.zoomIn],
              slideDirection: SlideDirection.rightToLeft,
            ),
          ],
        ),
      ),
    );
  }
}*/

/*
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FadeAnimationDelayedState> _delayedDisplayKey = GlobalKey<FadeAnimationDelayedState>();
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DelayedDisplay Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeAnimationDelayed(
              stateKey: _delayedDisplayKey,
              delay: const Duration(seconds: 1),
              animationDuration: const Duration(seconds: 2),
              animationCurve: Curves.easeIn,
              slideDirection: SlideDirection.rightToLeft,
              animationType: AnimationType.slideFromOutside,
              slideDistance: 0.55,
              child: const Text(
                'Welcome to DelayedDisplay!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            const FadeAnimationDelayed(
              delay: Duration(seconds: 2),
              child: Icon(Icons.star, size: 50, color: Colors.yellow),
            ),
            const SizedBox(height: 20),
            FadeAnimationDelayed(
              delay: const Duration(seconds: 3),
              enableScaling: true,
              child: ElevatedButton(
                child: const Text('Click me!'),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 20),
            const FadeAnimationDelayed(
              delay: Duration(seconds: 4),
              enableRotation: true,
              repeat: true,
              repeatInterval: Duration(seconds: 3),
              child: FlutterLogo(size: 50),
            ),
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
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isVisible = !_isVisible;
                });
              },
              child: Text(_isVisible ? 'Hide' : 'Show'),
            ),
            const SizedBox(height: 20),
            FadeAnimationDelayed(
              delay: const Duration(milliseconds: 500),
              animationDuration: const Duration(milliseconds: 500),
              animationCurve: Curves.easeInOut,
              fadeIn: _isVisible,
              child: const Text(
                'This text can be hidden or shown',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
