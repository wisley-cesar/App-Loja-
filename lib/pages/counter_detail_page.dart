import 'package:flutter/material.dart';
import 'package:loja/providers/counter.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    final provader = CounterProvaider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Exemplo contador',
          style: Theme.of(context).primaryTextTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Text(provader?.counterState.value.toString() ?? '0'),
          IconButton(
              onPressed: () {
                setState(() {
                  provader?.counterState.increment();
                  print(provader?.counterState.value);
                });
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                setState(() {
                  print(provader?.counterState.value);
                  provader?.counterState.decrement();
                });
              },
              icon: const Icon(Icons.remove)),
        ],
      ),
    );
  }
}
