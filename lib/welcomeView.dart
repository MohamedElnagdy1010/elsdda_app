import 'package:flutter/material.dart';

import 'package:sufra_app/features/authentication/presentation/views/loginview.dart';
import 'package:sufra_app/features/authentication/presentation/views/registerView.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  static const Color primaryRed = Color(0xFFD71920);
  static const Color brandYellow = Color(0xFFFFC928);
  static const Color darkColor = Color(0xFF211916);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFE7E5), Color(0xFFFFF8ED), Color(0xFFFFE8A8)],
            stops: [0.0, 0.52, 1.0],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
                    child: Column(
                      children: [
                        // Logo
                        SizedBox(
                          height: 100,
                          child: Image.asset(
                            'assets/splash_logo2.png',
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Food hero image
                        Container(
                          width: double.infinity,
                          height: size.height * 0.38,
                          constraints: const BoxConstraints(
                            minHeight: 270,
                            maxHeight: 370,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(34),
                            boxShadow: [
                              BoxShadow(
                                color: primaryRed.withValues(alpha: 0.10),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(34),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  "assets/welcome_food.png",
                                  fit: BoxFit.cover,
                                  alignment: Alignment.bottomCenter,
                                ),

                                // تدرج بسيط فوق الصورة
                                const DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Color.fromARGB(0, 0, 0, 0),
                                        Color.fromARGB(66, 0, 0, 0),
                                      ],
                                    ),
                                  ),
                                ),

                                // Badge
                                Positioned(
                                  top: 18,
                                  right: 18,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.92,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.local_fire_department_rounded,
                                          color: primaryRed,
                                          size: 17,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'طازج ولذيذ',
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            color: darkColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        const Text(
                          'وجبتك المفضلة\nأقرب لك',
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            color: darkColor,
                            fontSize: 30,
                            height: 1.25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            'اختار وجبتك، اطلبها بسهولة، واستمتع بطعم يستاهل.',
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Color(0xFF786F6B),
                              fontSize: 14,
                              height: 1.6,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Login
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const loginView(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color.fromARGB(210, 138, 34, 37),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(Icons.arrow_back_rounded, size: 21),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Register
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RegisterView(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: darkColor,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.62,
                              ),
                              side: const BorderSide(
                                color: Color.fromARGB(255, 197, 194, 194),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              'إنشاء حساب جديد',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 22,
                              height: 3,
                              decoration: BoxDecoration(
                                color: primaryRed,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              width: 7,
                              height: 3,
                              decoration: BoxDecoration(
                                color: brandYellow,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
