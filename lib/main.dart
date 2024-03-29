import 'package:flutter/material.dart';
import './pages/productAdmin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './pages/auth.dart';
import './models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import './scoped-model/main.dart';

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
  final MainModel _model = MainModel();
  bool _isAuthenticate = false;
  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticate){
      setState(() {
        _isAuthenticate = isAuthenticate;
      });
      
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
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
          '/': (BuildContext context) => !_isAuthenticate ? AuthPage() : ProductsPage(_model),
          '/admin': (BuildContext context) => !_isAuthenticate ? AuthPage(): ProductAdminPage(_model)
        },
        onGenerateRoute: (RouteSettings setting) {
          if(!_isAuthenticate){
            return  MaterialPageRoute<bool>(
              builder: (BuildContext context) => AuthPage(),
            );
          }
          final List<String> pathElement = setting.name.split('/');
          print(pathElement);
          if (pathElement[0] != '') {
            return null;
          }
          if (pathElement[1] == 'product') {
            final String productId = pathElement[2];
            final Product product =
                _model.allproducts.firstWhere((Product product) {
              return product.id == productId;
            });
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) =>!_isAuthenticate ? AuthPage() : ProductPages(product),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings setting) {
          return MaterialPageRoute(
              builder: (BuildContext context) => !_isAuthenticate ? AuthPage() : ProductsPage(_model));
        },
      ),
    );
  }
}
