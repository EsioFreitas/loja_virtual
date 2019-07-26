import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';

class DiscountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ExpansionTile(
        title: Text('Cupom de desconto',
            textAlign: TextAlign.start,
            style: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.grey[700])),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Digite seu cupom'),
              initialValue: CartModel.of(context).cupomCode ?? "",
              onFieldSubmitted: (text) {
                Firestore.instance
                    .collection('cupons')
                    .document(text)
                    .get()
                    .then((doc) {
                  if (doc.data != null) {
                    CartModel.of(context).setCoupom(text, doc.data['percent']);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content:
                          Text("Desconto de ${doc.data['percent']}% aplicado"),
                      backgroundColor: Theme.of(context).primaryColor,
                    ));
                  } else {
                    CartModel.of(context).setCoupom(null, 0);
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Desconto de ${doc.data['percent']}% aplicado"),
                        backgroundColor: Colors.redAccent));
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
