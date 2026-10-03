import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sufra_app/core/utils/local_image_mapper.dart';
import 'package:sufra_app/core/widgets/app_network_image.dart';
import 'package:sufra_app/features/products/domain/entities/product_entity.dart';
import 'package:sufra_app/features/products/presentation/cubit/products/products_cubit.dart';
import 'package:sufra_app/features/products/presentation/cubit/products/products_state.dart';
import 'package:sufra_app/features/products/presentation/views/productDetailsView.dart';

class LatestProductsSection extends StatelessWidget {
  const LatestProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xffB60F1A),
              ),
            ),
          );
        }

        if (state is ProductsFailure) {
          return Center(
            child: Text(
              state.message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          );
        }

        if (state is ProductsLoaded) {
          final products = state.latestProducts;

          if (products.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'لا توجد أصناف حديثة حاليًا',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return _LatestProductItem(product: products[index]);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _LatestProductItem extends StatelessWidget {
  final ProductEntity product;

  const _LatestProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsView(product: product),
            ),
          );
        },
        child: Container(
          height: 92,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xffEEEEEE)),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              AppNetworkImage(
                imageUrl: product.image,
                fallbackAsset: LocalImageMapper.product(product.id),
                width: 76,
                height: 76,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(13),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff202020),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          product.rating.toString(),
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
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
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${product.price.toStringAsFixed(0)} ريال',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xffB60F1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 27,
                    height: 27,
                    decoration: const BoxDecoration(
                      color: Color(0xffF8EEEE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      size: 15,
                      color: Color(0xffB60F1A),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
