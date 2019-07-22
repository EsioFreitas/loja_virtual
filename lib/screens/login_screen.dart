import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _passControler = TextEditingController();
  final _emaipControler = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Entrar'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              "CRIAR CONTA",
              style: TextStyle(fontSize: 15),
            ),
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Signup()));
            },
          )
        ],
      ),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                      onPressed: () {
                        if(_emaipControler.text.isEmpty)
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Insira seu email para recuperação'),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 2),
                          ));
                        else{
                          model.recoverPass(_emaipControler.text);
                          if(_emaipControler.text.isEmpty)
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text('Confira seu email'),
                              backgroundColor: Theme.of(context).primaryColor,
                              duration: Duration(seconds: 2),
                            ));
                        }

                      },
                      child: Text(
                        'Esqueci minha senha',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    child: Text('Entrar', style: TextStyle(fontSize: 18)),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {}
                      model.signIn(
                          email: _emaipControler.text,
                          pass: _passControler.text,
                          onSuccess: _onSuccess,
                          onFail: _onFail);
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

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Falha ao Entrar'),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
