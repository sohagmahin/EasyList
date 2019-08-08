import 'package:flutter/material.dart';
import './pages/productAdmin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './pages/auth.dart';
import 'package:scoped_model/scoped_model.dart';
import './scoped-model/products.dart';

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
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ProductsModel>(
      model: ProductsModel(),
      child: MaterialApp(
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
          '/products': (BuildContext context) => ProductsPage(),
          '/admin': (BuildContext context) => ProductAdminPage()
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
              builder: (BuildContext context) =>
                  ProductPages(index),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings setting) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage());
        },
      ),
    );
  }
}
