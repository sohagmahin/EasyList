import 'package:flutter/material.dart';
import './product_edit.dart';

class productListPage extends StatelessWidget {
  List<Map<String, dynamic>> _products;
  productListPage(this._products);

  @override
  Widget build(BuildContext context) {
    // return Center(child: Image.asset(_products[0]['image']),);
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Image.asset(_products[index]['image']),
          title: Text(_products[index]['title']),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              productEdit(product: _products[index]);
            },
          ),
        );
      },
      itemCount: _products.length,
    );
  }
}
