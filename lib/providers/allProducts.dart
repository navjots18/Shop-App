import 'dart:convert';

import 'package:flutter/material.dart';
import './product.dart';
import 'package:http/http.dart';

class AllProducts with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
 
  String authToken;
  String userId;
  AllProducts(this.authToken,this.userId,this._items);
  Product findProductById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<Product> get favItems {
    return _items.where((element) {
      print(element.favourite);
      return element.favourite;
    }).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchProducts([bool fetchAllProducts = true]) async {
var url;
fetchAllProducts? url = 'https://minor-c9c96-default-rtdb.firebaseio.com/products.json?auth=$authToken' :
     url = 'https://minor-c9c96-default-rtdb.firebaseio.com/products.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"';
    final favUrl = 'https://minor-c9c96-default-rtdb.firebaseio.com/users/$userId.json?auth=$authToken';
    print('x');
    print(userId);
    print('y');
    try {
      final response = await get(url);
      final fetchedData = json.decode(response.body) as Map<String, dynamic>;
      final favResponse = await get(favUrl);
      print(json.decode(response.body));
      final favFetchedData = json.decode(favResponse.body) as Map<String,dynamic>;
      print('s');
      List<Product> loadedProducts = [];
      fetchedData.forEach((key, value) {
        loadedProducts.add(Product(
          description: value['description'],
          id: key,
          imageUrl: value['imageUrl'],
          price: value['price'],
          title: value['title'],
          favourite:favFetchedData==null?false: favFetchedData[key] ?? false,
        ));
      });
     _items = loadedProducts;
     print('z');
     print(loadedProducts.length);
     print('w');
      notifyListeners();
    } catch (error) {
      print(error.toString()+'aaa');
    }
  }

  Future<void> addProduct(Product product) async {
    final url = 'https://minor-c9c96-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId':userId,
          }));

      Product newProduct = Product(
          description: product.description,
          imageUrl: product.imageUrl,
          id: json.decode(response.body)['name'],
          price: product.price,
          title: product.title);
      _items.add(newProduct);
    } catch (error) {
      print(error.toString());
      throw error;
    }
    notifyListeners();
  }

  void removeProduct(String id) {
    var url = 'https://minor-c9c96-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      delete(url);
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
