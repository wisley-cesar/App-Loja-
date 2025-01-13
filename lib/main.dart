import 'package:flutter/material.dart';
import 'package:loja/models/auth.dart';
import 'package:loja/models/cart.dart';
import 'package:loja/models/order_list.dart';
import 'package:loja/models/product_list.dart';
import 'package:loja/pages/auth_or_home_page.dart';
import 'package:loja/pages/cart_page.dart';
import 'package:loja/pages/oder_page.dart';
import 'package:loja/pages/product_detail_page.dart';
import 'package:loja/pages/product_form_page.dart';
import 'package:loja/pages/products_page.dart';
import 'package:loja/utils/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: (context, auth, previous) {
            return ProductList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (context, auth, previous) {
            return OrderList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? const [],
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'App Loja',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.purple,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontFamily: 'lato',
              fontSize: 20,
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
          primaryTextTheme: const TextTheme(
            titleLarge: TextStyle(color: Colors.white),
          ),
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSeed(
            primary: Colors.purple,
            secondary: Colors.deepOrange,
            tertiary: Colors.amberAccent,
            seedColor: Colors.purple,
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.AUTH_OR_HOME: (context) => const AuthOrHomePage(),
          AppRoutes.PRODUCT_DETAIL: (context) => const ProductDetailPage(),
          AppRoutes.CART: (context) => const CartPage(),
          AppRoutes.ORDERS: (context) => const OderPage(),
          AppRoutes.PRODUCTS: (context) => const ProductsPage(),
          AppRoutes.FORM: (context) => const ProductFormPage(),
        },
      ),
    );
  }
}
