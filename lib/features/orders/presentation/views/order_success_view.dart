import 'package:flutter/material.dart';
import 'package:sufra_app/features/main_navigation/presentation/main_navigation_view.dart';
import 'package:sufra_app/features/orders/domain/entities/order_entity.dart';

class OrderSuccessView extends StatelessWidget {
  final OrderEntity order;

  const OrderSuccessView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'تم الطلب',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),

                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xffB60F1A).withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Color(0xffB60F1A),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'شكراً لطلبك!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                const Text(
                  'تم استلام طلبك بنجاح وسيتم البدء في معالجته.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xffF8F8F8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _infoRow('رقم الطلب', '#${_shortOrderId(order.id)}'),
                      const SizedBox(height: 14),
                      _infoRow(
                        'الإجمالي',
                        '${order.total.toStringAsFixed(0)} ر.س',
                      ),
                      const SizedBox(height: 14),
                      _infoRow('حالة الطلب', _statusText(order.status)),
                    ],
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const MainNavigationView(initialIndex: 2),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffB60F1A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'العودة إلى المنزل',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const MainNavigationView(initialIndex: 1),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'عرض طلباتي',
                      style: TextStyle(
                        color: Color(0xffB60F1A),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
  }

  Widget _infoRow(String title, String value) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _shortOrderId(String id) {
    if (id.length <= 8) return id;
    return id.substring(id.length - 8);
  }

  String _statusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'قيد المراجعة';
      case 'confirmed':
        return 'تم التأكيد';
      case 'preparing':
        return 'جاري التحضير';
      case 'on_the_way':
        return 'في الطريق';
      case 'delivered':
        return 'تم التوصيل';
      case 'cancelled':
        return 'ملغي';
      default:
        return status;
    }
  }
}
