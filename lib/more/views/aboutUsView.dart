import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sufra_app/core/dependency_injection/dependency_injection.dart';
import 'package:sufra_app/core/styles/appColors.dart';
import 'package:sufra_app/core/styles/appTextStyles.dart';

import 'package:sufra_app/features/branches/presentation/cubit/branches/branches_cubit.dart';
import 'package:sufra_app/features/branches/presentation/widgets/branches_section.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BranchesCubit>()..getBranches(),
      child: const _AboutUsBody(),
    );
  }
}

class _AboutUsBody extends StatelessWidget {
  const _AboutUsBody();

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
        title: Text('من نحن', style: AppTextStyles.headingLarge),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIntroCard(),

                const SizedBox(height: 25),

                _buildSection(
                  title: 'رسالتنا',
                  icon: Icons.flag_outlined,
                  text:
                      'نسعى لتقديم وجبات لذيذة ومميزة تلبي مختلف الأذواق، مع الحفاظ على جودة عالية وخدمة مميزة وتجربة طلب سهلة.',
                ),

                const SizedBox(height: 22),

                _buildSection(
                  title: 'رؤيتنا',
                  icon: Icons.visibility_outlined,
                  text:
                      'أن نكون من الخيارات المفضلة لمحبي الطعام من خلال تقديم تجربة طلب وتوصيل سهلة وموثوقة.',
                ),

                const SizedBox(height: 25),

                Text(
                  'ماذا نقدم؟',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 12),

                _buildBullet('تشكيلة متنوعة من الوجبات.'),
                _buildBullet('جودة عالية باستخدام مكونات طازجة.'),
                _buildBullet('تجربة طلب سهلة وسريعة.'),
                _buildBullet('خدمة عملاء مميزة.'),
                _buildBullet('توصيل سريع وموثوق.'),

                const SizedBox(height: 30),

                const Divider(),

                const SizedBox(height: 25),

                const BranchesSection(),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    'نتمنى لكم تجربة طعام شهية ومميزة مع مطعم السدة!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      height: 1.7,
                      fontWeight: FontWeight.w600,
                    ),
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

  Widget _buildIntroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مطعم السدة',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'نقدم لكم تجربة طعام مميزة تصل إلى باب منزلك بكل سهولة من خلال تطبيقنا، ونعمل دائمًا على تقديم أشهى الوجبات بجودة عالية وتجربة طلب بسيطة ومريحة.',
            style: AppTextStyles.bodyMedium.copyWith(height: 1.8),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String text,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(width: 7),
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(text, style: AppTextStyles.bodyMedium.copyWith(height: 1.8)),
      ],
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7),
            child: Icon(Icons.circle, size: 7, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
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
