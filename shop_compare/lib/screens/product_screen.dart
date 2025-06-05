import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/product.dart';

class ProductScreen extends StatelessWidget {
  final String productName;
  final List<Product> offers;
  const ProductScreen({Key? key, required this.productName, required this.offers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final images = offers.isNotEmpty ? offers.first.imageUrls : const <String>[];
    return Scaffold(
      appBar: AppBar(title: Text(productName)),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  child: SizedBox(
                    width: 300,
                    height: 300,
                    child: _buildGallery(images),
                  ),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                height: 150,
                child: _buildGallery(images),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final o = offers[index];
                return ListTile(
                  leading: const Icon(Icons.store),
                  title: Text(o.shopName),
                  subtitle: Text(
                      '価格: ¥${o.price} 送料: ¥${o.shipping} ${o.shippingName} 配送: ${o.eta} (${o.deliveryDay}日)'),
                  onTap: () async {
                    if (o.itemUrl.isEmpty) return;
                    final uri = Uri.parse(o.itemUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      );
  }

  Widget _buildGallery(List<String> urls) {
    if (urls.isEmpty) {
      return const Icon(Icons.image, size: 100);
    }
    return PageView.builder(
      itemCount: urls.length,
      itemBuilder: (context, index) {
        return Image.network(urls[index], fit: BoxFit.cover);
      },
    );
  }
}
