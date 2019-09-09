import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../models/product.dart';
import '../models/user.dart';
import '../models/auth.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _selProductId;
  bool _isLoading = false;
}

mixin ProductsModel on ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get allproducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  String get selectedProductId {
    return _selProductId;
  }

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }
    return _products.firstWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Future<bool> addProduct(
      String title, String description, String image, double price) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://i0.wp.com/www.royalbeans.in/wp-content/uploads/2017/09/Roasted-Almond-Milk-Chocolate-Bar-Royal-Beans-Chocolates.jpg?fit=2223%2C3000&ssl=1',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    try {
      final http.Response response = await http.post(
          'https://fllutter-products.firebaseio.com/products.json?auth=${_authenticatedUser.token}',
          body: json.encode(productData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> product = {
      'title': title,
      'description': description,
      'image':
          'https://i0.wp.com/www.royalbeans.in/wp-content/uploads/2017/09/Roasted-Almond-Milk-Chocolate-Bar-Royal-Beans-Chocolates.jpg?fit=2223%2C3000&ssl=1',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    return http
        .put(
            'https://fllutter-products.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}',
            body: json.encode(product))
        .then((_) {
      _isLoading = false;
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProduct = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();
    http
        .delete(
            'https://fllutter-products.firebaseio.com/products/${deletedProduct}.json?auth=${_authenticatedUser.token}')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        price: selectedProduct.price,
        description: selectedProduct.description,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
    _selProductId = null;
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    //notifyListeners();
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http
        .get(
            'https://fllutter-products.firebaseio.com/products.json?auth=${_authenticatedUser.token}')
        .then<Null>((http.Response response) {
      final List<Product> fetchedproductList = [];
      Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      productListData.forEach((String key, dynamic product) {
        final Product fetchProdcut = Product(
            title: product['title'],
            description: product['description'],
            id: key,
            image: product['image'],
            price: product['price'],
            userEmail: product['userEmail'],
            userId: product['userId']);
        fetchedproductList.add(fetchProdcut);
        _products = fetchedproductList;
        _isLoading = false;
        notifyListeners();
        _selProductId = null;
      });
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }
}

mixin UserModel on ConnectedProductsModel {
  Timer _authTimer;
  User get user{
    return _authenticatedUser;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode authMode]) async {
    _isLoading = true;
    notifyListeners();

    http.Response response;

    final Map<String, dynamic> _authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    if (authMode == AuthMode.Login) {
      String url =
          'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDuN170JOVPweQylyt4oY770upWIUMd9ls';
      response = await http.post(url,
          body: json.encode(_authData),
          headers: {'Content-Type': 'application/json'});
    } else {
      String url =
          'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDuN170JOVPweQylyt4oY770upWIUMd9ls';
      response = await http.post(url,
          body: json.encode(_authData),
          headers: {'Content-Type': 'application/json'});
    }

    print(json.decode(response.body));

    bool hasError = true;

    String message = "Something went wrong!";
    Map<String, dynamic> responseData = json.decode(response.body);
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded';
      
      _authenticatedUser = User(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken']);
          setAuthTimeOut(int.parse(responseData['expiresIn']));
          DateTime now = DateTime.now();
          DateTime expiryTime = now.add(Duration(seconds: int.parse(responseData['expiresIn'])));

          final SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString('token', responseData['idToken']);
          pref.setString('userEmail', email);
          pref.setString('userId', responseData['localId']);
          pref.setString('expiryTime', expiryTime.toIso8601String());


    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      hasError = true;
      message = 'Email has already exists!';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      hasError = true;
      message = 'Email has not found!';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      hasError = true;
      message = 'The password is invalid!';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate () async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token= prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');

    if(token!= null){
        final DateTime now = DateTime.now();
        final DateTime parseExpiryTime = DateTime.parse(expiryTimeString);

        if(parseExpiryTime.isBefore(now)){
          _authenticatedUser =null;
          notifyListeners(); 
          return ;
        }

        String userEmail = prefs.getString('userEmail');
        String localId= prefs.getString('userId');
        int tokenLifeSpan = parseExpiryTime.difference(now).inSeconds;
        _authenticatedUser = User(id: localId,email: userEmail,token: token);
        setAuthTimeOut(tokenLifeSpan);
        notifyListeners(); 
    }
  }
  void logout() async {
    print('logout');
    _authenticatedUser = null;
    _authTimer.cancel();
    final SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
  }
  void setAuthTimeOut(int time){
    _authTimer = Timer(Duration(milliseconds: time*5),logout);
  }
}

mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }

  void setLoading(bool loadingStatus) {
    _isLoading = loadingStatus;
    notifyListeners();
  }
}
