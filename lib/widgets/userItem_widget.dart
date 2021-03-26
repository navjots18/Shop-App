import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minor/providers/allProducts.dart';

class UserItemWidget extends StatelessWidget {
  final title;
  final imageUrl;
  final id;

  UserItemWidget(this.id,this.title,this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final removeItem = Provider.of<AllProducts>(context).removeProduct;
    return ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl),),
        title: Text(title),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
           // IconButton(onPressed: (){}, icon: Icon(Icons.edit,color: Colors.teal,)),
            IconButton(onPressed: (){
              removeItem(id);
            }, icon: Icon(Icons.delete,color: Colors.red,))
          ],
        ),
    );
  }
}