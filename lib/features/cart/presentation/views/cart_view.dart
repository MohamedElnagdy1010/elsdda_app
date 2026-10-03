import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sufra_app/features/orders/presentation/views/checkout_view.dart';
import '../cubit/cart/cart_cubit.dart';
import '../cubit/cart/cart_state.dart';
import '../widgets/cart_item_card.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  static const Color primaryColor = Color(0xffB60F1A);
  static const double deliveryFee = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'السلة',
          style: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: 19,
          ),
        ),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.isEmpty) {
            return const _EmptyCart();
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    return CartItemCard(item: state.items[index]);
                  },
                ),
              ),
              _OrderSummary(state: state),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xffF1F1F1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 48,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'السلة فارغة',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 7),
            const Text(
              'أضف بعض المنتجات إلى السلة لإكمال طلبك.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, height: 1.5, color: Colors.grey),
            ),
            const SizedBox(height: 22),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.restaurant_menu_rounded, size: 19),
              label: const Text('تصفح المنتجات'),
              style: OutlinedButton.styleFrom(
                foregroundColor: CartView.primaryColor,
                side: const BorderSide(color: CartView.primaryColor),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final CartState state;

  const _OrderSummary({required this.state});

  @override
  Widget build(BuildContext context) {
    final total = state.subtotal + CartView.deliveryFee;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xffEEEEEE))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _SummaryRow(title: 'عدد المنتجات', value: '${state.totalQuantity}'),
            const SizedBox(height: 9),
            _SummaryRow(
              title: 'المجموع الفرعي',
              value: '${state.subtotal.toStringAsFixed(2)} ر.س',
            ),
            const SizedBox(height: 9),
            const _SummaryRow(title: 'رسوم التوصيل', value: '10.00 ر.س'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            _SummaryRow(
              title: 'الإجمالي',
              value: '${total.toStringAsFixed(2)} ر.س',
              isTotal: true,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: state.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CheckoutView(),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CartView.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'متابعة إلى الدفع',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.title,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? Colors.black : Colors.grey,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 17 : 13,
            fontWeight: FontWeight.w700,
            color: isTotal ? CartView.primaryColor : Colors.black87,
          ),
        ),
      ],
    );
  }
}
