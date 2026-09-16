import 'package:flutter/material.dart';

import 'package:sufra_app/core/styles/appColors.dart';
import 'package:sufra_app/core/styles/appTextStyles.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.black,
            size: 21,
          ),
        ),

        title: Text("تحقق من", style: AppTextStyles.headingLarge),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          child: Column(
            children: [
              // Address
              Align(
                alignment: Alignment.centerRight,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "عنوان التسليم",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Text(
                        "المملكة - مدينة نصر",
                        style: AppTextStyles.bodyMedium,
                      ),

                      const SizedBox(height: 4),

                      Text("سوق الذهب", style: AppTextStyles.bodyMedium),

                      const SizedBox(height: 5),

                      Text(
                        "تعديل",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Divider(),

              const Spacer(),

              // Success illustration
              Container(
                width: 145,
                height: 145,
                decoration: const BoxDecoration(
                  color: Color(0xffFFF7E5),
                  shape: BoxShape.circle,
                ),
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 85,
                      color: Color(0xff303040),
                    ),

                    Positioned(
                      top: 12,
                      right: 12,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.primary,
                        child: Icon(
                          Icons.check,
                          color: AppColors.white,
                          size: 38,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              Text(
                "شكراً!",
                style: AppTextStyles.headingLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              Text("لطلبك", style: AppTextStyles.bodyLarge),

              const SizedBox(height: 20),

              Text(
                "تم معالجة طلبك الآن، ستتلقى إشعاراً لدفع الطلب "
                "من السائق. تحقق من حالة الطلب.",
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  height: 1.8,
                  color: Colors.black54,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // هنرجع Home بعد تنظيم Navigation
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text("العودة إلى المنزل", style: AppTextStyles.button),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
