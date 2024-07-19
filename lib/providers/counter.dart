import 'package:flutter/material.dart';

class CounterState {
  int _value = 0;
  void increment() => _value++;
  void decrement() => _value--;
  int get value => _value;
  bool diff(CounterState old) {
    return old._value != _value;
  }
}

class CounterProvaider extends InheritedWidget {
  final CounterState counterState = CounterState();
  CounterProvaider({super.key, required super.child});

  static CounterProvaider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterProvaider>();
  }

  @override
  bool updateShouldNotify(covariant CounterProvaider oldWidget) {
    return oldWidget.counterState.diff(counterState);
  }
}
