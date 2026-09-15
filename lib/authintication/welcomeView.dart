import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sufra_app/authintication/login/loginview.dart';
import 'package:sufra_app/authintication/register/registerView.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 500,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: double.infinity,

                  child: Image.asset(
                    "assets/auth/Organe top shape.png",
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  bottom: -20,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        child: Image.asset("assets/splash_screen.png"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 5,
                        children: [
                          Text(
                            "السدة",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 136, 8, 8),
                            ),
                          ),
                          Text(
                            "مطعم ",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(40),
          SizedBox(
            width: 280,
            child: Text(
              "اكتشف أفضل الأطعمة من أكثر من 1,000 مطعم مع توصيل سريع إلى باب منزلك! ",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
            ),
          ),
          Spacer(),
          FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (context) => Loginview()),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 136, 8, 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 100,
                vertical: 15,
              ),
            ),

            child: Text(
              "تسجيل الدخول",
              style: TextStyle(fontSize: 25, color: Colors.grey[200]),
            ),
          ),

          Gap(20),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (context) => RegisterView()),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: Color.fromARGB(255, 136, 8, 8),
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 100,
                vertical: 15,
              ),
            ),
            child: Text(
              "إنشاء حساب",
              style: TextStyle(fontSize: 25, color: Colors.grey[700]),
            ),
          ),
          Gap(40),
        ],
      ),
    );
  }
}
