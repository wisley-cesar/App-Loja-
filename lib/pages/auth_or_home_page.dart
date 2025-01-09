import 'package:flutter/material.dart';
import 'package:loja/models/auth.dart';
import 'package:loja/pages/auth_page.dart';
import 'package:loja/pages/products_overview_pages.dart';
import 'package:provider/provider.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    return auth.isAuth ? const ProductsOverviewPages() : const AuthPage();
  }
}
