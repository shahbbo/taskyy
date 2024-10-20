import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget startWidget;
  const SplashScreen({super.key, required this.startWidget});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<double> rotationAnimation;

  @override
  void initState() {
    super.initState();

    initAnimations();
    navigateToHome();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff5F33E1),
      body: Center(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: RotationTransition(
            turns: rotationAnimation,
            child: Image.asset('assets/images/splash/splash.png'),
          ),
        ),
      ),
    );
  }

  void initAnimations() {
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));

    // Fade animation from 0 (invisible) to 1 (fully visible)
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));

    // Rotation animation, making the image rotate 1 complete circle (360 degrees)
    rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0, // 1 complete turn
    ).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));

    animationController.forward();
  }

  void navigateToHome() {
    Future.delayed(const Duration(seconds: 4), () {
      navigateFish(context, widget.startWidget);
    });
  }
}

void navigateFish(BuildContext context, Widget widget) {
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
        (route) => false,
  );
}
