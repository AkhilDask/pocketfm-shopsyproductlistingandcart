import 'package:flutter_test/flutter_test.dart';
import 'package:pocketfm_shopsy/shopsy/logic_bloc/ProviderCart.dart';
import 'package:pocketfm_shopsy/shopsy/model/ModelProduct.dart';

void main() {
  group('CartProvider', () {
    late CartProvider cart;
    late Product productA;
    late Product productB;

    setUp(() {
      cart = CartProvider();
      productA = Product(
        id: 1,
        title: 'T-Shirt',
        description: 'Cotton',
        price: 100.0,
        image: 'image1.png',
      );
      productB = Product(
        id: 2,
        title: 'Shoes',
        description: 'Sport',
        price: 500.0,
        image: 'image2.png',
      );
    });

    test('initially empty', () {
      expect(cart.items, isEmpty);
      expect(cart.totalPrice, 0);
    });

    test('add product increases total and quantity', () {
      cart.addProduct(productA);
      expect(cart.items.length, 1);
      expect(cart.totalItems, 1);
      expect(cart.totalPrice, 100.0);
    });

    test('adding same product increases quantity', () {
      cart.addProduct(productA);
      cart.addProduct(productA);
      expect(cart.totalItems, 2);
      expect(cart.totalPrice, 200.0);
    });

    test('removing product updates total', () {
      cart.addProduct(productA);
      cart.addProduct(productB);
      cart.removeProduct(productA.id);
      expect(cart.items.containsKey(productA.id), false);
      expect(cart.totalPrice, 500.0);
    });

    test('clear empties cart', () {
      cart.addProduct(productA);
      cart.clear();
      expect(cart.items, isEmpty);
    });
  });
}