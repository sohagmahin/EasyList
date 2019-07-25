import 'package:flutter/material.dart';
import './product_edit.dart';

class productListPage extends StatelessWidget {
  List<Map<String, dynamic>> _products;
  final Function updateProduct;
  productListPage(this._products, this.updateProduct);

  @override
  Widget build(BuildContext context) {
    // return Center(child: Image.asset(_products[0]['image']),);
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(_products[index]['image']),
              ),
              subtitle: Text('\$${_products[index]['price']}'),
              title: Text(_products[index]['title']),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => productEdit(
                            product: _products[index],
                            updateProduct: updateProduct,
                            productIndex: index,
                          )));
                },
              ),
            ),
            Divider()
          ],
        );
      },
      itemCount: _products.length,
    );
  }
}
