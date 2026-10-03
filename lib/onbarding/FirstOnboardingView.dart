import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:sufra_app/core/common/filledButton.dart';
import 'package:sufra_app/welcomeView.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController pageController = PageController();

  int currentPage = 0;
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (currentPage < onboardingData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      finishOnboarding();
    }
  }

  Future<void> finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('onboarding_completed', true);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeView()),
    );
  }

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/onbording/Findfood1.png",
      "title": "ابحث عن الطعام الذي تحبه",
      "description":
          "اكتشف أفضل الأطعمة من أكثر من 1,000 مطعم مع توصيل سريع إلى باب منزلك!",
    },
    {
      "image": "assets/onbording/Delivery2.png",
      "title": "اطلب طعامك بسهولة",
      "description":
          "اختر وجبتك المفضلة وأكمل طلبك بسهولة وسرعة من خلال تطبيقنا.",
    },
    {
      "image": "assets/onbording/Livetracking3.png",
      "title": "استمتع بوجبتك",
      "description":
          "تابع طلبك حتى يصل إليك واستمتع بالطعام الذي تحبه أينما كنت.",
    },
  ];

  @override
  // void dispose() {
  //   pageController.dispose();
  //   super.dispose();
  // }
  // // الانتقال للصفحة التالية
  // void nextPage() {
  //   if (currentPage < onboardingData.length - 1) {
  //     pageController.nextPage(
  //       duration: const Duration(milliseconds: 400),
  //       curve: Curves.easeInOut,
  //     );
  //   } else {
  //     finishOnboarding();
  //   }
  // }
  // // تخطي الـ onboarding
  // void skipOnboarding() {
  //   finishOnboarding();
  // }
  // Future<void> finishOnboarding() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('onboarding_completed', true);
  //   if (!mounted) return;
  //   Navigator.pushReplacementNamed(
  //     context,
  //     '/login',
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Skip
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: finishOnboarding,
                  child: const Text(
                    "تخطي",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),

              // Pages
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: onboardingData.length,

                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },

                  itemBuilder: (context, index) {
                    final data = onboardingData[index];

                    return Column(
                      children: [
                        const Spacer(),

                        // Image
                        Image.asset(
                          data["image"]!,
                          width: double.infinity,
                          height: 350,
                          fit: BoxFit.contain,
                        ),

                        const SizedBox(height: 30),

                        // Title
                        Text(
                          data["title"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Description
                        Text(
                          data["description"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.6,
                            color: Colors.grey,
                          ),
                        ),

                        const Spacer(),
                      ],
                    );
                  },
                ),
              ),

              // Indicator
              AnimatedSmoothIndicator(
                activeIndex: currentPage,
                count: onboardingData.length,
                effect: const ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  expansionFactor: 3,
                  spacing: 6,
                  activeDotColor: Colors.red,
                  dotColor: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              // Next / Get Started
              CustomFilledbutton(
                text: currentPage == onboardingData.length - 1
                    ? "ابدأ الآن"
                    : "التالي",
                onPressed: nextPage,
                color: Colors.red,
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
