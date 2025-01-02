import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loja/models/cart.dart';
import 'package:loja/models/cart_item.dart';
import 'package:loja/models/order.dart';
import 'package:loja/models/product.dart';
import 'package:loja/utils/constants.dart';

class OrderList with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    _items.clear();
    final response = await http.get(
      Uri.parse("${Constants.ORDERS_BASE_URL}.json"),
    );

    if (response.body == null || response.body == 'null') {
      print('No data received from the API.');
      return;
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach(
      (orderId, orderData) {
        _items.add(
          Order(
            id: orderId,
            data: DateTime.parse(orderData['data']),
            total: orderData['total'],
            products: (orderData['products'] as List<dynamic>).map((item) {
              return CartItem(
                id: item['id'],
                productId: item['productId'],
                name: item['name'],
                quantity: item['quantity'],
                price: item['price'],
              );
            }).toList(),
          ),
        );
        print(data);
      },
    );

    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response =
        await http.post(Uri.parse("${Constants.ORDERS_BASE_URL}.json"),
            body: jsonEncode(
              {
                'total': cart.totalAmount,
                'data': date.toIso8601String(),
                'products': cart.items.values
                    .map(
                      (cartItem) => {
                        'id': cartItem.id,
                        'productId': cartItem.productId,
                        'name': cartItem.name,
                        'quantity': cartItem.quantity,
                        'price': cartItem.price,
                      },
                    )
                    .toList(),
              },
            ));

    final id = jsonDecode(response.body)['name'];
    _items.insert(
      0,
      Order(
        id: id,
        total: cart.totalAmount,
        products: cart.items.values.toList(),
        data: date,
      ),
    );
    notifyListeners();
  }
}
