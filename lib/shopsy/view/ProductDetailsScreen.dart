import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic_bloc/ProviderCart.dart';
import '../model/ModelProduct.dart';

class ProductDetailScreen extends StatefulWidget {

  final Product product;
  const ProductDetailScreen({required this.product, super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.title,style: TextStyle(fontWeight: FontWeight.bold),)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(widget.product.image, height: size.height * 0.4, fit: BoxFit.cover),
              ),
               SizedBox(height: size.height * 0.02),
              Text(widget.product.title, style:  TextStyle(fontSize: size.height * 0.03, fontWeight: FontWeight.bold)),
              SizedBox(height: size.height * 0.01),
              Text('\u20B9${widget.product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18)),
              SizedBox(height: size.height * 0.03),
              Text(widget.product.description),
              const Spacer(),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => setState(() => quantity = (quantity > 1) ? quantity - 1 : 1),
                  ),
                  Text('$quantity', style: const TextStyle(fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => setState(() => quantity += 1),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add_shopping_cart,color: Colors.white,),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    label:  Text('Add to Cart',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    onPressed: () {
                      cart.addProduct(widget.product, quantity: quantity);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                            content: Text('Added ${widget.product.title} x$quantity to cart',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)),
                      );
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}