import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loja/exception/http_exception.dart';

import 'package:loja/models/product.dart';
import 'package:loja/utils/constants.dart';

class ProductList with ChangeNotifier {
  List<Product> _items = [];
  final String? _token;
  ProductList(this._token, this._items);

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      items.where((product) => product.isFavorite).toList();

  int get itemCount {
    return _items.length;
  }

  Future<void> loadProducts() async {
    _items.clear();
    final response = await http.get(
      Uri.parse("${Constants.PRODUCT_BASE_URL}.json?auth=$_token"),
    );

    if (response.body == null || response.body == 'null') {
      print('No data received from the API.');
      return;
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((productId, productData) {
      if (productData is Map<String, dynamic>) {
        _items.add(Product(
          id: productId,
          name: productData['name'] ?? 'Unnamed Product',
          description:
              productData['description'] ?? 'No description available.',
          price: productData['price'] != null
              ? (productData['price'] is num
                  ? (productData['price'] as num).toDouble()
                  : double.tryParse(productData['price'].toString()) ?? 0.0)
              : 0.0,
          imageUrl: productData['imageUrl'] ?? '',
          isFavorite: productData['isFavorite'] ?? false,
        ));
      }
    });

    notifyListeners();
  }

  Future<void> sabeProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;
    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'].toString(),
    );

    if (hasId) {
      return upDateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse("${Constants.PRODUCT_BASE_URL}.json?auth=$_token"),
      body: jsonEncode(
        {
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];

    _items.add(
      Product(
          id: id,
          name: product.name,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          isFavorite: product.isFavorite),
    );
    notifyListeners();
  }

  Future<void> upDateProduct(Product product) async {
    int index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            "${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token"),
        body: jsonEncode(
          {
            'name': product.name,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          },
        ),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      if (index >= 0) {
        _items.remove(product);
        notifyListeners();

        final response = await http.delete(
          Uri.parse(
              "${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token"),
        );

        if (response.statusCode >= 400) {
          _items.insert(index, product);
          notifyListeners();
          throw HttpException(
            message: 'Não foi possível excluir o produto.',
            statusCode: response.statusCode,
          );
        }
      }
    }
  }
}
