import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sufra_app/features/cart/presentation/cubit/cart/cart_cubit.dart';
import 'package:sufra_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:sufra_app/features/favorites/presentation/cubit/favorites_state.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/entities/product_option_entity.dart';
import 'package:sufra_app/core/widgets/app_network_image.dart';
import 'package:sufra_app/core/utils/local_image_mapper.dart';

class ProductDetailsView extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailsView({super.key, required this.product});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int quantity = 1;

  ProductOptionEntity? selectedOption;

  @override
  void initState() {
    super.initState();

    if (widget.product.options.isNotEmpty) {
      selectedOption = widget.product.options.first;
    }
  }

  double get unitPrice {
    return widget.product.price + (selectedOption?.additionalPrice ?? 0);
  }

  double get totalPrice {
    return unitPrice * quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildImageHeader(context),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildTitleAndPrice(),

                          const SizedBox(height: 12),

                          _buildRating(),

                          const SizedBox(height: 25),

                          const Text(
                            'الوصف',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            widget.product.description,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.7,
                              color: Colors.grey[600],
                            ),
                          ),

                          if (widget.product.options.isNotEmpty) ...[
                            const SizedBox(height: 30),
                            _buildOptionsSection(),
                          ],

                          const SizedBox(height: 30),

                          _buildQuantitySection(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            _buildAddToCartSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageHeader(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 340,
          child: AppNetworkImage(
            imageUrl: widget.product.image,
            fallbackAsset: LocalImageMapper.product(widget.product.id),
            width: double.infinity,
            height: 340,
            fit: BoxFit.cover,
          ),
        ),

        // Gradient خفيف لظهور الأزرار بوضوح
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // Back
        Positioned(
          top: 18,
          left: 18,
          child: _glassButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onPressed: () => Navigator.pop(context),
          ),
        ),

        // Favorite
        Positioned(
          top: 18,
          right: 18,
          child: BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              final favoritesCubit = context.read<FavoritesCubit>();
              final isFavorite = favoritesCubit.isFavorite(widget.product.id);

              return _glassButton(
                icon: isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                iconColor: isFavorite ? const Color(0xffB60F1A) : Colors.white,
                onPressed: () async {
                  await _toggleFavorite(context, favoritesCubit);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTitleAndPrice() {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.product.name,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(width: 15),

        Text(
          '${widget.product.price.toStringAsFixed(0)} ر.س',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xffB60F1A),
          ),
        ),
      ],
    );
  }

  Widget _buildRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '(${widget.product.reviews} تقييم)',
          style: TextStyle(color: Colors.grey[500], fontSize: 13),
        ),

        const SizedBox(width: 7),

        Text(
          widget.product.rating.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xffB60F1A),
          ),
        ),

        const SizedBox(width: 4),

        const Icon(Icons.star, color: Colors.orange, size: 20),
      ],
    );
  }

  Widget _buildOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'تخصيص الطلب',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xff202020),
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'اختر الخيار المناسب لك',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xff999999),
          ),
        ),

        const SizedBox(height: 14),

        ...widget.product.options.map((option) {
          final isSelected = selectedOption == option;
          final extra = option.additionalPrice;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedOption = option;
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xffFFF5F5) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xffB60F1A)
                          : const Color(0xffE8E8E8),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      // Radio
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 22,
                        height: 22,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xffB60F1A)
                                : const Color(0xffBDBDBD),
                            width: 2,
                          ),
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? const Color(0xffB60F1A)
                                : Colors.transparent,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          option.name,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: isSelected
                                ? FontWeight.w800
                                : FontWeight.w600,
                            color: const Color(0xff202020),
                          ),
                        ),
                      ),

                      if (extra > 0) ...[
                        const SizedBox(width: 10),

                        Text(
                          '+${extra.toStringAsFixed(0)} ر.س',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: isSelected
                                ? const Color(0xffB60F1A)
                                : const Color(0xff777777),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        }),

        if ((selectedOption?.additionalPrice ?? 0) > 0) ...[
          const SizedBox(height: 2),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'السعر بعد الاختيار: ${unitPrice.toStringAsFixed(0)} ر.س',
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                color: Color(0xffB60F1A),
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuantitySection() {
    final canDecrease = quantity > 1;
    final canIncrease = quantity < 20;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'الكمية',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xff202020),
          ),
        ),

        const SizedBox(height: 15),

        Row(
          textDirection: TextDirection.rtl,
          children: [
            // Quantity controls
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xffF7F7F7),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xffEEEEEE)),
              ),
              child: Row(
                children: [
                  _quantityButton(
                    icon: Icons.add_rounded,
                    enabled: canIncrease,
                    onTap: () {
                      if (!canIncrease) return;

                      setState(() {
                        quantity++;
                      });
                    },
                  ),

                  SizedBox(
                    width: 48,
                    child: Text(
                      quantity.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff202020),
                      ),
                    ),
                  ),

                  _quantityButton(
                    icon: Icons.remove_rounded,
                    enabled: canDecrease,
                    onTap: () {
                      if (!canDecrease) return;

                      setState(() {
                        quantity--;
                      });
                    },
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Total
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الإجمالي',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff999999),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '${totalPrice.toStringAsFixed(0)} ر.س',
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: Color(0xffB60F1A),
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddToCartSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 58,
          child: ElevatedButton(
            onPressed: () {
              _addToCart(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffB60F1A),
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                const Icon(Icons.shopping_bag_outlined, size: 23),

                const SizedBox(width: 9),

                const Text(
                  'أضف للسلة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),

                const Spacer(),

                Container(
                  width: 1,
                  height: 23,
                  color: Colors.white.withValues(alpha: 0.28),
                ),

                const SizedBox(width: 14),

                Text(
                  '${totalPrice.toStringAsFixed(0)} ر.س',
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addToCart(BuildContext context) {
    context.read<CartCubit>().addProduct(
      widget.product,
      quantity: quantity,
      selectedOption: selectedOption,
    );

    final optionText = selectedOption != null
        ? ' - ${selectedOption!.name}'
        : '';

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'تمت إضافة $quantity من ${widget.product.name}$optionText إلى السلة',
            textAlign: TextAlign.right,
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _toggleFavorite(
    BuildContext context,
    FavoritesCubit favoritesCubit,
  ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'يجب تسجيل الدخول لإضافة المنتج إلى المفضلة',
              textAlign: TextAlign.right,
            ),
          ),
        );

      return;
    }

    try {
      await favoritesCubit.toggleFavorite(
        userId: user.uid,
        product: widget.product,
      );
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'حدث خطأ أثناء تحديث المفضلة',
              textAlign: TextAlign.right,
            ),
          ),
        );
    }
  }

  Widget _glassButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color iconColor = Colors.white,
  }) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.transparent, width: 1),
          ),
          child: Icon(icon, size: 25, color: iconColor),
        ),
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return Material(
      color: enabled ? const Color(0xffB60F1A) : const Color(0xffE5E5E5),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: enabled ? onTap : null,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(
            icon,
            size: 21,
            color: enabled ? Colors.white : const Color(0xffAAAAAA),
          ),
        ),
      ),
    );
  }
}
