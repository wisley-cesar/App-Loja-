import 'package:flutter/material.dart';
import 'package:loja/models/order_list.dart';
import 'package:loja/widgets/app_drawer.dart';
import 'package:loja/widgets/order_widget.dart';
import 'package:provider/provider.dart';

class OderPage extends StatelessWidget {
  const OderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderList orderList = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: orderList.itemsCount,
        itemBuilder: (context, index) =>
            OrderWidget(order: orderList.items[index]),
      ),
    );
  }
}
