import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/shop_provider.dart';
import 'screens/search_screen.dart';
import 'screens/category_screen.dart';

void main() {
  runApp(const ShopCompareApp());
}

class ShopCompareApp extends StatelessWidget {
  const ShopCompareApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ShopProvider(),
      child: MaterialApp(
        title: 'Shop Compare',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const _Home(),
      ),
    );
  }
}

class _Home extends StatefulWidget {
  const _Home({Key? key}) : super(key: key);

  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  int _index = 0;
  final _pages = [const SearchScreen(), const CategoryScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '検索'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'カテゴリ'),
        ],
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
