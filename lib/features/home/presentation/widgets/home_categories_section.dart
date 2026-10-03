import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            height: 96,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xffB60F1A),
              ),
            ),
          );
        }

        if (state is ProductsFailure) {
          return SizedBox(
            height: 96,
            child: Center(
              child: Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          );
        }

        if (state is ProductsLoaded) {
          final categories = state.categories.take(4).toList();

          if (categories.isEmpty) {
            return const SizedBox(
              height: 96,
              child: Center(
                child: Text(
                  'لا توجد أقسام حاليًا',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            );
          }

          return Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(categories.length, (index) {
              final category = categories[index];

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AllProductsView(
                            categoryId: category.id,
                            categoryName: category.name,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xffF5F5F5),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xffEEEEEE)),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: AppNetworkImage(
                            imageUrl: category.image,
                            fallbackAsset: LocalImageMapper.category(
                              category.id,
                            ),
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          category.name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }

        return const SizedBox(height: 96);
      },
    );
  }
}
