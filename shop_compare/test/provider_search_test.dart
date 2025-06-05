import 'package:flutter_test/flutter_test.dart';
import 'package:shop_compare/models/product.dart';
import 'package:shop_compare/providers/shop_provider.dart';

void main() {
  test('search merges duplicate results', () async {
    final yahooProducts = [
      Product(
        shopName: 'Yahoo',
        name: 'テスト商品',
        price: 1,
        shipping: 0,
        shippingName: '',
        deliveryDay: 0,
        eta: '',
        imageUrls: const [],
        itemUrl: '',
        jan: '123',
      )
    ];
    final rakutenProducts = [
      Product(
        shopName: 'Rakuten',
        name: 'テスト商品',
        price: 2,
        shipping: 0,
        shippingName: '',
        deliveryDay: 0,
        eta: '',
        imageUrls: const [],
        itemUrl: '',
        jan: '123',
      ),
      Product(
        shopName: 'Rakuten',
        name: '別商品',
        price: 3,
        shipping: 0,
        shippingName: '',
        deliveryDay: 0,
        eta: '',
        imageUrls: const [],
        itemUrl: '',
      ),
    ];

    final provider = TestShopProvider(
      yahooReturn: yahooProducts,
      rakutenReturn: rakutenProducts,
    );

    await provider.search('test');

    expect(provider.yahooCalled, isTrue);
    expect(provider.rakutenCalled, isTrue);
    expect(provider.results.length, 2);
    expect(provider.results.first.shopName, 'Yahoo');
    expect(provider.results.first.price, 1);
    expect(provider.results[1].name, '別商品');
  });
}
