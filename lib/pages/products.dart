import 'package:flutter/material.dart';
import '../widgets/products/products.dart';

class ProductsPage extends StatelessWidget {
  final  List<Map<String, dynamic>> productsList;
  ProductsPage(this.productsList);
  
  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, '/admin'); //Used Name Route
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: new AppBar(
        title: new Text("Easy List"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {},
          )
        ],
      ),
      body: Product(productsList),
    );
  }
}
