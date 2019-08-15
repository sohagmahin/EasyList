import '../models/product.dart';
import 'connected_products.dart';

mixin ProductsModel on ConnectedProduct {
  
  bool _showFavorites=false;

  List<Product> get allproducts {
    return List.from(products);
  }

  List<Product> get displayedProducts {
    if(_showFavorites){
    return products.where((Product product)=>product.isFavorite).toList();
    }
    return List.from(products);
  }

  int get selectedProductIndex {
    return selProductIndex;
  }

  Product get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }
    return products[selectedProductIndex];
  }

  bool get displayFavoritesOnly{
    return _showFavorites;
  }

  void deleteProduct() {
    products.removeAt(selectedProductIndex);
    selProductIndex = null;
    notifyListeners();
  }

   void updateProduct(String title, String description, String image, double price) {
     final Product updatedProduct = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    products[selectedProductIndex] = updatedProduct;
    selProductIndex = null;
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
        products[selectedProductIndex]=updatedProduct;
        notifyListeners();
        selProductIndex=null;
  }

  void toggleDisplayMode(){
    _showFavorites=!_showFavorites;
    notifyListeners();
  }

  void selectProduct(int index) {
    selProductIndex = index;
    notifyListeners();
  }
}
