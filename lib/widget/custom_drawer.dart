import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  Widget _buildDrawerBack() => Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color.fromARGB(255, 203, 236, 241), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
      );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32, top: 16),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.fromLTRB(0, 16, 16, 8),
                height: 170,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8,
                      left: 0,
                      child: Text(
                        "Flutter's\nClothings",
                        style: TextStyle(
                            fontSize: 34, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Olá,',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          GestureDetector(
                            onTap: () {},
                            child: Text('Entre ou Cadastre-se',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, "Inicio"),
              DrawerTile(Icons.list, "Produtos"),
              DrawerTile(Icons.location_on, "Lojas"),
              DrawerTile(Icons.playlist_add_check, "Meus Pedidos"),
            ],
          )
        ],
      ),
    );
  }
}
