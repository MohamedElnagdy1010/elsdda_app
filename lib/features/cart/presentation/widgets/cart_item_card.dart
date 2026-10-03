import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sufra_app/core/utils/local_image_mapper.dart';
import 'package:sufra_app/core/widgets/app_network_image.dart';

import '../../domain/entities/cart_item_entity.dart';
import '../cubit/cart/cart_cubit.dart';

class CartItemCard extends StatelessWidget {
  final CartItemEntity item;

  const CartItemCard({super.key, required this.item});

  static const Color primaryColor = Color(0xffB60F1A);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffEEEEEE)),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppNetworkImage(
            imageUrl: item.product.image,
            fallbackAsset: LocalImageMapper.product(item.product.id),
            width: 88,
            height: 88,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(14),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name,
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        context.read<CartCubit>().removeProduct(item.cartKey);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close_rounded,
                          size: 19,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),

                if (item.selectedOption != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'الاختيار: ${item.selectedOption!.name}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],

                const SizedBox(height: 6),

                Text(
                  '${item.unitPrice.toStringAsFixed(2)} ر.س',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    _QuantityButton(
                      icon: Icons.add_rounded,
                      onTap: () {
                        context.read<CartCubit>().increaseQuantity(
                          item.cartKey,
                        );
                      },
                    ),

                    SizedBox(
                      width: 38,
                      child: Text(
                        '${item.quantity}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    _QuantityButton(
                      icon: Icons.remove_rounded,
                      onTap: () {
                        context.read<CartCubit>().decreaseQuantity(
                          item.cartKey,
                        );
                      },
                    ),

                    const Spacer(),

                    Text(
                      'الإجمالي ${item.totalPrice.toStringAsFixed(2)} ر.س',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xffF5F5F5),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(icon, color: CartItemCard.primaryColor, size: 17),
        ),
      ),
    );
  }
}
