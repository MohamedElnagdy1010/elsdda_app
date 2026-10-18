import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sufra_app/core/dependency_injection/dependency_injection.dart';
import 'package:sufra_app/core/widgets/app_network_image.dart';
import 'package:sufra_app/core/utils/local_image_mapper.dart';
import 'package:sufra_app/features/products/presentation/cubit/products/products_cubit.dart';
import 'package:sufra_app/features/products/presentation/cubit/products/products_state.dart';
import 'package:sufra_app/features/products/presentation/views/productsView.dart';
class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductsCubit>()..loadHomeData(),
      child: const _CategoriesContent(),
    );
  }
}
class _CategoriesContent extends StatefulWidget {
  const _CategoriesContent();
  @override
  State<_CategoriesContent> createState() => _CategoriesContentState();
}
class _CategoriesContentState extends State<_CategoriesContent> {
  static const Color primaryColor = Color(0xFFB60F1A);
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const int gridThreshold = 8;
  String searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 64,
          title: const Text(
            'قائمة الطعام',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF171717),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: BlocBuilder<ProductsCubit, ProductsState>(
                  builder: (context, state) {
                    if (state is ProductsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      );
                    }
                    if (state is ProductsFailure) {
                      return _buildErrorState(context, state.message);
                    }
                    if (state is ProductsLoaded) {
                      final categories = state.categories.where((category) {
                        return category.name.toLowerCase().contains(
                          searchQuery.trim().toLowerCase(),
                        );
                      }).toList();
                      if (categories.isEmpty) {
                        return _buildEmptyState();
                      }
                      if (categories.length > gridThreshold) {
                        return _buildCategoriesGrid(
                          itemCount: categories.length,
                          itemBuilder: (index) {
                            final category = categories[index];
                            return _buildGridCategoryCard(
                              context: context,
                              categoryId: category.id,
                              title: category.name,
                              image: category.image,
                            );
                          },
                        );
                      }
                      return _buildCategoriesList(
                        itemCount: categories.length,
                        itemBuilder: (index) {
                          final category = categories[index];
                          return _buildListCategoryCard(
                            context: context,
                            categoryId: category.id,
                            title: category.name,
                            image: category.image,
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
    );
  }
  Widget _buildCategoriesList({
    required int itemCount,
    required Widget Function(int index) itemBuilder,
  }) {
    return ListView.separated(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => itemBuilder(index),
    );
  }
  Widget _buildCategoriesGrid({
    required int itemCount,
    required Widget Function(int index) itemBuilder,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 44) / 2;
        return GridView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 12,
            mainAxisExtent: cardWidth * 0.69,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) => itemBuilder(index),
        );
      },
    );
  }
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2F4),
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: const InputDecoration(
          hintText: 'البحث في قائمة الطعام...',
          hintStyle: TextStyle(
            fontSize: 15,
            color: Color(0xFF93969F),
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Color(0xFF858892),
            size: 26,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
Widget _buildListCategoryCard({
  required BuildContext context,
  required String categoryId,
  required String title,
  required String image,
}) {
  return SizedBox(
    height: 175,
    width: double.infinity,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductsView(
                categoryId: categoryId,
                categoryTitle: title,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Category image
                AppNetworkImage(
                  imageUrl: image,
                  fallbackAsset:
                      LocalImageMapper.category(categoryId),
                  fit: BoxFit.cover,
                ),
                // Dark gradient
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color(0x44000000),
                        Color(0xD9000000),
                      ],
                      stops: [0.20, 0.55, 1.0],
                    ),
                  ),
                ),
                // Title and arrow
                Positioned(
                  bottom: 16,
                  right: 18,
                  left: 18,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                            shadows: [
                              Shadow(
                                color: Color(0x66000000),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB60F1A),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 23,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
  Widget _buildGridCategoryCard({
    required BuildContext context,
    required String categoryId,
    required String title,
    required String image,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ProductsView(categoryId: categoryId, categoryTitle: title),
            ),
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              fit: StackFit.expand,
              children: [
                AppNetworkImage(
                  imageUrl: image,
                  fallbackAsset: LocalImageMapper.category(categoryId),
                  fit: BoxFit.cover,
                ),
                // Dark gradient for readable text
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color(0x33000000),
                        Color(0xD9000000),
                      ],
                      stops: [0.25, 0.55, 1],
                    ),
                  ),
                ),
                // Category name and arrow
                Positioned(
                  bottom: 14,
                  right: 12,
                  left: 12,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            height: 1.2,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            shadows: [
                              Shadow(color: Color(0x66000000), blurRadius: 5),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 31,
                        height: 31,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.23),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.restaurant_menu_rounded,
              size: 64,
              color: Color(0xFFB9B9B9),
            ),
            SizedBox(height: 16),
            Text(
              'لا توجد أقسام مطابقة',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'جرّب البحث باسم قسم آخر',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: primaryColor,
              size: 56,
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Color(0xFF444444)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                context.read<ProductsCubit>().loadHomeData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                'إعادة المحاولة',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
