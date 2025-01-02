import 'package:flutter/material.dart';
import 'package:loja/models/order_list.dart';
import 'package:loja/widgets/app_drawer.dart';
import 'package:loja/widgets/order_widget.dart';
import 'package:provider/provider.dart';

class OderPage extends StatefulWidget {
  const OderPage({super.key});

  @override
  State<OderPage> createState() => _OderPageState();
}

class _OderPageState extends State<OderPage> {
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<OrderList>(
      context,
      listen: false,
    ).loadOrders().then((_) {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final OrderList orderList = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orderList.itemsCount,
              itemBuilder: (context, index) =>
                  OrderWidget(order: orderList.items[index]),
            ),
    );
  }
}
