import 'dart:io'as io;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shopping_cart/model/cart_model.dart';
class DbHelper{
  static Database? _db;
  Future<Database?> get db async{
    if(_db!=null){
      return _db!;
    }
    _db=await initDataBase();
  }
  initDataBase()async{
    io.Directory documentDirectory=await getApplicationDocumentsDirectory();
    String path=join(documentDirectory.path,'cart.db');
    var db=await openDatabase(path,version: 1,onCreate: _onCreate);
    return db;
    
  }
  _onCreate(Database db,int version)async{
    await db.execute(
      'CREATE TABLE cart(id INTEGER PRIMARY KEY,productId VARCHAR UNIQUE,productName TEXT,productPrice INTEGER,quantity INTEGER,initialPrice INTEGER,unitTag TEXT,productImage TEXT)'
    );
  }
  Future<CartModel> insert(CartModel cartModel)async{
    var dbClient=await db;
    dbClient!.insert('cart', cartModel.toMap());
    return cartModel;
  }
  Future<List<CartModel>> getCartData()async{
    var dbClient=await db;
    final List<Map<String,Object?>> queryResult=await dbClient!.query('cart');
    return queryResult.map((e) => CartModel.fromMap(e)).toList();
  }
  Future<int> delete(int id)async{
    var dbClient=await db;
    return dbClient!.delete('cart',
    where: 'id=?',
        whereArgs: [id]
    );
  }
  Future<int> updateQuantity(CartModel cart)async{
    var dbClient=await db;
    return dbClient!.update('cart',
        cart.toMap(),
        where: 'id=?',
        whereArgs: [cart.id]
    );
  }
}