import 'package:flutter_test/flutter_test.dart';
import 'package:shop_compare/models/product.dart';
import 'package:shop_compare/providers/shop_provider.dart';

void main() {
  test('search aggregates results from Yahoo and Rakuten', () async {
    final yahooProducts = [
      Product(
        shopName: 'Yahoo',
        name: 'Y',
        price: 1,
        shipping: 0,
        shippingName: '',
        deliveryDay: 0,
        eta: '',
        imageUrls: const [],
        itemUrl: '',
      )
    ];
    final rakutenProducts = [
      Product(
        shopName: 'Rakuten',
        name: 'R',
        price: 2,
        shipping: 0,
        shippingName: '',
        deliveryDay: 0,
        eta: '',
        imageUrls: const [],
        itemUrl: '',
      )
    ];

    final provider = TestShopProvider(
      yahooReturn: yahooProducts,
      rakutenReturn: rakutenProducts,
    );

    await provider.search('test');

    expect(provider.yahooCalled, isTrue);
    expect(provider.rakutenCalled, isTrue);
    expect(provider.results, equals([...yahooProducts, ...rakutenProducts]));
  });
}
