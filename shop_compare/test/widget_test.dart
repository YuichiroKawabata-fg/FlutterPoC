import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:shop_compare/screens/search_screen.dart';
import 'package:shop_compare/providers/shop_provider.dart';

class FakeShopProvider extends ShopProvider {
  bool called = false;

  @override
  Future<void> search(String query) async {
    called = true;
  }
}

void main() {
  testWidgets('searching navigates to result screen', (WidgetTester tester) async {
    final provider = FakeShopProvider();
    await tester.pumpWidget(
      ChangeNotifierProvider<ShopProvider>.value(
        value: provider,
        child: const MaterialApp(
          home: SearchScreen(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'test product');
    await tester.tap(find.text('検索'));
    await tester.pumpAndSettle();

    expect(provider.called, isTrue);
    expect(find.text('検索結果'), findsOneWidget);
  });
}
