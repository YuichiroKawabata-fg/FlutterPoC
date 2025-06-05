import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final results = context.watch<ShopProvider>().results;
    return Scaffold(
      appBar: AppBar(title: const Text('検索結果')),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final p = results[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text('${p.shopName}: ${p.name}'),
              subtitle: Text('¥${p.price} (送料: ¥${p.shipping})\n到着予定: ${p.eta}'),
            ),
          );
        },
      ),
    );
  }
}
