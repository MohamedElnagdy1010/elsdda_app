import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sufra_app/products/views/productsView.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {
        "title": "الطعام",
        "count": "120 صنف",
        "image": "assets/home/catigores/cat1.png",
      },
      {
        "title": "المشروبات",
        "count": "80 صنف",
        "image": "assets/home/catigores/cat2.png",
      },
      {
        "title": "الحلويات",
        "count": "65 صنف",
        "image": "assets/home/catigores/cat3.png",
      },
      {
        "title": "المقبلات",
        "count": "100 صنف",
        "image": "assets/home/catigores/cat1.png",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),

        title: const Text(
          "قائمة الطعام",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: SvgPicture.asset(
              "assets/home/svgs/shopping-cart.svg",
              width: 23,
              height: 23,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 10, left: 0, bottom: 20),

          child: Column(
            children: [
              // Search
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(25),
                ),

                child: TextField(
                  textAlign: TextAlign.right,

                  decoration: InputDecoration(
                    hintText: "البحث في قائمة الطعام",
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),

                    suffixIcon: Icon(Icons.search, color: Colors.grey[500]),

                    border: InputBorder.none,

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Categories
              // Categories
          Expanded(
  child: LayoutBuilder(
    builder: (context, constraints) {
      final sidebarWidth = constraints.maxWidth * 0.26;

      return Stack(
        children: [
          // الشريط الأحمر
          Positioned(
            top: 5,
            bottom: 5,
            left: 0,
            child: Container(
              width: sidebarWidth,
              decoration: const BoxDecoration(
                color: Color(0xffB60F1A),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(38),
                  bottomRight: Radius.circular(38),
                ),
              ),
            ),
          ),

          // القائمة
          ListView.separated(
            padding: const EdgeInsets.only(
              top: 25,
              bottom: 25,
            ),
            itemCount: categories.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 24);
            },
            itemBuilder: (context, index) {
              final category = categories[index];

              return _categoryItem(
                context: context,
                title: category["title"]!,
                count: category["count"]!,
                image: category["image"]!,
              );
            },
          ),
        ],
      );
    },
  ),
),
          
            ],
          ),
        ),
      ),
    );
  }

Widget _categoryItem({
  required BuildContext context,
  required String title,
  required String count,
  required String image,
}) {
  return InkWell(
     onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductsView(
          categoryTitle: title,
        ),
      ),
    );
  },
    child: SizedBox(
      height: 87,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // الكارت الأبيض
          Positioned(
            right: 15,
            left: 40,
            top: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.19),
                    blurRadius: 6,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
            ),
          ),
    
          // الصورة
          Positioned(
            right: 25,
            top: 8,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.18),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
    
          // النص
          Positioned(
            right: 110,
            top: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 218, 15, 15),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 15,    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 63, 62, 62),
                  ),
                ),
              ],
            ),
          ),
    
          // دائرة السهم
          Positioned(
            left: 25,
            top: 27,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.10),
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: Color(0xffD99A32),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

}
