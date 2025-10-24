import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/ModelCartItem.dart';
import '../model/ModelProduct.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => Map.unmodifiable(_items);

  int get totalItems => _items.values.fold(0, (sum, i) => sum + i.quantity);

  double get totalPrice => _items.values.fold(0.0, (sum, i) => sum + i.totalPrice);

  void addProduct(Product product, {int quantity = 1}) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += quantity;
    } else {
      _items[product.id] = CartItem(product: product, quantity: quantity);
    }
    notifyListeners();
    saveToStorage();
  }

  void removeProduct(int productId) {
    _items.remove(productId);
    notifyListeners();
    saveToStorage();
  }

  void changeQuantity(int productId, int quantity) {
    if (_items.containsKey(productId)) {
      if (quantity <= 0) {
        _items.remove(productId);
      } else {
        _items[productId]!.quantity = quantity;
      }
      notifyListeners();
      saveToStorage();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
    saveToStorage();
  }
  static const _storageKey = 'shopsy_cart_v1';

  Future<void> saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> data = _items.values
          .map((ci) => ci.toJson())
          .toList();
      await prefs.setString(_storageKey, jsonEncode(data));
    } catch (e) {
// ignore errors for prototype
    }
  }

  Future<void> loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw == null) return;
      final List<dynamic> list = jsonDecode(raw);
      _items.clear();
      for (var item in list) {
        final ci = CartItem.fromJson(item as Map<String, dynamic>);
        _items[ci.product.id] = ci;
      }
      notifyListeners();
    } catch (e) {
// ignore — best effort load
    }
  }
}

