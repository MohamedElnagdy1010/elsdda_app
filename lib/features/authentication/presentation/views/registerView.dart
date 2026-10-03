// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sufra_app/core/dependency_injection/dependency_injection.dart';
import 'package:sufra_app/core/styles/widgets/app_status_dialog.dart';
import 'package:sufra_app/features/authentication/presentation/cubit/register/register_cubit.dart';
import 'package:sufra_app/features/authentication/presentation/cubit/register/register_state.dart';
import 'package:sufra_app/features/authentication/presentation/views/loginView.dart';
import 'package:sufra_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:sufra_app/features/main_navigation/presentation/main_navigation_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  static const Color primaryRed = Color(0xFFD71920);
  static const Color brandYellow = Color(0xFFFFC928);
  static const Color darkColor = Color(0xFF211916);

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;

  String? _validateRegister() {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty) {
      return 'من فضلك أكمل جميع البيانات المطلوبة';
    }

    if (name.length < 2) {
      return 'من فضلك أدخل اسمًا صحيحًا';
    }

    final normalizedPhone = phone.replaceAll(RegExp(r'[\s-]'), '');

    if (!RegExp(r'^\+?[0-9]{8,15}$').hasMatch(normalizedPhone)) {
      return 'من فضلك أدخل رقم جوال صحيحًا';
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
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _register(BuildContext context) {
    FocusScope.of(context).unfocus();

    final error = _validateRegister();

    if (error != null) {
      AppStatusDialog.showWarning(
        context,
        title: 'تحقق من البيانات',
        message: error,
      );
      return;
    }

    final password = passwordController.text;

    context.read<RegisterCubit>().register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),

      // هنضيف العنوان لاحقًا من Google Maps.
      address: '',

      password: password,

      // نحافظ حاليًا على نفس interface الخاص بالـ Cubit.
      confirmPassword: password,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterCubit>(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'تم إنشاء الحساب بنجاح',
                  textAlign: TextAlign.right,
                ),
              ),
            );

            final user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              context.read<FavoritesCubit>().loadFavorites(user.uid);
            }

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MainNavigationView()),
              (route) => false,
            );
          }

          if (state is RegisterFailure) {
            AppStatusDialog.showError(
              context,
              title: 'تعذر إنشاء الحساب',
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
                            height: 95,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'إنشاء حساب',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: darkColor,
                            fontSize: 29,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 7),

                        const Text(
                          'انضم إلينا وابدأ طلبك بكل سهولة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF7D7470),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Container(
                          padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
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
                              const _FieldTitle('الاسم'),

                              const SizedBox(height: 8),

                              _AuthField(
                                controller: nameController,
                                hintText: 'اكتب اسمك',
                                icon: Icons.person_outline_rounded,
                                keyboardType: TextInputType.name,
                              ),

                              const SizedBox(height: 16),

                              const _FieldTitle('رقم الجوال'),

                              const SizedBox(height: 8),

                              _AuthField(
                                controller: phoneController,
                                hintText: '05xxxxxxxx',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                              ),

                              const SizedBox(height: 16),

                              const _FieldTitle('البريد الإلكتروني'),

                              const SizedBox(height: 8),

                              _AuthField(
                                controller: emailController,
                                hintText: 'example@email.com',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),

                              const SizedBox(height: 16),

                              const _FieldTitle('كلمة المرور'),

                              const SizedBox(height: 8),

                              _AuthField(
                                controller: passwordController,
                                hintText: '6 أحرف على الأقل',
                                icon: Icons.lock_outline_rounded,
                                obscureText: _obscurePassword,
                                onSubmitted: (_) {
                                  if (state is! RegisterLoading) {
                                    _register(context);
                                  }
                                },
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

                              const SizedBox(height: 24),

                              SizedBox(
                                height: 58,
                                child: ElevatedButton(
                                  onPressed: state is RegisterLoading
                                      ? null
                                      : () => _register(context),
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
                                  child: state is RegisterLoading
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
                                              'إنشاء الحساب',
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

                        const SizedBox(height: 18),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'لديك حساب بالفعل؟',
                              style: TextStyle(
                                color: Color(0xFF716966),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const loginView(),
                                  ),
                                );
                              },
                              child: const Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                  color: primaryRed,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 5),

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

class _FieldTitle extends StatelessWidget {
  final String title;

  const _FieldTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: _RegisterViewState.darkColor,
        fontSize: 13,
        fontWeight: FontWeight.w700,
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
  final ValueChanged<String>? onSubmitted;

  const _AuthField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onSubmitted: onSubmitted,
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
