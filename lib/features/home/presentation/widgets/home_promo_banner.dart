import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sufra_app/core/styles/appColors.dart';

class HomePromoBanner extends StatefulWidget {
  const HomePromoBanner({super.key});
  @override
  State<HomePromoBanner> createState() => _HomePromoBannerState();
}

class _HomePromoBannerState extends State<HomePromoBanner> {
  static const _images = [
    'assets/home/banners/banner_1.png',
    'assets/home/banners/banner_2.png',
    'assets/home/banners/banner_3.png',
  ];
  final PageController _controller = PageController();
  Timer? _timer;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_controller.hasClients) return;
      _controller.animateToPage(
        (_current + 1) % _images.length,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 2.05,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19),
            child: PageView.builder(
              controller: _controller,
              itemCount: _images.length,
              onPageChanged: (index) => setState(() => _current = index),
              itemBuilder: (_, index) => Image.asset(
                _images[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const ColoredBox(
                  color: AppColors.primary,
                  child: Center(
                    child: Icon(
                      Icons.restaurant_menu,
                      color: AppColors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 9),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _images.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: index == _current ? 19 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: index == _current ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
