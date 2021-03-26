import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final String token;
  final String userId;
  List<OrderItem> _orders = [];
  Orders(this.token,this.userId,this._orders);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url = 'https://minor-c9c96-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
     try{
    final response = await get(url);
    print('khet');
    final fetchedData = json.decode(response.body) as Map<String, dynamic>;
    List<OrderItem> fetchedOrders = [];
    fetchedData.forEach((key, value) {
      fetchedOrders.add(OrderItem(
          id: key,
          amount: value['amount'],
          products: (value['products'] as List<dynamic>)
              .map((e) => CartItem(
                  id: e['id'],
                  price: e['price'],
                  quantity: e['quantity'],
                  title: e['title']))
              .toList(),
          dateTime: DateTime.parse(value['dateTime'])));
          _orders = fetchedOrders.reversed.toList();
          notifyListeners();
    });
     }catch(error)
     {
       print(error);
     }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://minor-c9c96-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
    final timeStamp = DateTime.now();
    final response = await post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'title': e.title,
                    'id': e.id,
                    'price': e.price,
                    'quantity': e.quantity
                  })
              .toList()
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
