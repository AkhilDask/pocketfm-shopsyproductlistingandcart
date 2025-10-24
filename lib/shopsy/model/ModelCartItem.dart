import 'ModelProduct.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() => {
    'product': {
      'id': product.id,
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'image': product.image,
    },
    'quantity': quantity,
  };

  static CartItem fromJson(Map<String, dynamic> json) {
    final p = Product(
      id: json['product']['id'],
      title: json['product']['title'],
      description: json['product']['description'],
      price: (json['product']['price'] as num).toDouble(),
      image: json['product']['image'],
    );
    return CartItem(product: p, quantity: json['quantity']);
  }
}