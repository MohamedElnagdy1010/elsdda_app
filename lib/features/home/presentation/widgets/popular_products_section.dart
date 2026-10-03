import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sufra_app/core/utils/local_image_mapper.dart';
import 'package:sufra_app/core/widgets/app_network_image.dart';

import 'package:sufra_app/features/products/presentation/cubit/products/products_cubit.dart';
import 'package:sufra_app/features/products/presentation/cubit/products/products_state.dart';
import 'package:sufra_app/features/products/presentation/views/productDetailsView.dart';

class PopularProductsSection extends StatelessWidget {
  const PopularProductsSection({super.key});

  static const Color _primaryColor = Color(0xffB60F1A);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoading) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _primaryColor,
            ),
          );
        }

        if (state is ProductsFailure) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 7),
                TextButton(
                  onPressed: () {
                    context.read<ProductsCubit>().loadHomeData();
                  },
                  child: const Text(
                    'إعادة المحاولة',
                    style: TextStyle(fontSize: 12, color: _primaryColor),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is ProductsLoaded) {
          final products = state.popularProducts;

          if (products.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد منتجات شائعة حاليًا',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            );
          }

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 3),
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(width: 11),
            itemBuilder: (context, index) {
              final product = products[index];

              void openProduct() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsView(product: product),
                  ),
                );
              }

              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  onTap: openProduct,
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xffEEEEEE)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.035),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(18),
                          ),
                          child: AppNetworkImage(
                            imageUrl: product.image,
                            fallbackAsset: LocalImageMapper.product(product.id),
                            width: double.infinity,
                            height: 145,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff202020),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/home/svgs/rate.svg',
                                      width: 13,
                                      height: 13,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      product.rating.toString(),
                                      style: const TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff777777),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '(${product.reviews})',
                                      style: const TextStyle(
                                        fontSize: 9.5,
                                        color: Color(0xff999999),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${product.price.toStringAsFixed(0)} ريال',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: _primaryColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: const BoxDecoration(
                                        color: _primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_back_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
