import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/cartItem_widget.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  
  @override
  Widget build(BuildContext context) {
    final userCart = Provider.of<Cart>(context);
    final totalPrice = userCart.totalPrice;
    final allItems = userCart.cartItems;
    final orderNow = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(10),
            elevation: 5,
            color: Theme.of(context).accentColor,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total'),
                  Text(totalPrice.toStringAsFixed(2)),
                  RaisedButton(
                    onPressed:totalPrice<=0?null: () {
                      orderNow.addOrder(allItems.values.toList(), totalPrice);
                      userCart.clearCart();
                    },
                    child: Text(
                      'order now',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (ctx, i) {
              
              return CartItemWidget(allItems.values.toList()[i], ()=>userCart.removeItem(allItems.values.toList()[i].id));
            },
            itemCount: allItems.length,
          )
        ],
      ),
    );
  }
}
