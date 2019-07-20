import 'package:flutter/material.dart';

class productCreate extends StatefulWidget {
  Function addProduct;
  Function deleteProduct;
  productCreate(this.addProduct, this.deleteProduct);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _productCreateState();
  }
}

class _productCreateState extends State<productCreate> {
  final Map<String,dynamic>_formData ={
    'title':null,
    'description':null,
    'price':null,
    'image': 'assets/food.jpg'
  };
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  Widget _buildTitleTextField() {
    return TextFormField(
        decoration: InputDecoration(labelText: 'Product Title'),
        //autovalidate: true,
        validator: (String value) {
          if (value.isEmpty || value.length < 5) {
            return "Title is required and Should be 5+ characters long!";
          }
        },
        onSaved: (String value) {
          _formData['title'] = value;
        });
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
        maxLines: 4,
        decoration: InputDecoration(labelText: 'Product Description'),
        validator: (String value) {
          if (value.trim().length < 8) {
            return "Description is required and Should be 8+ characters long!";
          }
        },
        onSaved: (String value) {
          _formData['description'] = value;
        });
  }

  Widget _buildPriceTextField() {
    return TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Product Price'),
        validator: (String value) {
          if (value.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
            return "Price is required and should be number!";
          }
        },
        onSaved: (String value) {
          _formData['price'] = double.parse(value);
        });
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    widget.addProduct(_formData);
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    print(targetPadding);

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
}
