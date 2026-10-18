import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sufra_app/core/styles/appColors.dart';
import 'package:sufra_app/features/products/presentation/views/search_products_view.dart';

class HomeSearchField extends StatelessWidget {
  const HomeSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SearchProductsView()),
        ),
        child: SizedBox(
          height: 51,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'ابحث عن مطعم أو طبق...',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.search_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
