import 'dart:async';

import 'package:flutter/material.dart';

class HomePromoBanner extends StatefulWidget {
  const HomePromoBanner({super.key});

  @override
  State<HomePromoBanner> createState() => _HomePromoBannerState();
}

class _HomePromoBannerState extends State<HomePromoBanner> {
  static const int _initialPage = 1000;

  final PageController _pageController = PageController(
    initialPage: _initialPage,
    viewportFraction: 1.0,
  );

  final List<String> _banners = const [
    'assets/home/banners/banner_1.png',
    'assets/home/banners/banner_2.png',
    'assets/home/banners/banner_3.png',
  ];

  Timer? _timer;

  int _currentPage = 0;
  int _virtualPage = _initialPage;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;

      _virtualPage++;

      _pageController.animateToPage(
        _virtualPage,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _onPageChanged(int index) {
    _virtualPage = index;

    if (!mounted) return;

    setState(() {
      _currentPage = index % _banners.length;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 310,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final bannerIndex = index % _banners.length;

                return _BannerImage(imagePath: _banners[bannerIndex]);
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (index) {
            final selected = index == _currentPage;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: selected ? 22 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xffB60F1A)
                    : const Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _BannerImage extends StatelessWidget {
  final String imagePath;

  const _BannerImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(22),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Image.asset(
          imagePath,
          width: double.infinity,
          height: double.infinity,

          // هنحافظ على ملء مساحة البانر بالكامل.
          fit: BoxFit.fill,

          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xffB60F1A),
              alignment: Alignment.center,
              child: const Icon(
                Icons.restaurant_menu_rounded,
                size: 44,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}
