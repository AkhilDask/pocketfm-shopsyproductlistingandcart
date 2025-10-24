import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../logic_bloc/ProviderCart.dart';
import '../model/ModelProduct.dart';
import '../utils/CustomButton.dart';
import 'CartScreen.dart';
import 'ProductDetailsScreen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> productsFuture;

  @override
  void initState() {
    super.initState();
    productsFuture = loadProducts();
  }

  /// Loads product data from local JSON file (assets/products.json)
  Future<List<Product>> loadProducts() async {
    try {
      final raw = await rootBundle.loadString('assets/products.json');
      final List<dynamic> data = jsonDecode(raw);
      return data.map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error loading products: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shopsy',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, _) {
              return IconButton(
                icon: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.shopping_cart, color: Colors.black),
                    if (cart.totalItems > 0)
                      Positioned(
                        right: 0,
                        top: 6,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.redAccent,
                          child: Text(
                            '${cart.totalItems}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<Product>>(
          future: productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
        
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading products: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
        
            final products = snapshot.data ?? [];
        
            if (products.isEmpty) {
              return const Center(
                child: Text('No products available'),
              );
            }
        
            return SingleChildScrollView(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: products.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _productListItemCard(context, product);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _productListItemCard(BuildContext context, Product product) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            product.image,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          ),
        ),
        title: Text(
          product.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('₹${product.price.toStringAsFixed(2)}'),
        trailing: CustomButton(
          title: "View",
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(product: product),
            ),
          ),
        ),
      ),
    );
  }
}
