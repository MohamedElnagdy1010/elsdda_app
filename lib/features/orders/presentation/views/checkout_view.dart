import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sufra_app/core/dependency_injection/dependency_injection.dart';
import 'package:sufra_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:sufra_app/features/cart/presentation/cubit/cart/cart_cubit.dart';
import 'package:sufra_app/features/orders/domain/entities/order_entity.dart';
import 'package:sufra_app/features/orders/domain/entities/order_item_entity.dart';
import 'package:sufra_app/features/orders/presentation/cubit/orders/orders_cubit.dart';
import 'package:sufra_app/features/orders/presentation/cubit/orders/orders_state.dart';
import 'package:sufra_app/features/orders/presentation/views/order_success_view.dart';
import 'package:sufra_app/features/payment/presentation/views/paymentDetailsView.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final addressController = TextEditingController();

  String paymentMethod = 'cash';

  static const Color primaryColor = Color(0xffB60F1A);
  static const double deliveryFee = 10;

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrdersCubit>(),
      child: BlocConsumer<OrdersCubit, OrdersState>(
        listener: (context, state) {
          if (state is OrderCreatedSuccess) {
            context.read<CartCubit>().clearCart();

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => OrderSuccessView(order: state.order),
              ),
            );
          }

          if (state is OrdersFailure) {
            _showMessage(state.message);
          }
        },
        builder: (context, ordersState) {
          final cartState = context.watch<CartCubit>().state;

          final isLoading = ordersState is OrdersLoading;

          final effectiveDeliveryFee = cartState.isEmpty ? 0.0 : deliveryFee;

          final total = cartState.subtotal + effectiveDeliveryFee;

          return PopScope(
            canPop: !isLoading,
            child: Scaffold(
              backgroundColor: const Color(0xffF8F8F8),
              appBar: AppBar(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                title: const Text(
                  'إتمام الطلب',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                leading: IconButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black,
                    size: 19,
                  ),
                ),
              ),
              body: SafeArea(
                child: cartState.isEmpty
                    ? _EmptyCheckout(onBack: () => Navigator.pop(context))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const _SectionTitle(
                              title: 'عنوان التوصيل',
                              icon: Icons.location_on_outlined,
                            ),

                            const SizedBox(height: 12),

                            TextField(
                              controller: addressController,
                              enabled: !isLoading,
                              keyboardType: TextInputType.streetAddress,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              maxLines: 2,
                              maxLength: 300,
                              decoration: InputDecoration(
                                hintText: 'اكتب عنوان التوصيل بالتفصيل',
                                counterText: '',
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: const Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xffEEEEEE),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 26),

                            const _SectionTitle(
                              title: 'طريقة الدفع',
                              icon: Icons.payments_outlined,
                            ),

                            const SizedBox(height: 12),

                            IgnorePointer(
                              ignoring: isLoading,
                              child: Column(
                                children: [
                                  _paymentOption(
                                    title: 'الدفع عند الاستلام',
                                    subtitle: 'ادفع قيمة الطلب عند استلامه',
                                    value: 'cash',
                                    icon: Icons.payments_outlined,
                                  ),
                                  const SizedBox(height: 10),
                                  _paymentOption(
                                    title: 'الدفع الإلكتروني',
                                    subtitle:
                                        'مدى، Visa / Mastercard و Apple Pay',
                                    value: 'online',
                                    icon: Icons.credit_card_rounded,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 26),

                            const _SectionTitle(
                              title: 'ملخص الطلب',
                              icon: Icons.receipt_long_outlined,
                            ),

                            const SizedBox(height: 14),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xffEEEEEE),
                                ),
                              ),
                              child: Column(
                                children: [
                                  _summaryRow(
                                    'عدد المنتجات',
                                    '${cartState.totalQuantity}',
                                  ),
                                  const SizedBox(height: 10),
                                  _summaryRow(
                                    'المجموع الفرعي',
                                    '${cartState.subtotal.toStringAsFixed(2)} ر.س',
                                  ),
                                  const SizedBox(height: 10),
                                  _summaryRow(
                                    'رسوم التوصيل',
                                    '${effectiveDeliveryFee.toStringAsFixed(2)} ر.س',
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 13),
                                    child: Divider(height: 1),
                                  ),
                                  _summaryRow(
                                    'الإجمالي',
                                    '${total.toStringAsFixed(2)} ر.س',
                                    isTotal: true,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 28),

                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        FocusScope.of(context).unfocus();

                                        _createOrder(context);
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: primaryColor
                                      .withValues(alpha: 0.6),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: isLoading
                                    ? const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'جارٍ إنشاء الطلب...',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        paymentMethod == 'online'
                                            ? 'متابعة إلى الدفع'
                                            : 'تأكيد الطلب',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _paymentOption({
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
  }) {
    final isSelected = paymentMethod == value;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          setState(() {
            paymentMethod = value;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? primaryColor : const Color(0xffEEEEEE),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 21,
                height: 21,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? primaryColor : Colors.grey.shade400,
                    width: isSelected ? 6 : 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                icon,
                size: 21,
                color: isSelected ? primaryColor : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String title, String value, {bool isTotal = false}) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 15 : 13,
            color: isTotal ? Colors.black : Colors.grey,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 17 : 13,
            fontWeight: FontWeight.w700,
            color: isTotal ? primaryColor : Colors.black87,
          ),
        ),
      ],
    );
  }

  Future<void> _createOrder(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    final cartState = context.read<CartCubit>().state;
    final address = addressController.text.trim();

    if (user == null) {
      _showMessage('يجب تسجيل الدخول أولًا.');
      return;
    }

    if (cartState.isEmpty) {
      _showMessage('السلة فارغة.');
      return;
    }

    if (address.isEmpty) {
      _showMessage('من فضلك أدخل عنوان التوصيل.');
      return;
    }

    if (address.length < 5) {
      _showMessage('من فضلك أدخل عنوان توصيل أكثر وضوحًا.');
      return;
    }

    if (address.length > 300) {
      _showMessage('عنوان التوصيل طويل جدًا.');
      return;
    }

    if (paymentMethod == 'online') {
      final total = cartState.subtotal + deliveryFee;

      if (!mounted) return;

      final paymentSucceeded = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => PaymentDetailsView(amount: total)),
      );

      if (paymentSucceeded == true && mounted) {
        _showMessage(
          'تم الدفع التجريبي بنجاح. سنربط إنشاء الطلب وتأكيد الدفع من الخادم في الخطوة التالية.',
        );
      }

      return;
    }

    final items = cartState.items.map(_cartItemToOrderItem).toList();

    final order = OrderEntity(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: user.uid,
      items: items,
      subtotal: cartState.subtotal,
      deliveryFee: deliveryFee,
      total: cartState.subtotal + deliveryFee,
      address: address,
      paymentMethod: 'cash',
      paymentStatus: 'unpaid',
      status: 'pending',
      createdAt: DateTime.now(),
    );

    await context.read<OrdersCubit>().createOrder(order);
  }

  OrderItemEntity _cartItemToOrderItem(CartItemEntity item) {
    return OrderItemEntity(
      productId: item.product.id,
      name: item.product.name,
      image: item.product.image,
      price: item.unitPrice,
      quantity: item.quantity,
      selectedOption: item.selectedOption?.name,
      optionAdditionalPrice: item.selectedOption?.additionalPrice ?? 0,
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message, textAlign: TextAlign.right)),
      );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const SizedBox(width: 8),
        Icon(icon, size: 20, color: _CheckoutViewState.primaryColor),
      ],
    );
  }
}

class _EmptyCheckout extends StatelessWidget {
  final VoidCallback onBack;

  const _EmptyCheckout({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              size: 70,
              color: Colors.grey,
            ),
            const SizedBox(height: 18),
            const Text(
              'السلة فارغة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'أضف منتجات إلى السلة قبل إتمام الطلب.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onBack,
              style: ElevatedButton.styleFrom(
                backgroundColor: _CheckoutViewState.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('العودة إلى السلة'),
            ),
          ],
        ),
      ),
    );
  }
}
