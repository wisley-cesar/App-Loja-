import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loja/models/cart.dart';
import 'package:loja/models/cart_item.dart';
import 'package:loja/models/order.dart';
import 'package:loja/utils/constants.dart';

class OrderList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Order> _items = [];

  OrderList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    List<Order> items = [];

    _items.clear();
    final response = await http.get(
      Uri.parse("${Constants.ORDERS_BASE_URL}/$_userId.json?auth=$_token"),
    );

    if (response.body == null || response.body == 'null') {
      print('No data received from the API.');
      return;
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach(
      (orderId, orderData) {
        items.add(
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
      },
    );
    _items = items.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
        Uri.parse("${Constants.ORDERS_BASE_URL}/$_userId.json?auth=$_token"),
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
