import 'package:flutter/material.dart';
import '../providers/orders.dart';
import 'package:intl/intl.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem userOrder;

  OrderItemWidget(this.userOrder);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              widget.userOrder.amount.toString(),
            ),
            subtitle:
                Text(DateFormat.MMMMEEEEd().format(widget.userOrder.dateTime)),
            trailing: IconButton(
              icon: Icon(_isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          AnimatedContainer(
           duration: Duration(milliseconds: 300),
            height: _isExpanded? widget.userOrder.products.length * 25.0 + 10: 0,
            child: ListView.builder(
              itemBuilder: (cntx, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(widget.userOrder.products[index].title),
                    Text('${widget.userOrder.products[index].quantity}x\$${widget.userOrder.products[index].price}')
                  ],
                );
              },
              itemCount: widget.userOrder.products.length,
            ),
          )
        ],
      ),
    );
  }
}
