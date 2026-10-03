import 'package:flutter/material.dart';

import 'package:sufra_app/features/favorites/presentation/views/favorites_view.dart';
import 'package:sufra_app/features/notifications/presentation/views/notifications_view.dart';
import 'package:sufra_app/features/orders/presentation/views/my_orders_view.dart';
import 'package:sufra_app/more/views/aboutUsView.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  static const Color _primaryColor = Color(0xffB60F1A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xffFAFAFA),
        surfaceTintColor: const Color(0xffFAFAFA),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'المزيد',
          style: TextStyle(
            color: Color(0xff202020),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildHeader(),

              const SizedBox(height: 22),

              const _SectionTitle(title: 'حسابك'),

              const SizedBox(height: 10),

              _MoreItem(
                title: 'طلباتي',
                subtitle: 'تابع حالة طلباتك السابقة والحالية',
                icon: Icons.shopping_bag_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyOrdersView()),
                  );
                },
              ),

              const SizedBox(height: 10),

              _MoreItem(
                title: 'المفضلة',
                subtitle: 'الأصناف التي حفظتها للرجوع إليها',
                icon: Icons.favorite_border_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoritesView()),
                  );
                },
              ),

              const SizedBox(height: 10),

              _MoreItem(
                title: 'الإشعارات',
                subtitle: 'تابع تحديثات الطلبات والعروض',
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

              const SizedBox(height: 24),

              const _SectionTitle(title: 'عن التطبيق'),

              const SizedBox(height: 10),

              _MoreItem(
                title: 'من نحن',
                subtitle: 'تعرف أكثر على المطعم وخدماتنا',
                icon: Icons.info_outline_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutUsView()),
                  );
                },
              ),

              const SizedBox(height: 10),

              const _MoreItem(
                title: 'سياسة الخصوصية ',
                subtitle: 'سياسة الاستخدام وحماية بياناتك',
                icon: Icons.privacy_tip_outlined,
              ),

              const SizedBox(height: 22),

              const Center(
                child: Text(
                  'Sufra',
                  style: TextStyle(
                    color: Color(0xffB7B7B7),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _primaryColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: const Row(
        textDirection: TextDirection.rtl,
        children: [
          ContainerIcon(),
          SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'كل ما تحتاجه في مكان واحد',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'طلباتك، المفضلة، الإشعارات والمزيد',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xffF4D9DB),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContainerIcon extends StatelessWidget {
  const ContainerIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 23),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        textAlign: TextAlign.right,
        style: const TextStyle(
          color: Color(0xff202020),
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _MoreItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const _MoreItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  static const Color _primaryColor = Color(0xffB60F1A);

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          constraints: const BoxConstraints(minHeight: 72),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: const Color(0xffEEEEEE)),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: enabled
                      ? _primaryColor.withValues(alpha: 0.08)
                      : const Color(0xffF3F3F3),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  size: 21,
                  color: enabled ? _primaryColor : const Color(0xffAAAAAA),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: enabled
                            ? const Color(0xff202020)
                            : const Color(0xff888888),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xff999999),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                enabled
                    ? Icons.arrow_back_ios_new_rounded
                    : Icons.lock_outline_rounded,
                size: enabled ? 14 : 15,
                color: const Color(0xffB0B0B0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
