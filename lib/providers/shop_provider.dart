import 'package:flutter/material.dart';
import '../models/product.dart';

class ShopProvider with ChangeNotifier {
  List<Product> _results = [];
  List<Product> get results => _results;

  Future<void> search(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _results = _mockSearch(query);
    notifyListeners();
  }

  List<Product> _mockSearch(String query) {
    // Placeholder search returning sample data.
    return [
      Product(shopName: 'Amazon', name: '$query - Sample A', price: 1000, shipping: 0, eta: '2 days'),
      Product(shopName: 'Rakuten', name: '$query - Sample B', price: 1100, shipping: 100, eta: '3 days'),
      Product(shopName: 'Yahoo', name: '$query - Sample C', price: 1050, shipping: 50, eta: '4 days'),
      Product(shopName: 'Yodobashi', name: '$query - Sample D', price: 980, shipping: 0, eta: '1 day'),
    ];
  }

  Future<List<Product>> trending(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      Product(shopName: 'Amazon', name: '$category Hit A', price: 2000, shipping: 0, eta: '2 days'),
      Product(shopName: 'Rakuten', name: '$category Hit B', price: 2100, shipping: 100, eta: '3 days'),
    ];
  }
}
