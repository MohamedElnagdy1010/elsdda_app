import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sufra_app/core/styles/appColors.dart';
import 'package:sufra_app/core/styles/appTextStyles.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

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
            size: 20,
            color: AppColors.black,
          ),
        ),

        title: Text("من نحن", style: AppTextStyles.headingLarge),

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
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildParagraph(
                  "نحن في مطعم السدة نقدم لكم تجربة طعام مميزة تصل "
                  "إلى باب منزلك بكل سهولة وسرعة من خلال تطبيقنا. "
                  "نعمل دائمًا على تقديم أشهى الوجبات بأفضل جودة "
                  "مع الحرص على توفير تجربة طلب بسيطة ومريحة.",
                ),

                const SizedBox(height: 22),

                _buildSection(
                  title: "رسالتنا:",
                  text:
                      "نسعى لتقديم وجبات لذيذة ومميزة تلبي جميع الأذواق، "
                      "مع الحفاظ على جودة عالية وخدمة ممتازة.",
                ),

                const SizedBox(height: 22),

                _buildSection(
                  title: "رؤيتنا:",
                  text:
                      "أن نكون الخيار الأول لمحبي الطعام من خلال تقديم "
                      "تجربة توصيل سهلة وموثوقة.",
                ),

                const SizedBox(height: 22),

                Text(
                  "ماذا نقدم؟",
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                _buildBullet("تشكيلة متنوعة من الوجبات."),
                _buildBullet("جودة عالية باستخدام مكونات طازجة."),
                _buildBullet("تجربة طلب سهلة وسريعة."),
                _buildBullet("خدمة عملاء مميزة."),
                _buildBullet("توصيل سريع وموثوق."),

                const SizedBox(height: 18),

                Text(
                  "نتمنى لكم تجربة طعام شهية ومميزة مع مطعم السدة!",
                  style: AppTextStyles.bodyMedium.copyWith(height: 1.8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 6),

        Text(text, style: AppTextStyles.bodyMedium.copyWith(height: 1.8)),
      ],
    );
  }

  Widget _buildParagraph(String text) {
    return Text(text, style: AppTextStyles.bodyMedium.copyWith(height: 1.8));
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "•",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
