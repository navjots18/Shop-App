import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minor/providers/allProducts.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _isSaved = false;
  var editedProduct =
      Product(title: '', id: null, price: 0, description: '', imageUrl: '');
  void dispose() {
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (!_form.currentState.validate()) return;
    _form.currentState.save();
    setState(() {
      _isSaved = true;
    });
    try {
      await Provider.of<AllProducts>(context, listen: false)
          .addProduct(editedProduct);
    } catch (error) {
      print(error.toString());
      await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Error'),
                content: Text('there was some error'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Okay'))
                ],
              ));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: _isSaved
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter a title';
                          return null;
                        },
                        onSaved: (value) {
                          editedProduct = Product(
                              title: value,
                              description: editedProduct.description,
                              price: editedProduct.price,
                              id: editedProduct.id,
                              imageUrl: editedProduct.imageUrl);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter a price';
                          if (double.tryParse(value) == null)
                            return 'please enter a valid number';
                          return null;
                        },
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          editedProduct = Product(
                              title: editedProduct.title,
                              description: editedProduct.description,
                              price: double.parse(value),
                              id: editedProduct.id,
                              imageUrl: editedProduct.imageUrl);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter a desciption';
                          return null;
                        },
                        focusNode: _descriptionFocusNode,
                        keyboardType: TextInputType.multiline,
                        onSaved: (value) {
                          editedProduct = Product(
                              title: editedProduct.title,
                              description: value,
                              price: editedProduct.price,
                              id: editedProduct.id,
                              imageUrl: editedProduct.imageUrl);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              controller: _imageUrlController,
                              validator: (value) {
                                if (value.isEmpty) return 'Please enter a Url';
                                return null;
                              },
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onSaved: (value) {
                                editedProduct = Product(
                                    title: editedProduct.title,
                                    description: editedProduct.description,
                                    price: editedProduct.price,
                                    id: editedProduct.id,
                                    imageUrl: value);
                              },
                            ),
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter Url')
                                : Image.network(_imageUrlController.text),
                          )
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
