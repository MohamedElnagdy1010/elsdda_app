import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sufra_app/products/models/productModel.dart';
import 'package:sufra_app/products/views/productDetailsView.dart';

class ProductsView extends StatelessWidget {
  final String categoryTitle;

  const ProductsView({super.key, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    final List<ProductModel> products = [
      const ProductModel(
        title: "فطيرة التفاح الشهية",
        description: "فطيرة طازجة محضرة بأفضل المكونات",
        image: "assets/home/foods/breads.png",
        price: 45,
        rating: 4.9,
        reviews: 124,
      ),

      const ProductModel(
        title: "كيكة الشوكولاتة",
        description: "كيكة شوكولاتة غنية بطعم مميز",
        image: "assets/home/foods/egg.png",
        price: 55,
        rating: 4.8,
        reviews: 95,
      ),

      const ProductModel(
        title: "كيكة الفراولة",
        description: "كيكة طرية مع الفراولة الطازجة",
        image: "assets/home/foods/pitza.png",
        price: 60,
        rating: 4.7,
        reviews: 82,
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
        ),

        centerTitle: true,

        title: Text(
          categoryTitle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SvgPicture.asset(
              "assets/home/svgs/shopping-cart.svg",
              width: 23,
              height: 23,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: "البحث في $categoryTitle",
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[500],
                      size: 21,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 5),

            // Products
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 30),
                itemCount: products.length,

                separatorBuilder: (context, index) {
                  return const SizedBox(height: 12);
                },

                itemBuilder: (context, index) {
                final product = products[index];

return ProductImageCard(
  title: product.title,
  description: product.description,
  image: product.image,

  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsView(
          product: product,
        ),
      ),
    );
  },
);
              
              
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductImageCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final VoidCallback onTap;

  const ProductImageCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: double.infinity,
          height: 190,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Product image
              Image.asset(image, fit: BoxFit.cover),

              // Dark gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Color.fromARGB(190, 0, 0, 0),
                    ],
                  ),
                ),
              ),

              // Favorite
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Color(0xffC8101E),
                    size: 20,
                  ),
                ),
              ),

              // Text
              Positioned(
                right: 15,
                left: 15,
                bottom: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      description,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
