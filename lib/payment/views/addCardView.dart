import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sufra_app/core/styles/appColors.dart';
import 'package:sufra_app/core/styles/appTextStyles.dart';

class AddCardView extends StatefulWidget {
  const AddCardView({super.key});

  @override
  State<AddCardView> createState() => _AddCardViewState();
}

class _AddCardViewState extends State<AddCardView> {
  bool saveCard = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

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

        title: Text("تفاصيل الدفع", style: AppTextStyles.headingLarge),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SvgPicture.asset(
              "assets/home/svgs/shopping-cart.svg",
              width: 22,
              height: 22,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "تخصيص طريقة الدفع الخاصة بك",
                textAlign: TextAlign.right,
                style: AppTextStyles.bodyLarge,
              ),

              const SizedBox(height: 28),

              // رقم البطاقة
              _buildField(
                hint: "رقم البطاقة",
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
              ),

              const SizedBox(height: 16),

              // MM / YY
              Row(
                children: [
                  Expanded(
                    child: _buildField(
                      hint: "YY",
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _buildField(
                      hint: "MM",
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Security Code
              _buildField(
                hint: "رمز الأمان",
                keyboardType: TextInputType.number,
                obscureText: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
              ),

              const SizedBox(height: 16),

              // First Name
              _buildField(
                hint: "الاسم الأول",
                keyboardType: TextInputType.name,
              ),

              const SizedBox(height: 16),

              // Last Name
              _buildField(
                hint: "اسم العائلة",
                keyboardType: TextInputType.name,
              ),

              const SizedBox(height: 22),

              // Save card
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                    child: Text(
                      "حفظ هذه البطاقة للدفع لاحقاً",
                      textAlign: TextAlign.right,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Switch(
                    value: saveCard,
                    activeThumbColor: AppColors.white,
                    activeTrackColor: AppColors.primary,
                    onChanged: (value) {
                      setState(() {
                        saveCard = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 35),

              // Add Card
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // هنربط إضافة البطاقة لاحقاً مع الـ ViewModel
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
                      const Icon(Icons.add, size: 23),
                      const SizedBox(width: 8),
                      Text("إضافة بطاقة", style: AppTextStyles.button),
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

  Widget _buildField({
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    TextAlign textAlign = TextAlign.right,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return SizedBox(
      height: 55,
      child: TextField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        textAlign: textAlign,
        inputFormatters: inputFormatters,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: Colors.grey.shade600,
          ),
          filled: true,
          fillColor: AppColors.lightGrey,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.3),
          ),
        ),
      ),
    );
  }
}
