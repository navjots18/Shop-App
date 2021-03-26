import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minor/providers/auth.dart';
import 'package:minor/screens/orders_screen.dart';
import 'package:minor/screens/userProducts_screen.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hey There!'),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('shop'),
            onTap: (){
              Navigator.of(context).pushNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: (){
              Navigator.of(context).pushNamed(OrdersScreen.routeName);
            },
          ),
           ListTile(
            leading: Icon(Icons.person),
            title: Text('Your Products'),
            onTap: (){
              Navigator.of(context).pushNamed(UserProductScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context,listen:false).logout();
            }
          ),],
      ),
    );
  }
}
