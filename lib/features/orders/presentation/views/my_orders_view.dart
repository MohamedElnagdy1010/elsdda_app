import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sufra_app/core/dependency_injection/dependency_injection.dart';
import 'package:sufra_app/features/orders/domain/entities/order_entity.dart';
import 'package:sufra_app/features/orders/presentation/cubit/orders/orders_cubit.dart';
import 'package:sufra_app/features/orders/presentation/cubit/orders/orders_state.dart';
import 'package:sufra_app/features/orders/presentation/views/order_details_view.dart';

class MyOrdersView extends StatelessWidget {
  const MyOrdersView({super.key});

  static const Color primaryColor = Color(0xffB60F1A);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return BlocProvider(
      create: (_) {
        final cubit = getIt<OrdersCubit>();

        if (user != null) {
          cubit.getUserOrders(user.uid);
        }

        return cubit;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF8F8F8),
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            'طلباتي',
            style: TextStyle(
              color: Colors.black,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: user == null
            ? const _MessageView(
                icon: Icons.person_off_outlined,
                title: 'سجل الدخول أولًا',
                message: 'يجب تسجيل الدخول لعرض طلباتك.',
              )
            : const _OrdersBody(),
      ),
    );
  }
}

class _OrdersBody extends StatelessWidget {
  const _OrdersBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading) {
          return const Center(
            child: CircularProgressIndicator(color: MyOrdersView.primaryColor),
          );
        }

        if (state is OrdersFailure) {
          return _MessageView(
            icon: Icons.error_outline_rounded,
            title: 'تعذر تحميل الطلبات',
            message: state.message,
            buttonText: 'إعادة المحاولة',
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                context.read<OrdersCubit>().getUserOrders(user.uid);
              }
            },
          );
        }

        if (state is OrdersLoaded) {
          if (state.orders.isEmpty) {
            return const _MessageView(
              icon: Icons.receipt_long_outlined,
              title: 'لا توجد طلبات',
              message: 'طلباتك الجديدة ستظهر هنا بعد إتمام أول طلب.',
            );
          }

          return RefreshIndicator(
            color: MyOrdersView.primaryColor,
            onRefresh: () async {
              final user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                await context.read<OrdersCubit>().getUserOrders(user.uid);
              }
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
              itemCount: state.orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _OrderCard(order: state.orders[index]);
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderEntity order;

  const _OrderCard({required this.order});

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
            MaterialPageRoute(builder: (_) => OrderDetailsView(order: order)),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xffEEEEEE)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'طلب #${_shortOrderId(order.id)}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDateTime(order.createdAt),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  _OrderStatusBadge(status: order.status),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Divider(height: 1),
              ),

              _InfoRow(title: 'عدد المنتجات', value: '${order.totalItems}'),

              const SizedBox(height: 10),

              _InfoRow(
                title: 'طريقة الدفع',
                value: _paymentMethodText(order.paymentMethod),
              ),

              const SizedBox(height: 10),

              Row(
                textDirection: TextDirection.rtl,
                children: [
                  const Text(
                    'حالة الدفع',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const Spacer(),
                  _PaymentStatusBadge(status: order.paymentStatus),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Divider(height: 1),
              ),

              Row(
                textDirection: TextDirection.rtl,
                children: [
                  const Text(
                    'الإجمالي',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Text(
                    '${order.total.toStringAsFixed(2)} ر.س',
                    style: const TextStyle(
                      color: MyOrdersView.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 14,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _shortOrderId(String id) {
    if (id.length <= 8) return id;

    return id.substring(id.length - 8);
  }

  static String _paymentMethodText(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return 'الدفع عند الاستلام';
      case 'online':
        return 'دفع إلكتروني';
      default:
        return method;
    }
  }

  static String _formatDateTime(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/${date.year} - $hour:$minute';
  }
}

class _OrderStatusBadge extends StatelessWidget {
  final String status;

  const _OrderStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final data = _orderStatusData(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: data.color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Icon(data.icon, size: 14, color: data.color),
          const SizedBox(width: 5),
          Text(
            data.text,
            style: TextStyle(
              color: data.color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentStatusBadge extends StatelessWidget {
  final String status;

  const _PaymentStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final data = _paymentStatusData(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: data.color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        data.text,
        style: TextStyle(
          color: data.color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _MessageView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;

  const _MessageView({
    required this.icon,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                color: Color(0xffF3F3F3),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 38, color: Colors.grey),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 7),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Colors.grey,
              ),
            ),
            if (buttonText != null && onPressed != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyOrdersView.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
                child: Text(buttonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusData {
  final String text;
  final Color color;
  final IconData icon;

  const _StatusData({
    required this.text,
    required this.color,
    required this.icon,
  });
}

_StatusData _orderStatusData(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return const _StatusData(
        text: 'قيد المراجعة',
        color: Colors.orange,
        icon: Icons.schedule_rounded,
      );

    case 'confirmed':
      return const _StatusData(
        text: 'تم التأكيد',
        color: Colors.blue,
        icon: Icons.check_circle_outline_rounded,
      );

    case 'preparing':
      return const _StatusData(
        text: 'جاري التحضير',
        color: Colors.deepOrange,
        icon: Icons.restaurant_rounded,
      );

    case 'on_the_way':
      return const _StatusData(
        text: 'في الطريق',
        color: Colors.indigo,
        icon: Icons.delivery_dining_rounded,
      );

    case 'delivered':
      return const _StatusData(
        text: 'تم التوصيل',
        color: Colors.green,
        icon: Icons.check_circle_rounded,
      );

    case 'cancelled':
      return const _StatusData(
        text: 'ملغي',
        color: Colors.red,
        icon: Icons.cancel_outlined,
      );

    default:
      return _StatusData(
        text: status,
        color: Colors.grey,
        icon: Icons.info_outline_rounded,
      );
  }
}

_StatusData _paymentStatusData(String status) {
  switch (status.toLowerCase()) {
    case 'paid':
      return const _StatusData(
        text: 'مدفوع',
        color: Colors.green,
        icon: Icons.check_circle_rounded,
      );

    case 'pending':
    case 'awaiting_payment':
      return const _StatusData(
        text: 'بانتظار الدفع',
        color: Colors.orange,
        icon: Icons.schedule_rounded,
      );

    case 'failed':
      return const _StatusData(
        text: 'فشل الدفع',
        color: Colors.red,
        icon: Icons.error_outline_rounded,
      );

    case 'refunded':
      return const _StatusData(
        text: 'تم الاسترداد',
        color: Colors.blue,
        icon: Icons.replay_rounded,
      );

    case 'unpaid':
    default:
      return const _StatusData(
        text: 'غير مدفوع',
        color: Colors.grey,
        icon: Icons.payments_outlined,
      );
  }
}
