import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sufra_app/core/utils/local_image_mapper.dart';
import 'package:sufra_app/core/widgets/app_network_image.dart';
import 'package:sufra_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:sufra_app/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:sufra_app/features/products/domain/entities/product_entity.dart';
import 'package:sufra_app/features/products/presentation/views/productDetailsView.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  static const _primaryColor = Color(0xffB60F1A);

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      context.read<FavoritesCubit>().loadFavorites(user.uid);
    }
  }

  Future<void> _refreshFavorites() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await context.read<FavoritesCubit>().loadFavorites(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xffFAFAFA),
        surfaceTintColor: const Color(0xffFAFAFA),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'المفضلة',
          style: TextStyle(
            color: Color(0xff202020),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xff202020),
            size: 20,
          ),
        ),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: _primaryColor,
              ),
            );
          }

          if (state is FavoritesFailure) {
            return _FavoritesError(
              message: state.message,
              onRetry: _refreshFavorites,
            );
          }

          if (state is FavoritesLoaded) {
            if (state.products.isEmpty) {
              return const _EmptyFavorites();
            }

            return RefreshIndicator(
              color: _primaryColor,
              onRefresh: _refreshFavorites,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
                itemCount: state.products.length,
                separatorBuilder: (_, _) => const SizedBox(height: 11),
                itemBuilder: (context, index) {
                  return _FavoriteProductCard(product: state.products[index]);
                },
              ),
            );
          }

          return const _EmptyFavorites();
        },
      ),
    );
  }
}

class _FavoriteProductCard extends StatelessWidget {
  static const _primaryColor = Color(0xffB60F1A);

  final ProductEntity product;

  const _FavoriteProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsView(product: product),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xffEEEEEE)),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              AppNetworkImage(
                imageUrl: product.image,
                fallbackAsset: LocalImageMapper.product(product.id),
                width: 94,
                height: 94,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(14),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      product.name,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xff202020),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      product.description,
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xff888888),
                        fontSize: 11.5,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          '${product.price.toStringAsFixed(0)} ر.س',
                          style: const TextStyle(
                            color: _primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        if (product.rating > 0) ...[
                          const Icon(
                            Icons.star_rounded,
                            size: 15,
                            color: Color(0xffF4B400),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Color(0xff666666),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              _RemoveFavoriteButton(product: product),
            ],
          ),
        ),
      ),
    );
  }
}

class _RemoveFavoriteButton extends StatelessWidget {
  final ProductEntity product;

  const _RemoveFavoriteButton({required this.product});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xffFCEEEF),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () async {
          final user = FirebaseAuth.instance.currentUser;

          if (user == null) return;

          try {
            await context.read<FavoritesCubit>().toggleFavorite(
              userId: user.uid,
              product: product,
            );
          } catch (_) {
            if (!context.mounted) return;

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text(
                    'تعذر تحديث المفضلة، حاول مرة أخرى',
                    textAlign: TextAlign.right,
                  ),
                ),
              );
          }
        },
        child: const Padding(
          padding: EdgeInsets.all(9),
          child: Icon(
            Icons.favorite_rounded,
            color: Color(0xffB60F1A),
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EmptyFavoritesIcon(),
            SizedBox(height: 18),
            Text(
              'المفضلة فارغة',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff202020),
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 7),
            Text(
              'احفظ الوجبات التي تعجبك لتجدها هنا بسهولة',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff888888),
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFavoritesIcon extends StatelessWidget {
  const _EmptyFavoritesIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82,
      height: 82,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xffFCEEEF),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.favorite_border_rounded,
          size: 38,
          color: Color(0xffB60F1A),
        ),
      ),
    );
  }
}

class _FavoritesError extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _FavoritesError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                color: Color(0xffFCEEEF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 34,
                color: Color(0xffB60F1A),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'تعذر تحميل المفضلة',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff202020),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xff888888),
                fontSize: 12,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 44,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xffB60F1A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
