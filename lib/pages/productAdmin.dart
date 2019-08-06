import 'package:flutter/material.dart';
import '../pages/productList.dart';
import '../pages/product_edit.dart';

class ProductAdmin extends StatelessWidget {
  final Function addProduct;
  final Function deleteProduct;
  final Function updateProduct;
  final List<Map<String, dynamic>> _products;
  

  ProductAdmin(this.addProduct,this.updateProduct, this.deleteProduct, this._products);
  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.shop_two),
            title: Text('All Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/products');
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            drawer: _buildSideDrawer(context),
            appBar: AppBar(
              title: Text('Manage product'),
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.create),
                    text: 'Create Product',
                  ),
                  Tab(
                    icon: Icon(Icons.list),
                    text: 'My Products',
                  )
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                ProductEdit(addProduct: addProduct),
                ProductListPage(_products,updateProduct,deleteProduct)
              ],
            )));
  }
}
