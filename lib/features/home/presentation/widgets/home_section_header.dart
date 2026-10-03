import 'package:flutter/material.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const HomeSectionHeader({super.key, required this.title, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xff1C1C1C),
            ),
          ),
        ),
        if (onViewAll != null) ...[
          const SizedBox(width: 10),
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xffB60F1A),
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'عرض الكل',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                ),
                SizedBox(width: 3),
                Icon(Icons.arrow_back_ios_new_rounded, size: 10),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
