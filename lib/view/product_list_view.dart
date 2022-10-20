import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/DB/db_helper.dart';
import 'package:shopping_cart/model/cart_model.dart';
import 'package:shopping_cart/view_model/cart_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'cart_products_list.dart';
class ProductListView extends StatefulWidget {
  const ProductListView({Key? key}) : super(key: key);

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  List<String> productName = ['Mango' , 'Orange' , 'Grapes' , 'Banana' , 'Chery' , 'Peach','Mixed Fruit Basket',] ;
  List<String> productUnit = ['KG' , 'Dozen' , 'KG' , 'Dozen' , 'KG' , 'KG','KG',] ;
  List<int> productPrice = [10, 20 , 30 , 40 , 50, 60 , 70 ] ;
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg' ,
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg' ,
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg' ,
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612' ,
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612' ,
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612' ,
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612' ,
  ] ;
  DbHelper? db=DbHelper();
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<CartProvider>(context);
    dynamic height=MediaQuery.of(context).size.height*1;
    dynamic width=MediaQuery.of(context).size.width*1;
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        centerTitle: true,
        elevation: 0,
        actions: [
          Center(
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CartProductList()));
              },
              child: Badge(
                child: Icon(Icons.shopping_cart),
                badgeContent: Consumer<CartProvider>(builder: (context,value,child){
                  return Text(value.getCounter().toString(),style: TextStyle(color: Colors.white),);
                }),
                animationDuration: Duration(milliseconds: 300),
              ),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width*0.04,),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: productName.length,
                  itemBuilder: (context,index){
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          height: height*0.1,
                          width: width*0.3,
                          child: Image.network(productImage[index],
                          fit: BoxFit.fitHeight,),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(productName[index].toString(),style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                              ),),
                              SizedBox(height: height*0.01,),
                              Text(productUnit[index]+'  '+r'$'+productPrice[index].toString(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500
                              ),),
                              Row(
                                children: [
                                  Spacer(),
                                  GestureDetector(
                                    onTap: (){
                                      db!.insert(CartModel(
                                          id: index,
                                          productId: index.toString(),
                                          productName: productName[index],
                                          productPrice: productPrice[index],
                                          quantity: 1,
                                          initialPrice: productPrice[index],
                                          unitTag: productUnit[index],
                                          productImage: productImage[index])
                                      ).then((value){
                                              print('Product Added to Cart');
                                              cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                              cart.addCounter();

                                      }).onError((error, stackTrace) {
                                      });
                                    },
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxHeight: double.infinity,
                                        maxWidth: double.infinity,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text('Add to cart',
                                        style: TextStyle(
                                          color: Colors.white
                                        ),),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })
          ),
        ],
      ),
    );
  }
}
