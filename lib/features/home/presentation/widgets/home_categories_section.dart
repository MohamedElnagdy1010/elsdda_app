import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sufra_app/core/styles/appColors.dart';
import 'package:sufra_app/core/utils/local_image_mapper.dart';
import 'package:sufra_app/core/widgets/app_network_image.dart';
import 'package:sufra_app/features/products/presentation/cubit/products/products_cubit.dart';
import 'package:sufra_app/features/products/presentation/cubit/products/products_state.dart';
import 'package:sufra_app/features/products/presentation/views/allProductsView.dart';

class HomeCategoriesSection extends StatelessWidget {
  const HomeCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoading) {
          return const SizedBox(
            height: 110,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }
        if (state is ProductsFailure) {
          return Text(state.message, textAlign: TextAlign.center);
        }
        if (state is! ProductsLoaded) {
          return const SizedBox.shrink();
        }
        final categories = state.categories.take(4).toList();
        if (categories.isEmpty) {
          return const Text('لا توجد أقسام حاليًا');
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(categories.length, (index) {
            final category = categories[index];
            return Expanded(
              child: TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 350 + index * 90),
                tween: Tween(begin: 0.85, end: 1),
                curve: Curves.easeOutCubic,
                builder: (context, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AllProductsView(
                        categoryId: category.id,
                        categoryName: category.name,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: AppNetworkImage(
                          imageUrl: category.image,
                          fallbackAsset: LocalImageMapper.category(category.id),
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Text(
                          category.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
