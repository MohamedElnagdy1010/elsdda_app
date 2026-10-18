import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sufra_app/core/styles/appColors.dart';
import 'package:sufra_app/features/home/presentation/widgets/home_product_card.dart';
import 'package:sufra_app/features/home/presentation/widgets/latest_products_policy.dart';
import 'package:sufra_app/features/products/presentation/cubit/products/products_cubit.dart';
import 'package:sufra_app/features/products/presentation/cubit/products/products_state.dart';

class LatestProductsSection extends StatelessWidget {
  const LatestProductsSection({super.key});

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

        final eligible = LatestProductsPolicy.select(
          state.latestProducts,
          DateTime.now(),
        );
        final visible = eligible
            .take(LatestProductsPolicy.homeMaximum)
            .toList();
        if (visible.isEmpty) {
          return const Text('Ù„Ø§ ØªÙˆØ¬Ø¯ Ø£ØµÙ†Ø§Ù Ø­Ø¯ÙŠØ«Ø© Ø­Ø§Ù„ÙŠÙ‹Ø§');
        }

        // Keep the original vertical list and compact product card design.
        // The existing 'View all' header continues to open the products page.
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visible.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) =>
              HomeProductCard(product: visible[index], compact: true),
        );
      },
    );
  }
}
