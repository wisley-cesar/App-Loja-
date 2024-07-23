import 'package:flutter/material.dart';
import 'package:loja/models/product.dart';
import 'package:loja/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
