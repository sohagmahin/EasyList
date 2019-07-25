import 'package:flutter/material.dart';
import '../widgets/helpers/ensure_visible.dart';

class productEdit extends StatefulWidget {
  Function addProduct;
  Function updateProduct;
  Map<String, dynamic> product;
  int productIndex;
  productEdit(
      {this.addProduct, this.updateProduct, this.product, this.productIndex});

  @override
  State<StatefulWidget> createState() {
    return _productEditState();
  }
}

class _productEditState extends State<productEdit> {
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

  Widget _buildTitleTextField() {
    return EnsureVisibleWhenFocused(
        focusNode: _titleFocusNode,
        child: TextFormField(
            focusNode: _titleFocusNode,
            decoration: InputDecoration(labelText: 'Product Title'),
            //autovalidate: true,
            initialValue: widget.product == null ? '' : widget.product['title'],
            validator: (String value) {
              if (value.isEmpty || value.length < 5) {
                return "Title is required and Should be 5+ characters long!";
              }
            },
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
            validator: (String value) {
              if (value.trim().length < 8) {
                return "Description is required and Should be 8+ characters long!";
              }
            },
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
            validator: (String value) {
              if (value.isEmpty ||
                  !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
                return "Price is required and should be number!";
              }
            },
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
                    // GestureDetector(
                    //   onTap: _submitForm,
                    //   child: Container(
                    //     color: Colors.red,
                    //     padding: EdgeInsets.all(10.0),
                    //     child: Text("My button"),
                    //   ),
                    // )
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
