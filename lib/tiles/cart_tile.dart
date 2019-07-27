import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';

class CartTile extends StatelessWidget {
  final CartProduct product;

  CartTile(this.product);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: product.productData == null
            ? FutureBuilder<DocumentSnapshot>(
                future: Firestore.instance
                    .collection('products')
                    .document(product.category)
                    .collection('items')
                    .document(product.pId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    product.productData =
                        ProductData.fromDocument(snapshot.data);
                    return _buildContent(context);
                  } else
                    return Container(
                      height: 70,
                      child: CircularProgressIndicator(),
                      alignment: Alignment.center,
                    );
                },
              )
            : _buildContent(context));
  }

  Widget _buildContent(context) {
    CartModel.of(context).updatePrices();
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8),
          width: 120,
          child:
              Image.network(product.productData.images[0], fit: BoxFit.cover),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  product.productData.title,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                ),
                Text(
                  "Tamanho ${product.size}",
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                Text(
                  "R\$ ${product.productData.price.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color.fromARGB(255, 4, 125, 141)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove,
                          color: Color.fromARGB(255, 4, 125, 141)),
                      onPressed: product.quantity > 1 ? () {
                        CartModel.of(context).decProduct(product);
                      } : null,
                    ),
                    Text(product.quantity.toString()),
                    IconButton(
                      icon: Icon(Icons.add,
                          color: Color.fromARGB(255, 4, 125, 141)),
                      onPressed: () {
                        CartModel.of(context).incProduct(product);
                      },
                    ),
                    FlatButton(
                      child: Text("Remover"),
                      textColor: Colors.grey[500],
                      onPressed: () {
                        CartModel.of(context).removeCartItem(product);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
