import 'package:flutter/cupertino.dart';

class CartItem {
  @required
  String id;
  @required
  double price;
  @required
  int quantity;
  @required
  String title;

  CartItem({this.id, this.price, this.title, this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItems = {
  };

  Map<String, CartItem> get cartItems {
    return {..._cartItems};
  }
  void clearCart()
  {
     print(_cartItems.toString());
    _cartItems = {};
    notifyListeners();
  }
double get totalPrice{
  double total = 0.0;
  _cartItems.forEach((key, value) { 
    total+=value.price * value.quantity;
  });
  return total;
}

  int noOfItems()
  {
    return _cartItems.length;
  }
  void removeItem(String id)
  {
    _cartItems.removeWhere((key, value) => value.id==id);
    notifyListeners();
  }
  void addItem(String productId, String title, double price) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (value) => CartItem(
              id: value.id,
              price: value.price,
              title: value.title,
              quantity: value.quantity + 1));
    } else {
      _cartItems.putIfAbsent(
          productId,
          () => CartItem(
              title: title,
              id: DateTime.now().toString(),
              quantity: 1,
              price: price));
    }
    
    notifyListeners();
  }
}
