import 'package:flutter/material.dart';

import 'package:sufra_app/core/styles/appColors.dart';
import 'package:sufra_app/core/styles/appTextStyles.dart';
import 'package:sufra_app/order/views/checkoutView.dart';

class MyOrderView extends StatelessWidget {
  const MyOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 0,
        centerTitle: true,

        title: Text("طلبي", style: AppTextStyles.headingLarge),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                // ==============================
                // Product
                // ==============================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        "assets/home/pitza.png",
                        width: 95,
                        height: 95,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 95,
                            height: 95,
                            color: AppColors.lightGrey,
                            child: const Icon(
                              Icons.fastfood,
                              size: 35,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("برجر السدة", style: AppTextStyles.headingSmall),

                          const SizedBox(height: 5),

                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 18,
                              ),

                              const SizedBox(width: 4),

                              Text(
                                "4.9",
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(width: 5),

                              Text("(124 تقييم)", style: AppTextStyles.caption),
                            ],
                          ),

                          const SizedBox(height: 5),

                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 17,
                                color: AppColors.primary,
                              ),

                              const SizedBox(width: 3),

                              Text(
                                "المملكة - الرياض",
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                const Divider(height: 1),

                // ==============================
                // Order items
                // ==============================
                _priceRow(title: "برجر لحم كبير", price: "2000 ريال"),

                _priceRow(title: "إضافة صوص السدة", price: "400 ريال"),

                _priceRow(title: "إضافة جبن", price: "500 ريال"),

                _priceRow(title: "إضافة بطاطس", price: "700 ريال"),

                _priceRow(title: "إضافة خس", price: "200 ريال"),

                const SizedBox(height: 8),

                const Divider(height: 1),

                // ==============================
                // Delivery instructions
                // ==============================
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "تعليمات التسليم",
                          style: AppTextStyles.bodyLarge,
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          // UI فقط حاليًا
                        },
                        child: Text(
                          "+ إضافة ملاحظة",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                const SizedBox(height: 16),

                // ==============================
                // Price summary
                // ==============================
                _summaryRow(
                  title: "إجمالي سعر الطلب",
                  price: "3800 ريال",
                  priceRed: true,
                ),

                const SizedBox(height: 12),

                _summaryRow(
                  title: "سعر التوصيل",
                  price: "1000 ريال",
                  priceRed: true,
                ),

                const SizedBox(height: 15),

                const Divider(height: 1),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "الإجمالي",
                        style: AppTextStyles.headingMedium,
                      ),
                    ),

                    Text("4800 ريال", style: AppTextStyles.price),
                  ],
                ),

                const SizedBox(height: 30),

                // ==============================
                // Checkout button
                // ==============================
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckoutView(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text("تحقق من", style: AppTextStyles.button),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Order Row
  // ============================================================

  Widget _priceRow({required String title, required String price}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffEEEEEE))),
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppTextStyles.bodyMedium)),

          Text(
            price,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Summary Row
  // ============================================================

  Widget _summaryRow({
    required String title,
    required String price,
    bool priceRed = false,
  }) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppTextStyles.bodyLarge)),

        Text(
          price,
          style: AppTextStyles.bodyLarge.copyWith(
            color: priceRed ? AppColors.primary : AppColors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
