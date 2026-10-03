import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sufra_app/features/cart/presentation/cubit/cart/cart_cubit.dart';
import 'package:sufra_app/features/cart/presentation/views/cart_view.dart';
import 'package:sufra_app/features/notifications/presentation/views/notifications_view.dart';
import 'package:sufra_app/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:sufra_app/features/profile/presentation/cubit/profile/profile_state.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  static const Color _primaryColor = Color(0xffB60F1A);
  static const Color _darkColor = Color(0xff211916);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final user = _getUserFromState(state);

        final name = user?.name.trim() ?? '';
        final address = user?.address.trim() ?? '';

        return Column(
          children: [
            // =========================
            // First Row: Name + Logo
            // =========================
            // =========================
            // First Row: Name + Logo
            // =========================
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo - Left
                Image.asset(
                  'assets/splash_logo2.png',
                  width: 80,
                  height: 62,
                  fit: BoxFit.cover,
                ),

                const SizedBox(width: 12),

                // Name - Right
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        name.isEmpty ? 'أهلًا بك' : 'أهلًا، $name',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: _darkColor,
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        'إيه اللي نفسك تاكله النهارده؟',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff8A817D),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // =========================
            // Second Row: Location + Actions
            // =========================
            Row(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // Google Maps / Address selector later.
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 20,
                            color: _primaryColor,
                          ),

                          const SizedBox(width: 5),

                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'موقع التوصيل',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff99918D),
                                  ),
                                ),

                                const SizedBox(height: 1),

                                Row(
                                  textDirection: TextDirection.rtl,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        address.isEmpty ? 'أضف موقعك' : address,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w800,
                                          color: _darkColor,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 3),

                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 17,
                                      color: Color(0xff77706C),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 18),

                // Cart
                _CartButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartView()),
                    );
                  },
                ),

                const SizedBox(width: 17),

                // Notifications
                _ModernIconButton(
                  icon: Icons.notifications_none_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsView(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  dynamic _getUserFromState(ProfileState state) {
    if (state is ProfileLoaded) {
      return state.user;
    }

    if (state is ProfileUpdating) {
      return state.user;
    }

    if (state is ProfileUpdateSuccess) {
      return state.user;
    }

    if (state is ProfileUpdateFailure) {
      return state.user;
    }

    return null;
  }
}

class _ModernIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ModernIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 37,
          height: 37,
          child: Icon(icon, size: 27, color: const Color(0xff211916)),
        ),
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CartButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, dynamic>(
      builder: (context, state) {
        final count = state.totalQuantity;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            _ModernIconButton(icon: Icons.shopping_bag_outlined, onTap: onTap),

            if (count > 0)
              Positioned(
                right: -2,
                top: -3,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 17,
                    minHeight: 17,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xffB60F1A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xffFAFAFA),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    count > 99 ? '99+' : '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
