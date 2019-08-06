import 'package:flutter/material.dart';
import '../widgets/helpers/ensure_visible.dart';

class ProductEdit extends StatefulWidget {
  final Function addProduct;
  final Function updateProduct;
  final Map<String, dynamic> product;
  final int productIndex;
  ProductEdit(
      {this.addProduct, this.updateProduct, this.product, this.productIndex});

  @override
  State<StatefulWidget> createState() {
    return _ProductEditState();
  }
}

class _ProductEditState extends State<ProductEdit> {
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

  Widget _buildTitleTextField() {
    return EnsureVisibleWhenFocused(
        focusNode: _titleFocusNode,
        child: TextFormField(
            focusNode: _titleFocusNode,
            decoration: InputDecoration(labelText: 'Product Title'),
            //autovalidate: true,
            initialValue: widget.product == null ? '' : widget.product['title'],
            validator: validatorTitle,
            onSaved: (String value) {
              _formData['title'] = value;
            }));
  }

  Widget _buildDescriptionTextField() {
    return EnsureVisibleWhenFocused(
        focusNode: _descriptionFocusNode,
        child: TextFormField(
            focusNode: _descriptionFocusNode,
            maxLines: 4,
            decoration: InputDecoration(labelText: 'Product Description'),
            initialValue:
                widget.product == null ? '' : widget.product['description'],
            validator: validatorDescription,
            onSaved: (String value) {
              _formData['description'] = value;
            }));
  }

  Widget _buildPriceTextField() {
    return EnsureVisibleWhenFocused(
        focusNode: _priceFocusNode,
        child: TextFormField(
            focusNode: _priceFocusNode,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Product Price'),
            initialValue: widget.product == null
                ? ''
                : widget.product['price'].toString(),
            validator: validatorPrice,
            onSaved: (String value) {
              _formData['price'] = double.parse(value);
            }));
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (widget.product == null) {
      widget.addProduct(_formData);
    } else if (widget.product != null) {
      widget.updateProduct(widget.productIndex, _formData);
    }
    Navigator.pushReplacementNamed(context, '/products');
  }

  Widget _buildPageContent(BuildContext context) {
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
                    _buildTitleTextField(),
                    _buildDescriptionTextField(),
                    _buildPriceTextField(),
                    SizedBox(height: 10.0),
                    RaisedButton(
                      child: Text(
                        'Save',
                      ),
                      textColor: Colors.white,
                      onPressed: _submitForm,
                    )
                  ],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    final Widget pageContent = _buildPageContent(context);

    return widget.product == null
        ? pageContent
        : Scaffold(
            appBar: AppBar(
              title: Text('Edit Product'),
            ),
            body: pageContent,
          );
  }
}
