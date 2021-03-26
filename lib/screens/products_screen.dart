import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minor/providers/allProducts.dart';
import 'package:minor/screens/cart_screen.dart';
import 'package:minor/widgets/drawer_widget.dart';
import '../widgets/cartIcon_widget.dart';
import '../widgets/productItem_widget.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  var _showFav = false;
  var isLoading = true;
  void initState() {
    
    Provider.of<AllProducts>(context, listen: false)
        .fetchProducts()
        .then((_) => isLoading = false);
    super.initState();
  }

  void _selectedOption(int i) {
    setState(() {
      if (i == 0)
        _showFav = true;
      else
        _showFav = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var productData = Provider.of<AllProducts>(context);
    var loadedProducts = _showFav ? productData.favItems : productData.items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Show Favourites'),
                value: 0,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: 1,
              ),
            ],
            onSelected: _selectedOption,
          ),
          CartIcon()
        ],
      ),
      drawer: DrawerWidget(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: loadedProducts.length,
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: loadedProducts[i], child: ProductItemWidget()),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20),
            ),
    );
  }
}
