// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sufra_app/core/dependency_injection/dependency_injection.dart';
import 'package:sufra_app/core/styles/widgets/app_status_dialog.dart';
import 'package:sufra_app/features/authentication/presentation/cubit/login/login_cubit.dart';
import 'package:sufra_app/features/authentication/presentation/cubit/login/login_state.dart';
import 'package:sufra_app/features/authentication/presentation/views/registerView.dart';
import 'package:sufra_app/features/main_navigation/presentation/main_navigation_view.dart';

class loginView extends StatefulWidget {
  const loginView({super.key});

  @override
  State<loginView> createState() => _loginViewState();
}

class _loginViewState extends State<loginView> {
  static const Color primaryRed = Color(0xFFD71920);
  static const Color brandYellow = Color(0xFFFFC928);
  static const Color darkColor = Color(0xFF211916);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;

  String? _validateLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      return 'من فضلك أدخل البريد الإلكتروني وكلمة المرور';
    }

    final emailRegex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'من فضلك أدخل بريدًا إلكترونيًا صحيحًا';
    }

    if (password.length < 6) {
      return 'كلمة المرور يجب ألا تقل عن 6 أحرف';
    }

    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'أهلاً ${state.user.name}',
                  textAlign: TextAlign.right,
                ),
              ),
            );

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MainNavigationView()),
              (route) => false,
            );
          }

          if (state is LoginFailure) {
            AppStatusDialog.showError(
              context,
              title: 'تعذر تسجيل الدخول',
              message: state.message,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFE7E5),
                    Color(0xFFFFF8ED),
                    Color(0xFFFFE8A8),
                  ],
                  stops: [0.0, 0.52, 1.0],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: darkColor,
                              size: 22,
                            ),
                          ),
                        ),

                        Center(
                          child: Image.asset(
                            'assets/splash_logo2.png',
                            height: 105,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 18),

                        const Text(
                          'أهلاً برجوعك 👋',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: darkColor,
                            fontSize: 29,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'سجّل دخولك وكمل طلبك بكل سهولة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF7D7470),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 30),

                        Container(
                          padding: const EdgeInsets.fromLTRB(18, 26, 18, 24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.78),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryRed.withValues(alpha: 0.08),
                                blurRadius: 30,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'البريد الإلكتروني',
                                style: TextStyle(
                                  color: darkColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 8),

                              _AuthField(
                                controller: emailController,
                                hintText: 'example@email.com',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),

                              const SizedBox(height: 18),

                              const Text(
                                'كلمة المرور',
                                style: TextStyle(
                                  color: darkColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 8),

                              _AuthField(
                                controller: passwordController,
                                hintText: 'أدخل كلمة المرور',
                                icon: Icons.lock_outline_rounded,
                                obscureText: _obscurePassword,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: const Color(0xFF8F8783),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    foregroundColor: primaryRed,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                  ),
                                  child: const Text(
                                    'نسيت كلمة المرور؟',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              SizedBox(
                                height: 58,
                                child: ElevatedButton(
                                  onPressed: state is LoginLoading
                                      ? null
                                      : () {
                                          FocusScope.of(context).unfocus();

                                          final error = _validateLogin();

                                          if (error != null) {
                                            AppStatusDialog.showWarning(
                                              context,
                                              title: 'تحقق من البيانات',
                                              message: error,
                                            );
                                            return;
                                          }

                                          context.read<LoginCubit>().login(
                                            email: emailController.text.trim(),
                                            password: passwordController.text,
                                          );
                                        },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: primaryRed,
                                    disabledBackgroundColor: primaryRed
                                        .withValues(alpha: 0.6),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  child: state is LoginLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'تسجيل الدخول',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Icon(
                                              Icons.arrow_back_rounded,
                                              size: 21,
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'ليس لديك حساب؟',
                              style: TextStyle(
                                color: Color(0xFF716966),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterView(),
                                  ),
                                );
                              },
                              child: const Text(
                                'إنشاء حساب',
                                style: TextStyle(
                                  color: primaryRed,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Center(
                          child: Container(
                            width: 55,
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [primaryRed, brandYellow],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  const _AuthField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFA59D99), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFFD71920), size: 21),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFFFFBF8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFF0E5DF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD71920), width: 1.5),
        ),
      ),
    );
  }
}
