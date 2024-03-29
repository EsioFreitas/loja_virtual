import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/tiles/cart_tile.dart';
import 'package:loja_virtual/widget/card_price.dart';
import 'package:loja_virtual/widget/discount_card.dart';
import 'package:loja_virtual/widget/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

import 'login_screen.dart';
import 'order_screen.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Carrinho'),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8),
            child: ScopedModelDescendant<CartModel>(
                builder: (context, child, model) {
              int p = model.products.length;
              return Text(
                '${p ?? 0} ${p == 1 ? "ITEM" : 'ITENS'}',
                style: TextStyle(fontSize: 17),
              );
            }),
          ),
        ],
      ),
      body: ScopedModelDescendant<CartModel>(builder: (context, child, model) {
        if (model.isLoading && UserModel.of(context).isLoggedIn()) {
          return Center(child: CircularProgressIndicator());
        } else if (!UserModel.of(context).isLoggedIn()) {
          return Container(
            padding: EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.remove_shopping_cart,
                    size: 80, color: Theme.of(context).primaryColor),
                Text('Faça Login para adicionar produtos!',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                SizedBox(height: 16),
                RaisedButton(
                  child: Text("Entrar", style: TextStyle(fontSize: 18)),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Login()));
                  },
                )
              ],
            ),
          );
        } else if (model.products == null || model.products.length == 0) {
          return Center(
            child: Text(
              'Nenhum produto no carrinho',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return ListView(
            children: <Widget>[
              Column(
                children: model.products.map(
                    (product) => CartTile(product)
                ).toList()
              ),
              DiscountCard(),
              ShipCard(),
              CardPrice(() async {
                String order = await model.finishedOrder();
                if(order != null ){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (c)=>Order(order))
                  );
                }
              }),
            ],
          );
        }
      }),
    );
  }
}
