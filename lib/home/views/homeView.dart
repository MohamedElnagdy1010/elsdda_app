import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:sufra_app/common/textfild.dart';
import 'package:sufra_app/home/widgets/foods.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey =
        GlobalKey();
    int currentIndex = 2;
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
                      onPressed: () {},
                      child: Text(
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
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        height: 70,
        backgroundColor: const Color.fromARGB(0, 83, 45, 45),
        color: const Color.fromARGB(255, 233, 72, 72),
        buttonBackgroundColor: Colors.transparent,


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
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),

          SvgPicture.asset(
            "assets/home/svgs/002-shopping-bag.svg",
            height: 20,
            width: 20,
          ),

          Transform.translate(
            offset: const Offset(0, -15),
            child: CircleAvatar(
              backgroundColor: const Color(0xffB60F1A),
              radius: 30,
              child: SvgPicture.asset(
                "assets/home/svgs/001-home.svg",
                height: 22,
                width: 22,
              ),
            ),
          ),

          SvgPicture.asset(
            "assets/home/svgs/man-user.svg",
            height: 20,
            width: 20,
          ),

          SvgPicture.asset(
            "assets/home/svgs/Group 6814.svg",
            height: 20,
            width: 20,
          ),
        ],
      ),
    );
  }
}
