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
  String titleValue = '';
  String descriptionValue;
  double priceValue;

  Widget _buildTitleTextField() {
    return TextField(
        decoration: InputDecoration(labelText: 'Product Title'),
        onChanged: (String value) {
          setState(() {
            titleValue = value;
          });
        });
  }

  Widget _buildDescriptionTextField() {
    return TextField(
        maxLines: 4,
        decoration: InputDecoration(labelText: 'Product Description'),
        onChanged: (String value) {
          setState(() {
            descriptionValue = value;
          });
        });
  }

  Widget _buildPriceTextField() {
    return TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Product Price'),
        onChanged: (String value) {
          setState(() {
            priceValue = double.parse(value);
          });
        });
  }

  void _submitForm() {
    Map<String, dynamic> products = {
      'title': titleValue,
      'description': descriptionValue,
      'price': priceValue,
      'image': 'assets/food.jpg'
    };
    widget.addProduct(products);
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    print(targetPadding);

    return Container(
        margin: EdgeInsets.all(10.0),
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
        ));
  }
}
