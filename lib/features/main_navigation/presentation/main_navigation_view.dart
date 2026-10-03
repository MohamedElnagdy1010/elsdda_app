import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glassmorphism/glassmorphism.dart';

import 'package:sufra_app/categories/categoriesView.dart';
import 'package:sufra_app/features/home/presentation/views/homeView.dart';
import 'package:sufra_app/features/orders/presentation/views/my_orders_view.dart';
import 'package:sufra_app/features/profile/presentation/views/profileView.dart';
import 'package:sufra_app/more/views/moreView.dart';

class MainNavigationView extends StatefulWidget {
  final int initialIndex;

  const MainNavigationView({super.key, this.initialIndex = 2});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  late int currentIndex;

  final List<Widget> pages = const [
    CategoriesView(),
    MyOrdersView(),
    Homeview(),
    ProfileView(),
    MoreView(),
  ];

  final List<_NavigationItem> items = const [
    _NavigationItem(label: 'الأقسام', asset: 'assets/home/svgs/Group 6847.svg'),
    _NavigationItem(
      label: 'طلباتي',
      asset: 'assets/home/svgs/002-shopping-bag.svg',
    ),
    _NavigationItem(label: 'الرئيسية', asset: 'assets/home/svgs/001-home.svg'),
    _NavigationItem(label: 'حسابي', asset: 'assets/home/svgs/man-user.svg'),
    _NavigationItem(label: 'المزيد', asset: 'assets/home/svgs/Group 6814.svg'),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex.clamp(0, pages.length - 1);
  }

  void _changePage(int index) {
    if (index == currentIndex) return;

    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xffFAFAFA),
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: _GlassBottomNavigation(
        currentIndex: currentIndex,
        items: items,
        onTap: _changePage,
      ),
    );
  }
}

class _GlassBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final List<_NavigationItem> items;
  final ValueChanged<int> onTap;

  const _GlassBottomNavigation({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.paddingOf(context).bottom;

    return SizedBox(
      height: 105 + safeBottom,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 14,
            right: 14,
            bottom: safeBottom > 0 ? 8 : 12,
            child: GlassmorphicContainer(
              width: double.infinity,
              height: 76,
              borderRadius: 25,
              blur: 25,
              alignment: Alignment.center,
              border: 1.4,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.92),
                  Colors.white.withValues(alpha: 0.72),
                ],
              ),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 1),
                  const Color(0xffB60F1A).withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.7),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  textDirection: TextDirection.ltr,
                  children: List.generate(items.length, (index) {
                    if (index == 2) {
                      return const Expanded(child: SizedBox());
                    }

                    return Expanded(
                      child: _NormalNavigationItem(
                        item: items[index],
                        selected: currentIndex == index,
                        onTap: () => onTap(index),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: safeBottom > 0 ? 31 : 35,
            child: _HomeNavigationItem(
              item: items[2],
              selected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _NormalNavigationItem extends StatelessWidget {
  final _NavigationItem item;
  final bool selected;
  final VoidCallback onTap;

  const _NormalNavigationItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  static const Color _primaryColor = Color(0xffB60F1A);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                width: selected ? 40 : 34,
                height: 31,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? _primaryColor.withValues(alpha: 0.11)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  item.asset,
                  width: selected ? 20 : 19,
                  height: selected ? 20 : 19,
                  colorFilter: ColorFilter.mode(
                    selected ? _primaryColor : const Color(0xff777777),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected ? _primaryColor : const Color(0xff777777),
                ),
                child: Text(item.label, maxLines: 1),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: selected ? 16 : 0,
                height: 2.5,
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeNavigationItem extends StatelessWidget {
  final _NavigationItem item;
  final bool selected;
  final VoidCallback onTap;

  const _HomeNavigationItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  static const Color _primaryColor = Color(0xffB60F1A);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutBack,
            width: selected ? 61 : 56,
            height: selected ? 61 : 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? _primaryColor : const Color(0xff333333),
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: selected
                      ? _primaryColor.withValues(alpha: 0.35)
                      : Colors.black.withValues(alpha: 0.16),
                  blurRadius: selected ? 18 : 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                item.asset,
                width: 23,
                height: 23,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              color: selected ? _primaryColor : const Color(0xff777777),
            ),
            child: Text(item.label),
          ),
        ],
      ),
    );
  }
}

class _NavigationItem {
  final String label;
  final String asset;

  const _NavigationItem({required this.label, required this.asset});
}
