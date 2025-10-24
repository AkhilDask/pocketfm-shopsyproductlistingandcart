import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic_bloc/ProviderCart.dart';


class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final items = cart.items.values.toList();
    return Scaffold(
      appBar: AppBar(title:  Text('Your Cart',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
      body: items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : SafeArea(
            child: Column(
                    children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, idx) {
                  final ci = items[idx];
                  return Container(
                    padding: EdgeInsets.fromLTRB(0, 3, 2, 3),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey , width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(ci.product.image, width: 64, height: 64, fit: BoxFit.cover)),
                      title: Text(ci.product.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                      subtitle: Text('Qty: ${ci.quantity} · \u20B9${ci.totalPrice.toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => cart.removeProduct(ci.product.id),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Total: \u20B9${cart.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Checkout',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                          content: Text('Proceed to checkout for \u20B9${cart.totalPrice.toStringAsFixed(2)}?'),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(backgroundColor: Colors.redAccent),
                                onPressed: () => Navigator.pop(context), child: const Text('Cancel',style: TextStyle(color: Colors.white),)),
                            TextButton(
                              style: TextButton.styleFrom(backgroundColor: Colors.green),
                              onPressed: () {
                                cart.clear();
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text('Order placed (mock)',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold))));
                              },
                              child: const Text('Confirm',style: TextStyle(color: Colors.white),),
                            )
                          ],
                        ),
                      );
                    },
                    child: const Text('Checkout',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  )
                ],
              ),
            )
                    ],
                  ),
          ),
    );
  }
}