class LocalImageMapper {
  LocalImageMapper._();

  static String? product(String productId) {
    switch (productId.trim()) {
      case 'chicken_salad':
        return 'assets/home/products/chicken_salad.png';

      case 'fruit_salad':
        return 'assets/home/products/fruit_salad.png';

      case 'chocolate_cake':
        return 'assets/home/products/chocolate_cake.png';

      default:
        return null;
    }
  }

  static String? category(String categoryId) {
    switch (categoryId.trim()) {
      case 'appetizers':
        return 'assets/home/categories/appetizers.png';

      case 'salads':
        return 'assets/home/categories/salads.png';

      case 'desserts':
        return 'assets/home/categories/desserts.png';

      case 'offers':
        return 'assets/home/categories/offers.png';

      default:
        return null;
    }
  }
}
