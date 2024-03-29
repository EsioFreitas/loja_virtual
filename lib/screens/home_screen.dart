import 'package:flutter/material.dart';
import 'package:loja_virtual/tabs/home_tab.dart';
import 'package:loja_virtual/tabs/order_tab.dart';
import 'package:loja_virtual/tabs/products_tab.dart';
import 'package:loja_virtual/widget/cart_widget.dart';
import 'package:loja_virtual/widget/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartBtn(),
        ),
        Scaffold(
          appBar: AppBar(title: Text('Produtos'), centerTitle: true),
          drawer: CustomDrawer(_pageController),
          body: ProductsTab(),
          floatingActionButton: CartBtn(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Meus Pedidos"),
            centerTitle: true,
          ),
          body: OrderTab(),
          drawer: CustomDrawer(_pageController),

        )
      ],
    );
  }
}
