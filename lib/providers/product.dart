import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool favourite;

  Product(
      {this.id,
      this.title,
      this.description,
      this.imageUrl,
      this.price,
      this.favourite = false});

  Future<void> toggleFav(String token,String userId) async {
    if (favourite)
      favourite = false;
    else
      favourite = true;
    notifyListeners();
try{
    final url = 'https://flutter-d07fe.firebaseio.com/users/$userId/$id.json?auth=$token';
    print('ss');
    await put(url,body: json.encode(favourite));
    print('dd');
  }catch(error)
  {
    print(error.toString());
  }
  }
}
