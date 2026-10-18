import 'package:sufra_app/features/home/presentation/views/latest_products_view.dart';
// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sufra_app/core/dependency_injection/dependency_injection.dart';
import 'package:sufra_app/core/styles/appColors.dart';
import 'package:sufra_app/features/home/presentation/widgets/FeaturedProductsSection.dart';
import 'package:sufra_app/features/home/presentation/widgets/home_categories_section.dart';
import 'package:sufra_app/features/home/presentation/widgets/home_header.dart';
import 'package:sufra_app/features/home/presentation/widgets/home_promo_banner.dart';
import 'package:sufra_app/features/home/presentation/widgets/home_search_field.dart';
import 'package:sufra_app/features/home/presentation/widgets/home_section_header.dart';
import 'package:sufra_app/features/home/presentation/widgets/latest_products_section.dart';
import 'package:sufra_app/features/home/presentation/widgets/popular_products_section.dart';
import 'package:sufra_app/features/products/presentation/cubit/products/products_cubit.dart';
import 'package:sufra_app/features/products/presentation/views/allProductsView.dart';
import 'package:sufra_app/features/profile/presentation/cubit/profile/profile_cubit.dart';

class Homeview extends StatelessWidget {
  const Homeview({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductsCubit>(
          create: (_) => getIt<ProductsCubit>()..loadHomeData(),
        ),
        BlocProvider<ProfileCubit>(
          create: (_) => getIt<ProfileCubit>()..getProfile(),
        ),
      ],
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  void _openAll(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const AllProductsView()),
  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Stack(
                  clipBehavior: Clip.none,
                  children: [
                    HomeHeader(),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: HomeSearchField(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const HomePromoBanner(),
                      const SizedBox(height: 23),
                      HomeSectionHeader(
                        title: 'الأقسام',
                        onViewAll: () => _openAll(context),
                      ),
                      const SizedBox(height: 12),
                      const HomeCategoriesSection(),
                      const SizedBox(height: 25),
                      HomeSectionHeader(
                        title: 'الأكثر طلبًا',
                        onViewAll: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AllProductsView(
                              popularOnly: true,
                              categoryName:
                                  '\u0627\u0644\u0623\u0643\u062b\u0631 \u0637\u0644\u0628\u064b\u0627',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const SizedBox(
                        height: 260,
                        child: PopularProductsSection(),
                      ),
                      const SizedBox(height: 25),
                      HomeSectionHeader(
                        title: 'مختاراتنا لك',
                        onViewAll: () => _openAll(context),
                      ),
                      const SizedBox(height: 12),
                      const FeaturedProductsSection(),
                      const SizedBox(height: 25),
                      HomeSectionHeader(
                        title: 'وصل حديثًا',
                        onViewAll: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<ProductsCubit>(),
                              child: const LatestProductsView(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const LatestProductsSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
