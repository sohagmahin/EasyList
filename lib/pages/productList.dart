import 'package:flutter/material.dart';
import './product_edit.dart';
import '../models/product.dart';

class ProductListPage extends StatelessWidget {
  final List<Product> _products;
  final Function updateProduct;
  final Function deleteProduct;
  ProductListPage(this._products, this.updateProduct, this.deleteProduct);

  Widget _buildEditIconButton(BuildContext context, int index) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ProductEdit(
                  product: _products[index],
                  updateProduct: updateProduct,
                  productIndex: index,
                )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Center(child: Image.asset(_products[0]['image']),);
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(_products[index].title),
          background: Container(
            color: Colors.red,
          ),
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart) {
              deleteProduct(index);
            }
          },
          child: Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(_products[index].image),
                ),
                subtitle: Text('\$${_products[index].price.toString()}'),
                title: Text(_products[index].price.toString()),
                trailing: _buildEditIconButton(context, index),
              ),
              Divider()
            ],
          ),
        );
      },
      itemCount: _products.length,
    );
  }
}
