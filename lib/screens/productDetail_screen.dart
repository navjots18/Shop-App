import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minor/providers/allProducts.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;

    final product = Provider.of<AllProducts>(context, listen: false)
        .findProductById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Hero(
              tag: product.id,
              child: Image.network(product.imageUrl),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              product.title,
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              '${product.price.toString()}\$',
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              product.description,
            )
          ],
        ),
      ),
    );
  }
}
