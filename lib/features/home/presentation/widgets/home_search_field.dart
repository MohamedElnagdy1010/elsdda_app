import 'package:flutter/material.dart';

import 'package:sufra_app/features/products/presentation/views/search_products_view.dart';

class HomeSearchField extends StatelessWidget {
  const HomeSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchProductsView()),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xffECECEC)),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              const Icon(
                Icons.search_rounded,
                size: 21,
                color: Color(0xffB60F1A),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'ابحث عن وجبتك المفضلة...',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500],
                  ),
                ),
              ),
              Container(width: 1, height: 22, color: const Color(0xffEEEEEE)),
              const SizedBox(width: 11),
              Icon(Icons.tune_rounded, size: 19, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }
}
