import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/cart_screen.dart';

class CartBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CartScreen()));
      },
      child: Icon(Icons.shopping_cart, color: Colors.white),
      backgroundColor: Theme.of(context).primaryColor,

    );
  }
}
