import 'package:flutter/material.dart';
import 'package:sufra_app/authintication/login/loginview.dart';
import 'package:sufra_app/authintication/register/registerView.dart';
import 'package:sufra_app/home/views/homeView.dart';

import 'package:sufra_app/onbarding/FirstOnboardingView.dart';
import 'package:sufra_app/splashview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/home',
      routes: {
        '/splash': (context) => const SplashView(),
        '/onboarding': (context) => const OnboardingView(),
        '/login': (context) => const Loginview(),
        '/register': (context) => const RegisterView(),
        '/home': (context) => const Homeview(),
      },
    );
  }
}
