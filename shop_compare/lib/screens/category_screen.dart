import 'package:flutter/material.dart';
import 'trending_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = ['家電', '本', 'ゲーム', 'ファッション'];
    return Scaffold(
      appBar: AppBar(title: const Text('カテゴリ')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final c = categories[index];
          return ListTile(
            title: Text(c),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TrendingScreen(category: c),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
