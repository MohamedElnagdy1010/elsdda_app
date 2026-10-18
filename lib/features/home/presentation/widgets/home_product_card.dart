import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sufra_app/core/styles/appColors.dart';
import 'package:sufra_app/core/utils/local_image_mapper.dart';
import 'package:sufra_app/core/widgets/app_network_image.dart';
import 'package:sufra_app/features/products/domain/entities/product_entity.dart';
import 'package:sufra_app/features/products/presentation/views/productDetailsView.dart';

/// Reusable presentation-only card; the existing product details flow is preserved.
class HomeProductCard extends StatelessWidget {
  const HomeProductCard({
    super.key,
    required this.product,
    this.compact = false,
  });
  final ProductEntity product;
  final bool compact;

  void _open(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => ProductDetailsView(product: product)),
  );

  @override
  Widget build(BuildContext context) {
    return compact ? _compact(context) : _large(context);
  }

  Widget _large(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _open(context),
        child: Container(
          width: 185,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppNetworkImage(
                imageUrl: product.image,
                fallbackAsset: LocalImageMapper.product(product.id),
                width: double.infinity,
                height: 151,
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 15,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${product.rating} (${product.reviews})',
                            style: GoogleFonts.cairo(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${product.price.toStringAsFixed(0)} ريال',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.add_circle_rounded,
                            size: 28,
                            color: AppColors.primary,
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
  }

  Widget _compact(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _open(context),
        child: Container(
          height: 96,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              AppNetworkImage(
                imageUrl: product.image,
                fallbackAsset: LocalImageMapper.product(product.id),
                width: 78,
                height: 78,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(11),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.secondary,
                          size: 15,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${product.rating} (${product.reviews})',
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${product.price.toStringAsFixed(0)} ريال',
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.add_circle_rounded,
                color: AppColors.primary,
                size: 27,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
