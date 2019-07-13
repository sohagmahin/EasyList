import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './product_card.dart';

class product extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  product(this.products);
  Widget _buildProductList() {
    Widget productCard;
    if (products.length > 0) {
      productCard = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            product_card(products[index], index),
        itemCount: products.length,
      );
    } else {
      productCard =
          Center(child: Text("Not found any products. Please add some!"));
    }
    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _buildProductList();
  }
}
