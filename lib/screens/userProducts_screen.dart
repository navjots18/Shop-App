import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minor/providers/allProducts.dart';
import 'package:minor/screens/editProduct_screen.dart';
import '../widgets/userItem_widget.dart';


class UserProductScreen extends StatefulWidget {
  static const routeName = '/user-products';

  @override
  _UserProductScreenState createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
 var isLoading = true;
  @override
  void initState()
  {
     Provider.of<AllProducts>(context,listen:false).fetchProducts(false).then((_) => isLoading=false);
    super.initState();
  }
  Future<void> _refreshScreen  (BuildContext context) async
  {
    await Provider.of<AllProducts>(context,listen:false).fetchProducts(false);
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<AllProducts>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          FlatButton(onPressed: () {
            Navigator.of(context).pushNamed(EditProductScreen.routeName);
          }, child: const Icon(Icons.add,color: Colors.white,))
        ],
      ),
      body:isLoading?Center(child: CircularProgressIndicator(),): RefreshIndicator(
        onRefresh: ()=> _refreshScreen(context),
              child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(itemBuilder: (_,i){
            return UserItemWidget(productData[i].id ,productData[i].title,productData[i].imageUrl);
          },itemCount:productData.length ,),
        ),
      ),
    );
  }
}
