import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sufra_app/core/styles/appColors.dart';
import 'package:sufra_app/features/home/presentation/widgets/home_product_card.dart';
import 'package:sufra_app/features/products/presentation/cubit/products/products_cubit.dart';
import 'package:sufra_app/features/products/presentation/cubit/products/products_state.dart';

class FeaturedProductsSection extends StatelessWidget {
  const FeaturedProductsSection({super.key});
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
          return Center(child: Text(state.message));
        }
        if (state is! ProductsLoaded) {
          return const SizedBox.shrink();
        }
        if (state.featuredProducts.isEmpty) {
          return const Text('لا توجد مختارات حاليًا');
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.featuredProducts.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) => HomeProductCard(
            product: state.featuredProducts[index],
            compact: true,
          ),
        );
      },
    );
  }
}
