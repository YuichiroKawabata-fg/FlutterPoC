import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ShopProvider with ChangeNotifier {
  List<Product> _results = [];
  List<Product> get results => _results;

  static const _yahooClientId =
      'dj00aiZpPXJkMXJNYjZLTEQyMyZzPWNvbnN1bWVyc2VjcmV0Jng9NzE-';

  Future<List<String>> _fetchImagesFromYahoo(String itemCode) async {
    final uri = Uri.https('shopping.yahooapis.jp',
        '/ShoppingWebService/V1/json/itemImageList', {
      'appid': _yahooClientId,
      'itemcode': itemCode,
    });
    try {
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final results = data['ResultSet']?['0']?['Result'];
        if (results is Map) {
          final images = <String>[];
          for (final r in results.values) {
            final list = r['Image'] as List?;
            if (list != null) {
              for (final i in list) {
                final url = i['Small'];
                if (url is String) images.add(url);
              }
            }
          }
          return images;
        }
      }
    } catch (_) {
      // ignore errors
    }
    return [];
  }

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
        final futures = hits.map<Future<Product>>((e) async {
          final images = <String>[];
          final small = e['image']?['small'];
          if (small is String && small.isNotEmpty) {
            images.add(small);
          }
          if (e['code'] != null) {
            final others = await _fetchImagesFromYahoo(e['code']);
            for (final img in others) {
              if (!images.contains(img)) images.add(img);
            }
          }
          final itemUrl = e['url'] ?? '';
          final shippingName = e['shipping']?['name'] ?? '';
          final deliveryDay = (e['delivery']?['day'] as num?)?.toInt() ?? 0;
          return Product(
            shopName: 'Yahoo',
            name: e['name'] ?? '',
            price: (e['price'] as num?)?.toInt() ?? 0,
            shipping: 0,
            shippingName: shippingName,
            deliveryDay: deliveryDay,
            eta: '',
            imageUrls: images,
            itemUrl: itemUrl,
          );
        }).toList();
        return Future.wait(futures);
      }
    } catch (_) {
      // ignore errors
    }
    return [];
  }

  List<Product> _mockSearch(String query) {
    // Placeholder search returning sample data.
    return [
      Product(
          shopName: 'Amazon',
          name: '$query 商品1',
          price: 1000,
          shipping: 0,
          shippingName: '送料無料',
          deliveryDay: 2,
          eta: '2 days',
          imageUrls: const [],
          itemUrl: ''),
      Product(
          shopName: '楽天',
          name: '$query 商品1',
          price: 1100,
          shipping: 100,
          shippingName: '宅配便',
          deliveryDay: 3,
          eta: '3 days',
          imageUrls: const [],
          itemUrl: ''),
      Product(
          shopName: 'Yahoo',
          name: '$query 商品2',
          price: 1050,
          shipping: 50,
          shippingName: '宅配便',
          deliveryDay: 4,
          eta: '4 days',
          imageUrls: const [],
          itemUrl: ''),
    ];
  }

  Future<List<Product>> trending(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      Product(
          shopName: 'Amazon',
          name: '$category Hit A',
          price: 2000,
          shipping: 0,
          shippingName: '送料無料',
          deliveryDay: 2,
          eta: '2 days',
          imageUrls: const [],
          itemUrl: ''),
      Product(
          shopName: 'Rakuten',
          name: '$category Hit B',
          price: 2100,
          shipping: 100,
          shippingName: '宅配便',
          deliveryDay: 3,
          eta: '3 days',
          imageUrls: const [],
          itemUrl: ''),
    ];
  }
}
