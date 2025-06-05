import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';

class TrendingScreen extends StatelessWidget {
  final String category;
  const TrendingScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$category の売れ筋')),
      body: FutureBuilder(
        future: context.read<ShopProvider>().trending(category),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data as List;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final p = items[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('${p.shopName}: ${p.name}'),
                  subtitle: Text(
                      '¥${p.price} (送料: ¥${p.shipping} ${p.shippingName})\n到着予定: ${p.eta} (${p.deliveryDay}日)'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
