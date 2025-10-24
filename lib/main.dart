import 'package:flutter/material.dart';
import 'package:pocketfm_shopsy/shopsy/logic_bloc/ProviderCart.dart';
import 'package:pocketfm_shopsy/shopsy/view/ProductListingScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ShopsyApp());
}

class ShopsyApp extends StatelessWidget {
  const ShopsyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider()..loadFromStorage(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopsy - Prototype',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const ProductListScreen(),
      ),
    );
  }
}