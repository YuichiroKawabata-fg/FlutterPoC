import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';
import 'result_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('商品検索')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: '商品名',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ShopProvider>().search(_controller.text).then((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ResultScreen(),
                    ),
                  );
                });
              },
              child: const Text('検索'),
            ),
          ],
        ),
      ),
    );
  }
}
