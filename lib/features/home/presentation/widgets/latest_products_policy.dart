import 'package:sufra_app/features/products/domain/entities/product_entity.dart';

/// Selects products for display only; never deletes Firestore data.
abstract final class LatestProductsPolicy {
  static const int minimum = 3;
  static const int homeMaximum = 5;
  static const Duration recentPeriod = Duration(days: 30);

  static List<ProductEntity> select(List<ProductEntity> source, DateTime now) {
    final sorted = List<ProductEntity>.of(source)
      ..sort((a, b) {
        final aDate = a.createdAt;
        final bDate = b.createdAt;
        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return 1;
        if (bDate == null) return -1;
        return bDate.compareTo(aDate);
      });

    final cutoff = now.subtract(recentPeriod);
    final recent = sorted.where((product) {
      final date = product.createdAt;
      return date != null && !date.isBefore(cutoff) && !date.isAfter(now);
    }).toList();

    if (recent.length >= minimum) return recent;

    final result = List<ProductEntity>.of(recent);
    final ids = result.map((product) => product.id).toSet();
    for (final product in sorted) {
      if (result.length >= minimum) break;
      if (ids.add(product.id)) result.add(product);
    }
    return result;
  }
}
