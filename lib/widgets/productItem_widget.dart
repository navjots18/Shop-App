import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minor/providers/auth.dart';
import '../providers/product.dart';
import 'package:minor/screens/productDetail_screen.dart';
import '../providers/cart.dart';

class ProductItemWidget extends StatelessWidget {
  ProductItemWidget();
  @override
  Widget build(BuildContext context) {
    final productItem = Provider.of<Product>(context);
    var token = Provider.of<Auth>(context).token;
    var userId = Provider.of<Auth>(context).userId;
    var cart = Provider.of<Cart>(context);
    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
              arguments: productItem.id);
        },
        child: Hero(
          tag: productItem.id,
          child: FadeInImage(
            placeholder: AssetImage('assets/images/product-placeholder.png'),
            image: NetworkImage(productItem.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        leading: IconButton(
            icon: productItem.favourite
                ? Icon(Icons.favorite)
                : Icon(Icons.favorite_border),
            onPressed: () {
              productItem.toggleFav(token, userId);
            }),
        title: Text(
          productItem.title,
          style: TextStyle(color: Colors.white),
        ),
        trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              final snackBar = SnackBar(
                content: Text('Item Added!'),
                duration: Duration(seconds: 2),
              );
              Scaffold.of(context).showSnackBar(snackBar);
              cart.addItem(
                  productItem.id, productItem.title, productItem.price);
            }),
      ),
    );
  }
}
