import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sufra_app/payment/views/addCardView.dart';

class PaymentDetailsView extends StatelessWidget {
  const PaymentDetailsView({super.key});

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

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
        ),

        title: const Text(
          "تفاصيل الدفع",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SvgPicture.asset(
              "assets/home/svgs/shopping-cart.svg",
              width: 21,
              height: 21,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // النص التعريفي
              const Text(
                "تخصيص طريقة الدفع الخاصة بك",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 25),

              // البطاقة المحفوظة
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(4),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Selected card
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        const Icon(Icons.check, color: primaryColor, size: 19),

                        const SizedBox(width: 7),

                        const Expanded(
                          child: Text(
                            "فيزا / بطاقة بنك الراجحي",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 17),

                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        // Card type
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: primaryColor),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Text(
                            "بطاقة ائتمان",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const Spacer(),

                        const Text(
                          "••••  ••••  ••••  2187",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Price
                    const Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          "قيمة الدفع",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Spacer(),

                        Text(
                          "4500 ريال",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // line
                    Container(
                      width: double.infinity,
                      height: 9,
                      color: Color(0xffC7C7C7),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Add another card
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddCardView(),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),

                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 22),

                      SizedBox(width: 8),

                      Text(
                        "إضافة بطاقة ائتمان / خصم أخرى",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
