import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loja/models/product.dart';
import 'package:loja/models/product_list.dart';
import 'package:loja/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final message = ScaffoldMessenger.of(context);
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
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.FORM,
                  arguments: product,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Excluir Produto'),
                    content: const Text('Tem certeza?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text(
                          'Não',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text(
                          'Sim',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ).then(
                  (value) async {
                    if (value ?? false) {
                      try {
                        await Provider.of<ProductList>(
                          context,
                          listen: false,
                        ).removeProduct(product);
                      } catch (error) {
                        message.showSnackBar(
                          SnackBar(
                            content: Text(
                              error.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
