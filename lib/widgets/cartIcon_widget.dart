import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/cart_screen.dart';
import '../providers/cart.dart';

class CartIcon extends StatelessWidget {
  
 

  @override
  Widget build(BuildContext context) {
     var value = Provider.of<Cart>(context).noOfItems().toString();
    return Stack(children: <Widget>[
      IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){
            Navigator.of(context).pushNamed(CartScreen.routeName);
      },),
     Positioned(
    right: 8,
    top: 8,
    child: Container(
      padding: EdgeInsets.all(2.0),
      // color: Theme.of(context).accentColor,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.red,
      ),
      constraints: BoxConstraints(
        minWidth: 16,
        minHeight: 16,
      ),
      child: Text(
         value, 
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10,
        ),
      ),
    ),
        ) 


    ],
               
    );
  }
}
