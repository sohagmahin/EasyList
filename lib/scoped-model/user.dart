import '../models/user.dart';
import 'connected_products.dart';
mixin UserModel on ConnectedProduct{
  
  void login(String email,String password){
    authenticatedUser = User('sfdsfsd',email,password);
  }
}