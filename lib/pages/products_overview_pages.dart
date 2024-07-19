import 'package:flutter/material.dart';
import 'package:loja/models/cart.dart';
import 'package:loja/utils/app_routes.dart';
import 'package:loja/widgets/app_drawer.dart';
import 'package:loja/widgets/badgee.dart';
import 'package:loja/widgets/product_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  Favorito,
  All,
}

class ProductsOverviewPages extends StatefulWidget {
  const ProductsOverviewPages({
    super.key,
  });

  @override
  State<ProductsOverviewPages> createState() => _ProductsOverviewPagesState();
}

class _ProductsOverviewPagesState extends State<ProductsOverviewPages> {
  bool _showFavoriteOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Minha Loja',
          style: Theme.of(context).primaryTextTheme.titleLarge,
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.Favorito,
                child: Text('Somente Favoritos'),
              ),
              const PopupMenuItem(
                value: FilterOptions.All,
                child: Text('Todos'),
              ),
            ],
            onSelected: (FilterOptions selcetValue) {
              setState(() {
                if (selcetValue == FilterOptions.Favorito) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CART);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
            builder: (context, cart, child) => Badgee(
              value: cart.itemsCount.toString(),
              child: child!,
            ),
          ),
        ],
      ),
      body: ProductGrid(
        showfavoriteOnly: _showFavoriteOnly,
      ),
      drawer: const AppDrawer(),
    );
  }
}
