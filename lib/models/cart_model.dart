import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  List<CartProduct> products = [];
  UserModel user;
  bool isLoading = false;

  String cupomCode;
  int discountPercenter = 0;

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  CartModel(this.user) {
    if (user.isLoggedIn()) _loadData();
  }

  void addCartItem(CartProduct product) {
    products.add(product);
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .add(product.toMap())
        .then((doc) {
      product.cId = doc.documentID;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct product) {
    Firestore.instance
        .collection('user')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(product.cId)
        .delete();

    products.remove(product);
    notifyListeners();
  }

  void incProduct(CartProduct product) {
    product.quantity++;

    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(product.cId)
        .updateData(product.toMap());

    notifyListeners();
  }

  void decProduct(CartProduct product) {
    product.quantity--;
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(product.cId)
        .updateData(product.toMap());

    notifyListeners();
  }

  void setCoupom(String c, int i) {
    this.cupomCode = c;
    this.discountPercenter = i;
  }

  void _loadData() async {
    QuerySnapshot query = await Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .getDocuments();

    products =
        query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0.0;
    for (CartProduct c in products)
      if (c.productData != null) price += (c.quantity * c.productData.price);

    return price;
  }

  double getProductsDiscount() {
    return getProductsPrice() * discountPercenter / 100;
  }

  double getShipPrice() {
    return 9.99;
  }

  void updatePrices(){
    notifyListeners();
  }

  Future<String> finishedOrder() async{
    if(products.length == 0) return null;
    isLoading = true;
    notifyListeners();
    double productPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getProductsDiscount();

    DocumentReference ref = await Firestore.instance.collection('orders').add(
      {
        'cliente': user.firebaseUser.uid,
        'products': products.map((p)=> CartProduct().toMap()).toList(),
        'ship': shipPrice,
        'price': productPrice,
        'discount': discount,
        'total': productPrice+shipPrice-discount,
        'status': 1
      }
    );

    await Firestore.instance.collection('user').document(user.firebaseUser.uid).collection('ordesr').document(ref.documentID).setData({
      'orderId': ref.documentID
    });

    QuerySnapshot query = await Firestore.instance.collection('user').document(user.firebaseUser.uid).collection('cart').getDocuments();
    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }

    products.clear();
    discountPercenter = 0;
    cupomCode = null;
    notifyListeners();

    return ref.documentID;
  }
}
