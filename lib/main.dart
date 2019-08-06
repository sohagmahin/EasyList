import 'package:flutter/material.dart';
import './pages/productAdmin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './pages/auth.dart';

void main() {
  //debugPaintSizeEnabled=true;
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> _products = [];

  void _addProduct(Map<String, dynamic> product) {
    setState(() {
      _products.add(product);
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  void _updateProduct(int index,Map<String,dynamic>product){
    setState(() {
      _products[index]=product;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.deepPurple,
        buttonColor: Colors.purple
        // fontFamily: 'Oswald'
      ),
      //home: auth() ,
      routes: {
        '/': (BuildContext context) => Auth(),
        '/products': (BuildContext context) => ProductsPage(_products),
        '/admin': (BuildContext context) =>
            ProductAdmin(_addProduct,_updateProduct, _deleteProduct,_products)
      },
      onGenerateRoute: (RouteSettings setting) {
        final List<String> pathElement = setting.name.split('/');
        print(pathElement);
        if (pathElement[0] != '') {
          return null;
        }
        if (pathElement[1] == 'product') {
          final int index = int.parse(pathElement[2]);
          return MaterialPageRoute<bool>(
              builder: (BuildContext context) => ProductPages(
                  _products[index]['title'],
                  _products[index]['image'],
                  _products[index]['description'],
                  _products[index]['price']));
        }
        return null;
      },
      onUnknownRoute: (RouteSettings setting) {
        return MaterialPageRoute(
            builder: (BuildContext context) => ProductsPage(_products));
      },
    );
  }
}
