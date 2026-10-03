import 'package:flutter/material.dart';

import 'package:sufra_app/core/utils/local_image_mapper.dart';
import 'package:sufra_app/core/widgets/app_network_image.dart';
import 'package:sufra_app/features/orders/domain/entities/order_entity.dart';
import 'package:sufra_app/features/orders/domain/entities/order_item_entity.dart';

class OrderDetailsView extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailsView({super.key, required this.order});

  static const Color primaryColor = Color(0xffB60F1A);

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
          'تفاصيل الطلب',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _OrderHeader(order: order),

            const SizedBox(height: 14),

            _SectionCard(
              title: 'المنتجات',
              child: Column(
                children: List.generate(order.items.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == order.items.length - 1 ? 0 : 16,
                    ),
                    child: _OrderItemCard(item: order.items[index]),
                  );
                }),
              ),
            ),

            const SizedBox(height: 14),

            _SectionCard(
              title: 'بيانات التوصيل',
              child: Column(
                children: [
                  _DetailsRow(title: 'العنوان', value: order.address),
                  const SizedBox(height: 14),
                  _DetailsRow(
                    title: 'طريقة الدفع',
                    value: _paymentMethodText(order.paymentMethod),
                  ),
                  const SizedBox(height: 14),
                  _DetailsRow(
                    title: 'حالة الدفع',
                    value: _paymentStatusText(order.paymentStatus),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            _SectionCard(
              title: 'ملخص الطلب',
              child: Column(
                children: [
                  _DetailsRow(
                    title: 'المجموع الفرعي',
                    value: '${order.subtotal.toStringAsFixed(2)} ر.س',
                  ),
                  const SizedBox(height: 12),
                  _DetailsRow(
                    title: 'رسوم التوصيل',
                    value: '${order.deliveryFee.toStringAsFixed(2)} ر.س',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Divider(height: 1),
                  ),
                  _DetailsRow(
                    title: 'الإجمالي',
                    value: '${order.total.toStringAsFixed(2)} ر.س',
                    isTotal: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            _SectionCard(
              title: 'معلومات الطلب',
              child: Column(
                children: [
                  _DetailsRow(
                    title: 'رقم الطلب',
                    value: '#${_shortOrderId(order.id)}',
                  ),
                  const SizedBox(height: 14),
                  _DetailsRow(
                    title: 'عدد المنتجات',
                    value: '${order.totalItems}',
                  ),
                  const SizedBox(height: 14),
                  _DetailsRow(
                    title: 'تاريخ الطلب',
                    value: _formatDateTime(order.createdAt),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _shortOrderId(String id) {
    if (id.length <= 8) return id;

    return id.substring(id.length - 8);
  }

  static String _formatDateTime(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/${date.year} - $hour:$minute';
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

  static String _paymentStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return 'مدفوع';
      case 'pending':
      case 'awaiting_payment':
        return 'بانتظار الدفع';
      case 'failed':
        return 'فشل الدفع';
      case 'refunded':
        return 'تم الاسترداد';
      case 'unpaid':
      default:
        return 'غير مدفوع';
    }
  }
}

class _OrderHeader extends StatelessWidget {
  final OrderEntity order;

  const _OrderHeader({required this.order});

  @override
  Widget build(BuildContext context) {
    final status = _statusData(order.status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffEEEEEE)),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: status.color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(status.icon, color: status.color, size: 25),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'حالة الطلب',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  status.text,
                  style: TextStyle(
                    color: status.color,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _DetailsRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isTotal;

  const _DetailsRow({
    required this.title,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isTotal ? Colors.black : Colors.grey,
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: isTotal ? OrderDetailsView.primaryColor : Colors.black87,
              fontSize: isTotal ? 17 : 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  final OrderItemEntity item;

  const _OrderItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppNetworkImage(
          imageUrl: item.image,
          fallbackAsset: LocalImageMapper.product(item.productId),
          width: 78,
          height: 78,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(14),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.name,
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),

              if (item.hasSelectedOption) ...[
                const SizedBox(height: 5),
                Text(
                  'الاختيار: ${item.selectedOption}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],

              const SizedBox(height: 5),

              Text(
                'الكمية: ${item.quantity}',
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),

              const SizedBox(height: 6),

              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    '${item.totalPrice.toStringAsFixed(2)} ر.س',
                    style: const TextStyle(
                      color: OrderDetailsView.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${item.price.toStringAsFixed(2)} ر.س × ${item.quantity}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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

_StatusData _statusData(String status) {
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
