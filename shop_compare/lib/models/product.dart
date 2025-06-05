class Product {
  final String shopName;
  final String name;
  final int price;
  final int shipping;
  final String shippingName;
  final int deliveryDay;
  final String eta;
  final List<String> imageUrls;
  final String itemUrl;

  Product({
    required this.shopName,
    required this.name,
    required this.price,
    required this.shipping,
    required this.shippingName,
    required this.deliveryDay,
    required this.eta,
    required this.imageUrls,
    required this.itemUrl,
  });

  String get imageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';
}
