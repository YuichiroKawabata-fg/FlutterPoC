import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ShopProvider with ChangeNotifier {
  List<Product> _results = [];
  List<Product> get results => _results;

  static const _yahooClientId =
      'dj00aiZpPXJkMXJNYjZLTEQyMyZzPWNvbnN1bWVyc2VjcmV0Jng9NzE-';

  Future<void> search(String query) async {
    final yahoo = await _searchYahoo(query);
    final others = _mockSearch(query);
    _results = [...yahoo, ...others];
    notifyListeners();
  }

  Future<List<Product>> _searchYahoo(String query) async {
    final uri = Uri.https('shopping.yahooapis.jp',
        '/ShoppingWebService/V3/itemSearch', {
      'appid': _yahooClientId,
      'query': query,
      'hits': '10',
    });
    try {
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final hits = data['hits'] as List<dynamic>;
        return hits.map((e) {
          return Product(
            shopName: 'Yahoo',
            name: e['name'] ?? '',
            price: (e['price'] as num?)?.toInt() ?? 0,
            shipping: 0,
            eta: '',
          );
        }).toList();
      }
    } catch (_) {
      // ignore errors
    }
    return [];
  }

  List<Product> _mockSearch(String query) {
    // Placeholder search returning sample data.
    return [
      Product(shopName: 'Amazon', name: '$query 商品1', price: 1000, shipping: 0, eta: '2 days'),
      Product(shopName: '楽天', name: '$query 商品1', price: 1100, shipping: 100, eta: '3 days'),
      Product(shopName: 'Yahoo', name: '$query 商品2', price: 1050, shipping: 50, eta: '4 days'),
      Product(shopName: 'ヨドバシ', name: '$query 商品2', price: 980, shipping: 0, eta: '1 day'),
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
