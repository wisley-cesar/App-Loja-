import 'package:flutter/material.dart';
import 'package:loja/models/product_list.dart';
import 'package:loja/utils/app_routes.dart';
import 'package:loja/widgets/app_drawer.dart';
import 'package:loja/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<ProductList>(
      context,
      listen: false,
    ).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final ProductList provader = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Produtos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.FORM);
            },
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: provader.itemsCount,
            itemBuilder: (context, index) => Column(
              children: [
                ProductItem(product: provader.items[index]),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
