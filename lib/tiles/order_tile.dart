import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final String id;

  OrderTile(this.id);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<DocumentSnapshot>(
            stream:
                Firestore.instance.collection('user').document(id).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return CircularProgressIndicator();
              else
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Código do pedido: ${snapshot.data.documentID}",
                    style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 16),
                    Text(
                      _buildProductText(snapshot.data)
                    )
                  ],
                );
            }),
      ),
    );
  }

  String _buildProductText(DocumentSnapshot snapshot){
    String text = "Descrição\n";
    for(LinkedHashMap p in snapshot.data['products']){
       text += "${p['quantity']} x ${p['product']['price'].toStringAsFixed(2)}\n";
    }

    text += "Total: R\$ ${snapshot.data['tootalPrice'].toStringAsFixed(2)}";
    return text;
  }
}
