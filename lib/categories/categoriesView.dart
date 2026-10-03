// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sufra_app/core/dependency_injection/dependency_injection.dart';
import 'package:sufra_app/features/products/presentation/cubit/products/products_cubit.dart';
import 'package:sufra_app/features/products/presentation/cubit/products/products_state.dart';
import 'package:sufra_app/features/products/presentation/views/productsView.dart';
import 'package:sufra_app/core/widgets/app_network_image.dart';
import 'package:sufra_app/core/utils/local_image_mapper.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductsCubit>()..loadHomeData(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'قائمة الطعام',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(right: 10, left: 0, bottom: 20),
            child: Column(
              children: [
                // Search
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'البحث في قائمة الطعام',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                      suffixIcon: Icon(Icons.search, color: Colors.grey[500]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Expanded(
                  child: BlocBuilder<ProductsCubit, ProductsState>(
                    builder: (context, state) {
                      if (state is ProductsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is ProductsFailure) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(state.message, textAlign: TextAlign.center),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<ProductsCubit>().loadHomeData();
                                },
                                child: const Text('إعادة المحاولة'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is ProductsLoaded) {
                        final categories = state.categories;

                        if (categories.isEmpty) {
                          return const Center(
                            child: Text(
                              'لا توجد أقسام حالياً',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final sidebarWidth = constraints.maxWidth * 0.26;

                            return Stack(
                              children: [
                                // Red sidebar
                                Positioned(
                                  top: 5,
                                  bottom: 5,
                                  left: 0,
                                  child: Container(
                                    width: sidebarWidth,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffB60F1A),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(38),
                                        bottomRight: Radius.circular(38),
                                      ),
                                    ),
                                  ),
                                ),

                                // Categories
                                ListView.separated(
                                  padding: const EdgeInsets.only(
                                    top: 25,
                                    bottom: 25,
                                  ),
                                  itemCount: categories.length,
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 24);
                                  },
                                  itemBuilder: (context, index) {
                                    final category = categories[index];

                                    return _categoryItem(
                                      context: context,
                                      categoryId: category.id,
                                      title: category.name,
                                      image: category.image,
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryItem({
    required BuildContext context,
    required String categoryId,
    required String title,
    required String image,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductsView(categoryId: categoryId, categoryTitle: title),
          ),
        );
      },
      child: SizedBox(
        height: 87,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // White card
            Positioned(
              right: 15,
              left: 40,
              top: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .19),
                      blurRadius: 6,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
              ),
            ),

            // Category image
            Positioned(
              right: 25,
              top: 8,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .18),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: AppNetworkImage(
                    imageUrl: image,
                    fallbackAsset: LocalImageMapper.category(categoryId),
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Category name
            Positioned(
              right: 110,
              top: 25,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 218, 15, 15),
                ),
              ),
            ),

            // Arrow
            Positioned(
              left: 25,
              top: 27,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .10),
                      blurRadius: 5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: Color(0xffD99A32),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
