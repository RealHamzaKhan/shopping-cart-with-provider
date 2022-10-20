import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart/DB/db_helper.dart';
import 'package:shopping_cart/model/cart_model.dart';

class CartProvider with ChangeNotifier{
  int _counter=0;
  double _totalPrice=0.0;
  int get counter=>_counter;
  double get totalPrice=>_totalPrice;
  late Future<List<CartModel>> _cart;
  Future<List<CartModel>> get cart=>_cart;
  DbHelper db=DbHelper();
  Future<List<CartModel>> getData()async{
    _cart=db.getCartData();
    return _cart;
  }
  void setPrefItems()async{
    SharedPreferences sp=await SharedPreferences.getInstance();
    sp.setInt('cart_item', _counter);
    sp.setDouble('total_price', _totalPrice);
    notifyListeners();
  }
  void getPrefItems()async{
    SharedPreferences sp=await SharedPreferences.getInstance();
    _counter=sp.getInt('cart_item')?? 0;
    _totalPrice=sp.getDouble('total_price')??0.0;
    notifyListeners();
  }
  void addTotalPrice(double productPrice){
    _totalPrice=_totalPrice+productPrice;
    setPrefItems();
    notifyListeners();
  }
  void removeTotalPrice(double productPrice){
    _totalPrice=_totalPrice-productPrice;
    setPrefItems();
    notifyListeners();
  }
  void addCounter(){
    _counter++;
    setPrefItems();
    notifyListeners();
  }
  void removeCounter(){
    if(_counter!=0){
      _counter--;
      setPrefItems();
      notifyListeners();
    }
  }
  int getCounter(){
    getPrefItems();
    return _counter;
  }
  double getTotalPrice(){
    getPrefItems();
    return _totalPrice;
  }

  void clearCart(){
    _totalPrice=0.0;
    _counter=0;
    setPrefItems();
    notifyListeners();
  }
}