import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../models/user.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  User _authenticatedUser;
  int _selProductIndex;

  void addProduct(
      String title, String description, String image, double price) {
      final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://i0.wp.com/www.royalbeans.in/wp-content/uploads/2017/09/Roasted-Almond-Milk-Chocolate-Bar-Royal-Beans-Chocolates.jpg?fit=2223%2C3000&ssl=1',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    http
        .post('https://fllutter-products.firebaseio.com/products.json',
            body: json.encode(productData))
        .then((http.Response response) {
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
      //_products.add(newProduct);
      notifyListeners();
    });
  }
  void fetchProducts(){
    http.get('https://fllutter-products.firebaseio.com/products.json').then((http.Response response){
      final List<Product> fetchedproductList=[];
      Map<String,dynamic> fetchProductList= json.decode(response.body);
      fetchProductList.forEach((String key,dynamic product){
        final Product fetchProdcut= Product(
          title: product['title'],
          description: product['description'],
          id: key,
          image: product['image'],
          price: product['price'],
          userEmail: product['userEmail'],
          userId: product['userId']
        );
        fetchedproductList.add(fetchProdcut);
        _products=fetchedproductList;
        notifyListeners();
      });
    });
  }
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

  int get selectedProductIndex {
    return _selProductIndex;
  }

  Product get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }
    return _products[selectedProductIndex];
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }
  
  void deleteProduct() {
    _products.removeAt(selectedProductIndex);
    notifyListeners();
  }

  void updateProduct(
      String title, String description, String image, double price) {
    final Product updatedProduct = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
        title: selectedProduct.title,
        price: selectedProduct.price,
        description: selectedProduct.description,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
    _selProductIndex = null;
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }

  void selectProduct(int index) {
    _selProductIndex = index;
    notifyListeners();
  }
}

mixin UserModel on ConnectedProductsModel {
  void login(String email, String password) {
    _authenticatedUser = User('sfdsfsd', email, password);
  }
}
