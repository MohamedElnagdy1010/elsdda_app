import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sufra_app/more/views/aboutUsView.dart';
import 'package:sufra_app/order/views/myOrderView.dart';
import 'package:sufra_app/payment/views/paymentDetailsView.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  static const Color primaryColor = Color(0xffB60F1A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "أكثر",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),

        leading: Padding(
          padding: const EdgeInsets.all(15),
          child: SvgPicture.asset(
            "assets/home/svgs/shopping-cart.svg",
            width: 20,
            height: 20,
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
          child: Column(
            children: [
              // تفاصيل الدفع
              _moreItem(
                title: "تفاصيل الدفع",
                icon: Icons.payments_outlined,
                showNotification: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentDetailsView(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),

              // طلباتي
              _moreItem(
  title: "طلباتي",
  icon: Icons.shopping_bag_outlined,
  showNotification: true,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyOrderView(),
      ),
    );
  },
),

              const SizedBox(height: 14),

              // من نحن
              _moreItem(
                title: "من نحن",
                icon: Icons.info_outline,
                showNotification: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutUsView(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _moreItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool showNotification = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),

        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 12),

          decoration: BoxDecoration(
            color: const Color(0xffF3F3F3),
            borderRadius: BorderRadius.circular(12),
          ),

          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              // Icon
              Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  color: Color(0xffE2E2E2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 23, color: Colors.grey),
              ),

              const SizedBox(width: 14),

              // Title
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Notification
              if (showNotification) ...[
                Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
              ],

              const Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
