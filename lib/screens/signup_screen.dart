import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _nameControler = TextEditingController();
  final _emaipControler = TextEditingController();
  final _passControler = TextEditingController();
  final _endControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Entrar'), centerTitle: true),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading)
            return Center(child: CircularProgressIndicator());
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                TextFormField(
                  controller: _nameControler,
                  decoration: InputDecoration(hintText: "Nome"),
                  validator: (text) {
                    if (text.isEmpty) return "Nome inválido!";
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emaipControler,
                  decoration: InputDecoration(hintText: "E-mail"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text.isEmpty ||
                        !text.contains('@') ||
                        !text.contains(".com")) return "E-mail inválido!";
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passControler,
                  decoration: InputDecoration(
                    hintText: "Senha",
                  ),
                  obscureText: true,
                  validator: (text) {
                    if (text.isEmpty) return "Senha inválida!";
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _endControler,
                  decoration: InputDecoration(hintText: "Endereço"),
                  validator: (text) {
                    if (text.isEmpty) return "Endereço inválido!";
                  },
                ),
                SizedBox(height: 16),
                SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    child: Text('Criar Conta', style: TextStyle(fontSize: 18)),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Map<String, dynamic> userData = {
                          "name": _nameControler.text,
                          "email": _emaipControler.text,
                          "address": _endControler.text
                        };
                        model.singUp(
                            userData: userData,
                            pass: _passControler.text,
                            onSuccess: _onSuccess,
                            onFail: _onfail);
                      }
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onSuccess() async {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Usuario Criado com Sucesso"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2),
    ));

    Future.delayed(Duration(seconds: 2)).then((_)=>Navigator.of(context).pop());
  }

  void _onfail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Falha ao Criar o Usuárioi'),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
