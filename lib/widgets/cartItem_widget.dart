import 'package:flutter/material.dart';

class CartItemWidget extends StatefulWidget {
  final item;
  final Function remove;
  CartItemWidget(this.item, this.remove);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.item.id),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Confirm'),
            content: const Text("Are you sure you wish to delete this item?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("DELETE")),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("CANCEL"),
              ),
            ],
          ),
        );
      },
      onDismissed: (dismissDirection) {
        widget.remove();
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 10),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            child: FittedBox(
              child: Text('${widget.item.price}\$'),
            ),
          ),
          title: Text(widget.item.title),
          trailing: Text(
            'x${widget.item.quantity}',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
