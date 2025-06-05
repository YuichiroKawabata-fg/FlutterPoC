import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../utils/product_merger.dart';

class ShopProvider with ChangeNotifier {
  List<Product> _results = [];
  List<Product> get results => _results;

  static const _yahooClientId =
      'dj00aiZpPXJkMXJNYjZLTEQyMyZzPWNvbnN1bWVyc2VjcmV0Jng9NzE-';

  static const _rakutenAppId = '1019558712714302383';
  static const _rakutenAffiliateId =
      '48e3be2a.386fa266.48e3be2b.77e888c7';

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
    final yahooFuture = _searchYahoo(query);
    final rakutenFuture = _searchRakuten(query);
    final results = await Future.wait([yahooFuture, rakutenFuture]);
    final yahoo = results[0] as List<Product>;
    final rakuten = results[1] as List<Product>;
    final others = _mockSearch(query);
    _results = mergeProductLists([yahoo, rakuten, others]);
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
          final jan = e['janCode'] ?? '';
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
            jan: jan,
          );
        }).toList();
        return Future.wait(futures);
      }
    } catch (_) {
      // ignore errors
    }
    return [];
  }

  Future<List<Product>> _searchRakuten(String query) async {
    final uri = Uri.https('app.rakuten.co.jp',
        '/services/api/IchibaItem/Search/20170706', {
      'applicationId': _rakutenAppId,
      'affiliateId': _rakutenAffiliateId,
      'keyword': query,
      'hits': '10',
    });
    try {
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final items = data['Items'] as List<dynamic>?;
        if (items == null) return [];
        return items.map<Product? >((e) {
          final item = e['Item'] as Map<String, dynamic>?;
          if (item == null) {
            return null;
          }
          final imageUrls = <String>[];
          final imgs = item['smallImageUrls'] as List?;
          if (imgs != null && imgs.isNotEmpty) {
            final url = imgs[0]['imageUrl'];
            if (url is String) imageUrls.add(url);
          }
          final itemUrl = item['affiliateUrl'] ?? item['itemUrl'] ?? '';
          final jan = item['jan'] ?? '';
          return Product(
            shopName: 'Rakuten',
            name: item['itemName'] ?? '',
            price: (item['itemPrice'] as num?)?.toInt() ?? 0,
            shipping: 0,
            shippingName: '',
            deliveryDay: 0,
            eta: '',
            imageUrls: imageUrls,
            itemUrl: itemUrl,
            jan: jan,
          );
        }).whereType<Product>().toList();
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

/// Test helper that exposes calls to the private search methods.
class TestShopProvider extends ShopProvider {
  bool yahooCalled = false;
  bool rakutenCalled = false;

  List<Product> yahooReturn;
  List<Product> rakutenReturn;

  TestShopProvider({
    this.yahooReturn = const [],
    this.rakutenReturn = const [],
  });

  @override
  Future<List<Product>> _searchYahoo(String query) async {
    yahooCalled = true;
    return yahooReturn;
  }

  @override
  Future<List<Product>> _searchRakuten(String query) async {
    rakutenCalled = true;
    return rakutenReturn;
  }

  @override
  List<Product> _mockSearch(String query) => [];
}
