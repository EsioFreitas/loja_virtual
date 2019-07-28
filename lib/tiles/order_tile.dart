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
                    Text(
                      "Código do pedido: ${snapshot.data.documentID}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(_buildProductText(snapshot.data)),
                    SizedBox(height: 4),
                    Text(
                      "Status do pedido: ${snapshot.data.documentID}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _buildCircle(
                            '1', 'Preparação', snapshot.data['status'], 1),
                        Container(
                          height: 1,
                          width: 40,
                          color: Colors.grey[500],
                        ),
                        _buildCircle(
                            '2', 'Transporte', snapshot.data['status'], 2),
                        _buildCircle('3', 'Entrega', snapshot.data['status'], 3)
                      ],
                    )
                  ],
                );
            }),
      ),
    );
  }

  String _buildProductText(DocumentSnapshot snapshot) {
    String text = "Descrição\n";
    for (LinkedHashMap p in snapshot.data['products']) {
      text +=
          "${p['quantity']} x ${p['product']['price'].toStringAsFixed(2)}\n";
    }

    text += "Total: R\$ ${snapshot.data['tootalPrice'].toStringAsFixed(2)}";
    return text;
  }

  Widget _buildCircle(
      String title, String subTitle, int status, int thisStatus) {
    Color back;
    Widget child;

    if (status < thisStatus) {
      back = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white));
    } else if (status == thisStatus) {
      back = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      back = Colors.green;
      child = Icon(Icons.check);
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20,
          backgroundColor: back,
          child: child,
        ),
        Text(subTitle)
      ],
    );
  }
}
