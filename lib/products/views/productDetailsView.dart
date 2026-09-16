import 'package:flutter/material.dart';
import 'package:sufra_app/products/models/productModel.dart';

class ProductDetailsView extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsView({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsView> createState() =>
      _ProductDetailsViewState();
}

class _ProductDetailsViewState
    extends State<ProductDetailsView> {

  int quantity = 1;
  bool isFavorite = false;
  String selectedOption = "الحجم العادي";

  double get totalPrice {
    return widget.product.price * quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

                    // =========================
                    // Product Image
                    // =========================

                    Stack(
                      children: [

                        SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: Image.asset(
                            widget.product.image,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Back
                        Positioned(
                          top: 18,
                          left: 18,
                          child: _circleButton(
                            icon: Icons.arrow_back_ios_new,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),

                        // Favorite
                        Positioned(
                          top: 18,
                          right: 18,
                          child: _circleButton(
                            icon: isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: const Color(0xffB60F1A),
                            onPressed: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    // =========================
                    // Details
                    // =========================

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.end,
                        children: [

                          // Title + Price
                          Row(
                            textDirection: TextDirection.rtl,
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [

                              Expanded(
                                child: Text(
                                  widget.product.title,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 15),

                              Text(
                                "${widget.product.price.toStringAsFixed(0)} ر.س",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffB60F1A),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Rating
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.end,
                            children: [

                              Text(
                                "(${widget.product.reviews} تقييم)",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 13,
                                ),
                              ),

                              const SizedBox(width: 7),

                              Text(
                                widget.product.rating.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffB60F1A),
                                ),
                              ),

                              const SizedBox(width: 4),

                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 20,
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          const Text(
                            "الوصف",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            widget.product.description,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.7,
                              color: Colors.grey[600],
                            ),
                          ),

                          const SizedBox(height: 30),

                          const Text(
                            "تخصيص الطلب",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Dropdown
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedOption,
                                isExpanded: true,

                                alignment:
                                    Alignment.centerRight,

                                items: const [
                                  DropdownMenuItem(
                                    value: "الحجم العادي",
                                    child: Align(
                                      alignment:
                                          Alignment.centerRight,
                                      child: Text(
                                        "الحجم العادي",
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "الحجم الكبير",
                                    child: Align(
                                      alignment:
                                          Alignment.centerRight,
                                      child: Text(
                                        "الحجم الكبير",
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "بدون إضافات",
                                    child: Align(
                                      alignment:
                                          Alignment.centerRight,
                                      child: Text(
                                        "بدون إضافات",
                                      ),
                                    ),
                                  ),
                                ],

                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedOption = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Quantity
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [

                              Text(
                                "${totalPrice.toStringAsFixed(0)} ر.س",
                                style: const TextStyle(
                                  color: Color(0xffB60F1A),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Row(
                                children: [

                                  _quantityButton(
                                    icon: Icons.remove,
                                    onTap: () {
                                      if (quantity > 1) {
                                        setState(() {
                                          quantity--;
                                        });
                                      }
                                    },
                                  ),

                                  SizedBox(
                                    width: 50,
                                    child: Text(
                                      quantity.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  _quantityButton(
                                    icon: Icons.add,
                                    onTap: () {
                                      setState(() {
                                        quantity++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =========================
            // Add to cart
            // =========================

            Container(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                15,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 15,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "تمت إضافة $quantity من ${widget.product.title} إلى السلة",
                          textAlign: TextAlign.right,
                        ),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xffB60F1A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [

                      const Icon(
                        Icons.shopping_cart_outlined,
                      ),

                      const SizedBox(width: 10),

                      Text(
                        "أضف للسلة - ${totalPrice.toStringAsFixed(0)} ر.س",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color color = Colors.black,
  }) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.10),
            blurRadius: 7,
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          color: Color(0xffB60F1A),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}