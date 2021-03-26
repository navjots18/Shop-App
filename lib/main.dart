import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:minor/providers/allProducts.dart';
import 'package:minor/screens/cart_screen.dart';
import 'package:minor/screens/editProduct_screen.dart';
import 'package:minor/screens/orders_screen.dart';
import 'package:minor/screens/splash_screen.dart';
import 'package:minor/screens/userProducts_screen.dart';
import './screens/products_screen.dart';
import './providers/auth.dart';
import './screens/productDetail_screen.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, AllProducts>(
            create: null,
            update: (ctx, auth, previousValue) => AllProducts(auth.token,
                auth.userId, previousValue == null ? [] : previousValue.items)),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: null,
            update: (ctx, auth, previousValue) => Orders(
                auth.token,
                auth.userId,
                previousValue == null ? [] : previousValue.orders)),
      ],
      child: MaterialApp(
        title: 'Shop App',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            ),
        home: MyHomePage(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);

    return Container(
      child: authData.isAuth
          ? ProductsScreen()
          : FutureBuilder(
            future: authData.tryAutoLogin(),
              builder: (ctx, result) =>
                  result.connectionState == ConnectionState.waiting
                      ? SplashScreen()
                      : AuthScreen()),
    );
  }
}
