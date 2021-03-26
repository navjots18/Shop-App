import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../widgets/orderItem_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var isLoading = true;
  void initState(){
    Provider.of<Orders>(context,listen: false).fetchOrders().then((_) => isLoading= false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var userOrder = Provider.of<Orders>(context).orders;
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body:isLoading?Center(child: CircularProgressIndicator(),): ListView.builder(
        itemBuilder: (ctx, i) {
          return OrderItemWidget(userOrder[i]);
        },
        itemCount: userOrder.length,
      ),
    );
  }
}


