import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sufra_app/home/model/foodsmodel.dart';

class Foods extends StatelessWidget {
  const Foods({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Foodsmodel> foods = [
      Foodsmodel(
        "assets/home/foods/pitza.png",
        "البيتزا بالجبن",
        124,
        9.4,
      ),
      Foodsmodel(
        "assets/home/foods/egg.png",
        "بيض مسلوق",
        150,
        9.8,
      ),
      Foodsmodel(
        "assets/home/foods/breads.png",
        "مخبوزات تيلا",
        200,
        9.7,
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 10,
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              shadowColor: Colors.grey[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 10,
              child: Image.asset(
                foods[index].image,
                width: double.infinity,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),

            Text(
              foods[index].name,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/home/svgs/rate.svg",
                      width: 25,
                      height: 25,
                    ),
                    Text(
                      "${foods[index].rate}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.red[600],
                      ),
                    ),
                  ],
                ),

                Text(
                  "   مقهى الطعام الغربي",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Text(
                  "( ${foods[index].numOfRate} تقييمات )",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}