import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';
import '../models/product.dart';
import 'detail_search_screen.dart';
import 'product_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _AggregatedProduct {
  final String name;
  final List<Product> offers;
  _AggregatedProduct({required this.name, required this.offers});

  int get minPrice => offers.map((p) => p.price).reduce((a, b) => a < b ? a : b);
  int get maxPrice => offers.map((p) => p.price).reduce((a, b) => a > b ? a : b);
  List<String> get shopNames => offers.map((p) => p.shopName).toList();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _minController = TextEditingController();
  final _maxController = TextEditingController();
  String _sort = 'none';

  @override
  Widget build(BuildContext context) {
    final results = context.watch<ShopProvider>().results;
    final aggregated = _aggregate(results);
    return Scaffold(
      appBar: AppBar(title: const Text('商品検索')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSearchArea(context),
          ),
          Expanded(
            child: aggregated.isEmpty
                ? const Center(child: Text('検索結果がありません'))
                : ListView.builder(
                    itemCount: aggregated.length,
                    itemBuilder: (context, index) {
                      final item = aggregated[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductScreen(
                                productName: item.name,
                                offers: item.offers,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 80,
                                height: 80,
                                child: Icon(Icons.image, size: 50),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(item.name),
                                  subtitle: Text(
                                      '取扱: ${item.shopNames.join(', ')}\n最安値: ¥${item.minPrice}  最高値: ¥${item.maxPrice}'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchArea(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: '検索ワード',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DropdownButton<String>(
                value: _sort,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'none', child: Text('ソートなし')),
                  DropdownMenuItem(value: 'asc', child: Text('価格が安い順')),
                  DropdownMenuItem(value: 'desc', child: Text('価格が高い順')),
                ],
                onChanged: (v) => setState(() => _sort = v ?? 'none'),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 80,
              child: TextField(
                controller: _minController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '最小'),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 80,
              child: TextField(
                controller: _maxController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '最大'),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<ShopProvider>().search(_controller.text);
              },
              child: const Text('検索'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DetailSearchScreen()),
                );
              },
              child: const Text('詳細検索'),
            ),
          ],
        ),
      ],
    );
  }

  List<_AggregatedProduct> _aggregate(List<Product> list) {
    final min = int.tryParse(_minController.text);
    final max = int.tryParse(_maxController.text);

    final filtered = list.where((p) {
      if (min != null && p.price < min) return false;
      if (max != null && p.price > max) return false;
      return true;
    });

    final map = <String, List<Product>>{};
    for (var p in filtered) {
      map.putIfAbsent(p.name, () => []).add(p);
    }
    final items = map.entries
        .map((e) => _AggregatedProduct(name: e.key, offers: e.value))
        .toList();
    if (_sort == 'asc') {
      items.sort((a, b) => a.minPrice.compareTo(b.minPrice));
    } else if (_sort == 'desc') {
      items.sort((a, b) => b.maxPrice.compareTo(a.maxPrice));
    }
    return items;
  }
}
