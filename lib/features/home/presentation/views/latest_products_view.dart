import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sufra_app/core/styles/appColors.dart';
import 'package:sufra_app/features/home/presentation/widgets/home_product_card.dart';
import 'package:sufra_app/features/home/presentation/widgets/latest_products_policy.dart';
import 'package:sufra_app/features/products/presentation/cubit/products/products_cubit.dart';
import 'package:sufra_app/features/products/presentation/cubit/products/products_state.dart';

class LatestProductsView extends StatelessWidget {
  const LatestProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        appBar: AppBar(
          backgroundColor: AppColors.canvas,
          surfaceTintColor: AppColors.canvas,
          title: Text(
            'وصل حديثًا',
            style: GoogleFonts.cairo(fontWeight: FontWeight.w800),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<ProductsCubit, ProductsState>(
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
            final products = LatestProductsPolicy.select(
              state.latestProducts,
              DateTime.now(),
            );
            if (products.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد أصناف متاحة حاليًا',
                  style: GoogleFonts.cairo(),
                ),
              );
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (constraints.maxWidth - 44) / 2;
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: cardWidth < 160 ? 268 : 282,
                  ),
                  itemBuilder: (context, index) =>
                      HomeProductCard(product: products[index]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
