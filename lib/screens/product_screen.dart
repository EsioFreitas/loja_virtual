import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';

import 'login_screen.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;

  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData product;
  String sizeChoose;

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    Color primary = Theme
        .of(context)
        .primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.95,
            child: Carousel(
              images: product.images.map((img) => NetworkImage(img)).toList(),
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: primary,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primary),
                  maxLines: 3,
                ),
                SizedBox(
                  height: 16,
                ),
                Text("Tamanho",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                SizedBox(
                  height: 34,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.5),
                    children: product.sizes
                        .map(
                          (size) =>
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                sizeChoose = size;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(4)),
                                border: Border.all(
                                    color: size == sizeChoose
                                        ? primary
                                        : Colors.grey[500],
                                    width: 2),
                              ),
                              width: 50,
                              alignment: Alignment.center,
                              child: Text(
                                size,
                                style: TextStyle(
                                    color: size == sizeChoose
                                        ? primary
                                        : Colors.grey[500]),
                              ),
                            ),
                          ),
                    )
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    onPressed: sizeChoose != null
                        ? () {
                      if (UserModel.of(context).isLoggedIn()) {
                        CartProduct productCart = CartProduct();
                        productCart.size = sizeChoose;
                        productCart.quantity = 1;
                        productCart.pId = product.id;
                        productCart.category = product.category;
                        productCart.productData = product;

                        CartModel.of(context).addCartItem(productCart);
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Login()));
                      }
                    }
                        : null,
                    child: Text(
                      UserModel.of(context).isLoggedIn()
                          ? "Adicionar ao Carrinho"
                          : "Entre para Comprar",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    color: primary,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Descrição:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(product.description, style: TextStyle(fontSize: 16)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
