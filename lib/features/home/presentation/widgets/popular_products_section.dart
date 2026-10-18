import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sufra_app/core/styles/appColors.dart';
import 'package:sufra_app/features/home/presentation/widgets/home_product_card.dart';
import 'package:sufra_app/features/products/presentation/cubit/products/products_cubit.dart';
import 'package:sufra_app/features/products/presentation/cubit/products/products_state.dart';

class PopularProductsSection extends StatelessWidget {
  const PopularProductsSection({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (state is ProductsFailure) {
          return Center(
            child: TextButton(
              onPressed: () => context.read<ProductsCubit>().loadHomeData(),
              child: Text('${state.message} — إعادة المحاولة'),
            ),
          );
        }
        if (state is! ProductsLoaded) {
          return const SizedBox.shrink();
        }
        if (state.popularProducts.isEmpty) {
          return const Center(child: Text('لا توجد منتجات شائعة حاليًا'));
        }
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: state.popularProducts.length,
          separatorBuilder: (_, _) => const SizedBox(width: 11),
          itemBuilder: (context, index) => TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.92, end: 1),
            duration: Duration(
              milliseconds: 300 + (index < 5 ? index : 5) * 75,
            ),
            curve: Curves.easeOutCubic,
            builder: (context, scale, child) =>
                Transform.scale(scale: scale, child: child),
            child: HomeProductCard(product: state.popularProducts[index]),
          ),
        );
      },
    );
  }
}
