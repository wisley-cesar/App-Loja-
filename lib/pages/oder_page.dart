import 'package:flutter/material.dart';
import 'package:loja/models/order_list.dart';
import 'package:loja/widgets/app_drawer.dart';
import 'package:loja/widgets/order_widget.dart';
import 'package:provider/provider.dart';

class OderPage extends StatelessWidget {
  const OderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<OrderList>(context, listen: false).loadOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Center(
              child: Text('Ocorreu um erro!'),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () =>
                  Provider.of<OrderList>(context, listen: false).loadOrders(),
              child: Consumer<OrderList>(
                builder: (ctx, orders, child) => ListView.builder(
                  itemCount: orders.itemsCount,
                  itemBuilder: (context, index) =>
                      OrderWidget(order: orders.items[index]),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
