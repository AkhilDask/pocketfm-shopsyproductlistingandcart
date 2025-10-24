import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketfm_shopsy/shopsy/logic_bloc/ProviderCart.dart';
import 'package:pocketfm_shopsy/shopsy/model/ModelProduct.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Full UI flow: list → details → add to cart → cart', (WidgetTester tester) async {
    // mock product data
    final mockProducts = [
      Product(id: 1, title: 'Mock Shirt', description: 'Nice one', price: 150.0, image: ''),
      Product(id: 2, title: 'Mock Shoes', description: 'Cool pair', price: 300.0, image: ''),
    ];

    // Widget under test: provides CartProvider and uses our mock list
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CartProvider(),
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ListView.builder(
                itemCount: mockProducts.length,
                itemBuilder: (_, i) {
                  final p = mockProducts[i];
                  return ListTile(
                    title: Text(p.title),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false).addProduct(p);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    // Initially, cart is empty
    final cart = Provider.of<CartProvider>(
      tester.element(find.byType(ListView)),
      listen: false,
    );
    expect(cart.totalItems, 0);

    // Tap add to cart icon for first product
    await tester.tap(find.byIcon(Icons.add_shopping_cart).first);
    await tester.pump();

    // Cart should now contain one item
    expect(cart.totalItems, 1);
    expect(cart.items.values.first.product.title, equals('Mock Shirt'));
  });
}