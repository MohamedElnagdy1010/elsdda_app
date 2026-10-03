// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sufra_app/core/dependency_injection/dependency_injection.dart';

import 'package:sufra_app/features/home/presentation/widgets/FeaturedProductsSection.dart';
import 'package:sufra_app/features/home/presentation/widgets/home_categories_section.dart';
import 'package:sufra_app/features/home/presentation/widgets/home_header.dart';
import 'package:sufra_app/features/home/presentation/widgets/home_promo_banner.dart';
import 'package:sufra_app/features/home/presentation/widgets/home_section_header.dart';
import 'package:sufra_app/features/home/presentation/widgets/latest_products_section.dart';
import 'package:sufra_app/features/home/presentation/widgets/popular_products_section.dart';

import 'package:sufra_app/features/products/presentation/cubit/products/products_cubit.dart';
import 'package:sufra_app/features/products/presentation/views/allProductsView.dart';

import 'package:sufra_app/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:sufra_app/features/home/presentation/widgets/home_search_field.dart';

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

  void _openAllProducts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AllProductsView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const HomeHeader(),

              const SizedBox(height: 14),

              const HomeSearchField(),

              const SizedBox(height: 14),

              const HomePromoBanner(),

              const SizedBox(height: 18),

              HomeSectionHeader(
                title: 'الأقسام',
                onViewAll: () => _openAllProducts(context),
              ),

              const SizedBox(height: 10),

              const HomeCategoriesSection(),

              const SizedBox(height: 22),

              HomeSectionHeader(
                title: 'الأكثر طلبًا',
                onViewAll: () => _openAllProducts(context),
              ),

              const SizedBox(height: 10),

              const SizedBox(height: 245, child: PopularProductsSection()),

              const SizedBox(height: 22),

              HomeSectionHeader(
                title: 'مختاراتنا لك',
                onViewAll: () => _openAllProducts(context),
              ),

              const SizedBox(height: 10),

              const FeaturedProductsSection(),

              const SizedBox(height: 22),

              HomeSectionHeader(
                title: 'وصل حديثًا',
                onViewAll: () => _openAllProducts(context),
              ),

              const SizedBox(height: 10),

              const LatestProductsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
