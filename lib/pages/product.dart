import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import '../widgets/ui_elements/title_Default.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-model/products.dart';
import '../models/product.dart';

//single product page
class ProductPages extends StatelessWidget {
  final int productIndex;
  ProductPages(this.productIndex);

  _buildAddressPiceRow(BuildContext context,double priceTag) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Union Square, San Francisco',
          style: TextStyle(color: Colors.grey, fontFamily: 'Oswald'),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Text(
          '\$' + priceTag.toString(),
          style: TextStyle(color: Colors.grey, fontFamily: 'Oswald'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print("Back button pressed!");
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: ScopedModelDescendant<ProductsModel>(
        builder: (BuildContext context, Widget child, ProductsModel model) {
          final Product product= model.products[productIndex];
          return Scaffold(
            appBar: new AppBar(
              title: Text(product.title),
            ),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(product.image),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: TitleDefault(product.title),
                  ),
                  _buildAddressPiceRow(context,product.price),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      product.description,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
