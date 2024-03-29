import 'package:flutter/material.dart';
import '../widgets/helpers/ensure_visible.dart';
import '../models/product.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-model/main.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductEditState();
  }
}

class _ProductEditState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/food.jpg'
  };
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  String validatorTitle(String value) {
    return value.isEmpty || value.length < 5
        ? "Title is required and Should be 5+ characters long!"
        : null;
  }

  String validatorDescription(String value) {
    return value.trim().length < 8 || value.isEmpty
        ? "Description is required and Should be 8+ characters long!"
        : null;
  }

  String validatorPrice(String value) {
    return value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)
        ? "Price is required and should be number!"
        : null;
  }

  Widget _buildTitleTextField(Product product) {
    return EnsureVisibleWhenFocused(
        focusNode: _titleFocusNode,
        child: TextFormField(
            focusNode: _titleFocusNode,
            decoration: InputDecoration(labelText: 'Product Title'),
            //autovalidate: true,
            initialValue: product == null ? '' : product.title,
            validator: validatorTitle,
            onSaved: (String value) {
              _formData['title'] = value;
            }));
  }

  Widget _buildDescriptionTextField(Product product) {
    return EnsureVisibleWhenFocused(
        focusNode: _descriptionFocusNode,
        child: TextFormField(
            focusNode: _descriptionFocusNode,
            maxLines: 4,
            decoration: InputDecoration(labelText: 'Product Description'),
            initialValue: product == null ? '' : product.description,
            validator: validatorDescription,
            onSaved: (String value) {
              _formData['description'] = value;
            }));
  }

  Widget _buildPriceTextField(Product product) {
    return EnsureVisibleWhenFocused(
        focusNode: _priceFocusNode,
        child: TextFormField(
            focusNode: _priceFocusNode,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Product Price'),
            initialValue: product == null ? '' : product.price.toString(),
            validator: validatorPrice,
            onSaved: (String value) {
              _formData['price'] = double.parse(value);
            }));
  }

  void _submitForm(
      Function addProduct, Function updateProduct, Function setSelectedProduct,
      [int selectedProductIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (selectedProductIndex == -1) {
      addProduct(_formData['title'], _formData['description'],
              _formData['image'], _formData['price'])
          .then((bool success) {
        if (success) {
          return Navigator.pushReplacementNamed(context, '/products')
              .then((_) => setSelectedProduct(null));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Something went wrong'),
                  content: Text('Pleace try again!'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                );
              });
        }
        return true;
      });
    } else if (selectedProductIndex != null) {
      updateProduct(
        _formData['title'],
        _formData['description'],
        _formData['image'],
        _formData['price'],
      ).then((_) {
        return Navigator.pushReplacementNamed(context, '/products')
            .then((_) => setSelectedProduct(null));
      });
    }
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : RaisedButton(
                child: Text(
                  'Save',
                ),
                textColor: Colors.white,
                onPressed: () => _submitForm(
                    model.addProduct,
                    model.updateProduct,
                    model.selectProduct,
                    model.selectedProductIndex),
              );
      },
    );
  }

  Widget _buildPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
      onTap: () {
        //For disable keyboard.
        FocusScope.of(context).requestFocus(FocusNode());
      },
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
              children: <Widget>[
                _buildTitleTextField(product),
                _buildDescriptionTextField(product),
                _buildPriceTextField(product),
                SizedBox(height: 10.0),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedProduct);
        return model.selectedProductIndex == -1
            ? pageContent
            : Scaffold(
                  appBar: AppBar(
                    title: Text('Edit Product'),
                  ),
                  body: pageContent,
              );
      },
    );
  }
}
