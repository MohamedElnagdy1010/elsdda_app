import 'package:flutter/material.dart';

import 'package:sufra_app/core/styles/appColors.dart';
import 'package:sufra_app/core/styles/appTextStyles.dart';
import 'package:sufra_app/order/views/orderSuccessView.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  int selectedPayment = 0;

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
            size: 21,
            color: AppColors.black,
          ),
        ),

        title: Text("تحقق من", style: AppTextStyles.headingLarge),

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.black,
              size: 23,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
            bottom: 25,
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==========================================
                // Delivery Address
                // ==========================================
                Text(
                  "عنوان التسليم",
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                ),

                const SizedBox(height: 8),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "المملكة - مدينة نصر",
                            style: AppTextStyles.bodyLarge,
                          ),

                          const SizedBox(height: 5),

                          Text("سوق الذهب", style: AppTextStyles.bodyMedium),
                        ],
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        // تعديل العنوان لاحقاً
                      },
                      child: Text(
                        "تعديل",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                const Divider(),

                const SizedBox(height: 15),

                // ==========================================
                // Payment
                // ==========================================
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "طريقة الدفع",
                        style: AppTextStyles.bodyLarge,
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        _showAddCardBottomSheet(context);
                      },
                      child: Text(
                        "+ إضافة بطاقة",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Cash
                _paymentItem(
                  index: 0,
                  title: "الدفع عند الاستلام",
                  icon: Icons.payments_outlined,
                ),

                const SizedBox(height: 10),

                // Visa
                _paymentItem(
                  index: 1,
                  title: "•••• •••• •••• 2187",
                  customIcon: Container(
                    width: 45,
                    alignment: Alignment.center,
                    child: const Text(
                      "VISA",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // PayPal
                _paymentItem(
                  index: 2,
                  title: "ahmed_1@gmail.com",
                  customIcon: Container(
                    width: 45,
                    alignment: Alignment.center,
                    child: const Text(
                      "P",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Divider(),

                const SizedBox(height: 20),

                // ==========================================
                // Order summary
                // ==========================================
                _summaryRow(title: "إجمالي سعر الطلب", value: "3800 ريال"),

                const SizedBox(height: 14),

                _summaryRow(title: "سعر التوصيل", value: "1000 ريال"),

                const SizedBox(height: 17),

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

                const SizedBox(height: 35),

                // ==========================================
                // Send
                // ==========================================
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderSuccessView(),
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

                    child: Text("إرسال", style: AppTextStyles.button),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Payment Item
  // ============================================================

  Widget _paymentItem({
    required int index,
    required String title,
    IconData? icon,
    Widget? customIcon,
  }) {
    final bool isSelected = selectedPayment == index;

    return InkWell(
      onTap: () {
        setState(() {
          selectedPayment = index;
        });
      },
      borderRadius: BorderRadius.circular(8),

      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 14),

        decoration: BoxDecoration(
          color: const Color(0xffF5F5F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xffE7E7E7)),
        ),

        child: Row(
          children: [
            // Radio
            Container(
              width: 20,
              height: 20,
              padding: const EdgeInsets.all(4),

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                  width: 1.5,
                ),
              ),

              child: isSelected
                  ? Container(
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: 12),

            Expanded(child: Text(title, style: AppTextStyles.bodyMedium)),

            if (customIcon != null)
              customIcon
            else if (icon != null)
              Icon(icon, color: Colors.grey.shade600, size: 25),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Summary
  // ============================================================

  Widget _summaryRow({required String title, required String value}) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppTextStyles.bodyLarge)),

        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  void _showAddCardBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Close
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          size: 22,
                          color: AppColors.black,
                        ),
                      ),
                    ),

                    Text(
                      "إضافة بطاقة ائتمان / الخصم",
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 22),

                    _bottomSheetField(
                      hint: "رقم البطاقة",
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Text("الانتهاء", style: AppTextStyles.bodyMedium),

                        const SizedBox(width: 15),

                        Expanded(
                          child: _bottomSheetField(
                            hint: "MM",
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _bottomSheetField(
                            hint: "YY",
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    _bottomSheetField(
                      hint: "رمز الأمان",
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 14),

                    _bottomSheetField(
                      hint: "الاسم الأول",
                      keyboardType: TextInputType.name,
                    ),

                    const SizedBox(height: 14),

                    _bottomSheetField(
                      hint: "اسم العائلة",
                      keyboardType: TextInputType.name,
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "يمكنك إزالة هذه البطاقة",
                            style: AppTextStyles.bodySmall,
                          ),
                        ),

                        Switch(
                          value: false,
                          activeTrackColor: AppColors.primary,
                          onChanged: (value) {
                            // MVVM later
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("إضافة بطاقة", style: AppTextStyles.button),
                            const SizedBox(width: 8),
                            const Icon(Icons.add),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _bottomSheetField({
    required String hint,
    TextInputType? keyboardType,
    TextAlign textAlign = TextAlign.right,
  }) {
    return SizedBox(
      height: 52,
      child: TextField(
        keyboardType: keyboardType,
        textAlign: textAlign,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: Colors.grey.shade400,
          ),
          filled: true,
          fillColor: AppColors.lightGrey,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}
