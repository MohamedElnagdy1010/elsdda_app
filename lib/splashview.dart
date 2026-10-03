import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sufra_app/features/main_navigation/presentation/main_navigation_view.dart';
import 'package:sufra_app/onbarding/FirstOnboardingView.dart';
import 'package:sufra_app/welcomeView.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    await Future.delayed(const Duration(milliseconds: 2200));

    final currentUser = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    if (currentUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationView()),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

    if (!mounted) return;

    if (onboardingCompleted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeView()),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFE7E5), // أحمر فاتح واضح من فوق
              Color(0xFFFFF8ED), // كريمي في المنتصف
              Color(0xFFFFE8A8), // أصفر دافئ من تحت
            ],
            stops: [0.0, 0.52, 1.0],
          ),
        ),

        child: Stack(
          children: [
            // تدرج أحمر خفيف أعلى اليمين
            Positioned(
              top: -120,
              right: -110,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFD71920).withValues(alpha: 0.22),
                      const Color(0xFFD71920).withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),

            // تدرج أصفر خفيف أسفل اليسار
            Positioned(
              bottom: -150,
              left: -130,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFFC928).withValues(alpha: 0.22),
                      const Color(0xFFFFC928).withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),

            // اللوجو في منتصف الشاشة
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Image.asset(
                  'assets/splash_logo2.png',
                  width: screenWidth * 0.90,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'حاشي بشاور',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF211916),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
