import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sufra_app/core/styles/appColors.dart';
import 'package:sufra_app/features/cart/presentation/cubit/cart/cart_cubit.dart';
import 'package:sufra_app/features/cart/presentation/views/cart_view.dart';
import 'package:sufra_app/features/notifications/presentation/views/notifications_view.dart';
import 'package:sufra_app/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:sufra_app/features/profile/presentation/cubit/profile/profile_state.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 252,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/welcome_food.png',
            fit: BoxFit.cover,
            alignment: Alignment.centerLeft,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  Colors.black.withValues(alpha: 0.80),
                  Colors.black.withValues(alpha: 0.48),
                  Colors.black.withValues(alpha: 0.28),
                ],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 13, 18, 82),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        String name = '';
                        String address = '';
                        if (state is ProfileLoaded) {
                          name = state.user.name.trim();
                          address = state.user.address.trim();
                        } else if (state is ProfileUpdating) {
                          name = state.user.name.trim();
                          address = state.user.address.trim();
                        } else if (state is ProfileUpdateSuccess) {
                          name = state.user.name.trim();
                          address = state.user.address.trim();
                        } else if (state is ProfileUpdateFailure) {
                          name = state.user.name.trim();
                          address = state.user.address.trim();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              name.isEmpty
                                  ? 'أهلًا بك في سفرة'
                                  : 'أهلًا، $name',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: GoogleFonts.cairo(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  size: 17,
                                  color: AppColors.white,
                                ),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    address.isEmpty
                                        ? 'أضف موقع التوصيل'
                                        : address,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.cairo(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  BlocBuilder<CartCubit, dynamic>(
                    builder: (context, state) => _HeaderIcon(
                      icon: Icons.shopping_bag_outlined,
                      count: state.totalQuantity as int,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartView()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  _HeaderIcon(
                    icon: Icons.notifications_none_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsView(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.icon, required this.onTap, this.count = 0});
  final IconData icon;
  final VoidCallback onTap;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(icon, color: AppColors.white, size: 25),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 36),
          tooltip: icon == Icons.shopping_bag_outlined ? 'السلة' : 'الإشعارات',
        ),
        if (count > 0)
          Positioned(
            top: -3,
            left: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              constraints: const BoxConstraints(minWidth: 17, minHeight: 17),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                count > 99 ? '99+' : '$count',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
