import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:sufra_app/categories/categoriesView.dart';
import 'package:sufra_app/core/common/textfild.dart';
import 'package:sufra_app/home/widgets/foods.dart';
import 'package:sufra_app/home/widgets/popularFoods.dart';
import 'package:sufra_app/products/views/allProductsView.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  @override
  int currentIndex = 2;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {"image": "assets/home/catigores/cat1.png", "title": "العروض"},
      {"image": "assets/home/catigores/cat2.png", "title": "سلطات"},
      {"image": "assets/home/catigores/cat3.png", "title": " المقبلات"},
      {"image": "assets/home/catigores/cat1.png", "title": "المشروبات"},
      {"image": "assets/home/catigores/cat2.png", "title": "الحلويات"},
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      "assets/home/svgs/shopping-cart.svg",
                      width: 30,
                      height: 30,
                    ),

                    Text(
                      " ! صباح الخير محمد ",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  "  التوصيل إلى  ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.location_on),
                    ),
                    Text(
                      "  الموقع الحالي ",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                TextField(
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: textField.copyWith(
                    hintText: " البحث عن الطعام",

                    suffixIcon: Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Gap(10),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 120,
                        margin: const EdgeInsets.only(left: 10),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Image.asset(
                                categories[index]["image"]!,
                                width: 40,
                                height: 40,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              categories[index]["title"]!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoriesView(),
                          ),
                        );
                      },
                      child: const Text(
                        "عرض الكل",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      "  أشهر الماكولات ",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Foods(),
                Gap(20),
                SizedBox(height: 400, child: PopularFoods()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                    onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>  AllProductsView(),
    ),
  );
},
                      child: Text(
                        "عرض الكل",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      "أحدث الاصناف",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Gap(30),
                Column(
                  children: [
                    _buildFoodItem(
                      image: "assets/home/foods/pitza.png",
                      title: "بيتزا التوت من جوش",
                      restaurant: "مقهى الطعام الغربي",
                      rate: 4.9,
                      reviews: 124,
                    ),

                    const SizedBox(height: 18),

                    _buildFoodItem(
                      image: "assets/home/foods/egg.png",
                      title: "باريتا",
                      restaurant: "مقهى القهوة",
                      rate: 4.9,
                      reviews: 124,
                    ),

                    const SizedBox(height: 18),

                    _buildFoodItem(
                      image: "assets/home/foods/breads.png",
                      title: "ساعة الذروة في البيتزا",
                      restaurant: "مقهى طعام إيطالي",
                      rate: 4.9,
                      reviews: 124,
                    ),
                  ],
                ),
                Gap(80),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        height: 70,
        backgroundColor: const Color.fromARGB(0, 196, 33, 33),

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: [
          SvgPicture.asset(
            "assets/home/svgs/Group 6847.svg",
            height: 20,
            width: 20,
            colorFilter: ColorFilter.mode(
              currentIndex == 0 ? const Color(0xffB60F1A) : Colors.grey,
              BlendMode.srcIn,
            ),
          ),

          SvgPicture.asset(
            "assets/home/svgs/002-shopping-bag.svg",
            height: 20,
            width: 20,
            colorFilter: ColorFilter.mode(
              currentIndex == 1 ? const Color(0xffB60F1A) : Colors.grey,
              BlendMode.srcIn,
            ),
          ),

          // Home
          CircleAvatar(
            backgroundColor: currentIndex == 2
                ? const Color(0xffB60F1A)
                : Colors.grey,
            radius: 30,
            child: SvgPicture.asset(
              "assets/home/svgs/001-home.svg",
              height: 22,
              width: 22,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),

          SvgPicture.asset(
            "assets/home/svgs/man-user.svg",
            height: 20,
            width: 20,
            colorFilter: ColorFilter.mode(
              currentIndex == 3 ? const Color(0xffB60F1A) : Colors.grey,
              BlendMode.srcIn,
            ),
          ),

          SvgPicture.asset(
            "assets/home/svgs/Group 6814.svg",
            height: 20,
            width: 20,
            colorFilter: ColorFilter.mode(
              currentIndex == 4 ? const Color(0xffB60F1A) : Colors.grey,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem({
    required String image,
    required String title,
    required String restaurant,
    required double rate,
    required int reviews,
  }) {
    return SizedBox(
      height: 90,
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصورة
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(image, width: 75, height: 75, fit: BoxFit.cover),
          ),

          const SizedBox(width: 15),

          // المحتوى
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // اسم الأكلة
                Text(
                  title,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 3),

                // اسم المطعم
                Text(
                  restaurant,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),

                const SizedBox(height: 4),

                // التقييم
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "($reviews تقييمات)",
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),

                    const SizedBox(width: 6),

                    Text(
                      rate.toString(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffB60F1A),
                      ),
                    ),

                    const SizedBox(width: 4),

                    const Icon(Icons.star, size: 16, color: Colors.orange),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
