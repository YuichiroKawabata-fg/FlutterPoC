import '../models/product.dart';
import 'string_utils.dart';

bool _sameProduct(Product a, Product b) {
  if (a.jan.isNotEmpty && b.jan.isNotEmpty && a.jan == b.jan) {
    return true;
  }
  return isSimilar(a.name, b.name);
}

List<Product> mergeProductLists(List<List<Product>> lists) {
  final merged = <Product>[];
  for (final list in lists) {
    for (final p in list) {
      final index = merged.indexWhere((m) => _sameProduct(p, m));
      if (index == -1) {
        merged.add(p);
      } else {
        // keep existing (earlier list takes precedence)
      }
    }
  }
  return merged;
}
