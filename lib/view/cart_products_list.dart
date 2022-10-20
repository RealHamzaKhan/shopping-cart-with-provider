import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/DB/db_helper.dart';

import '../model/cart_model.dart';
import '../view_model/cart_provider.dart';
class CartProductList extends StatefulWidget {
  const CartProductList({Key? key}) : super(key: key);

  @override
  State<CartProductList> createState() => _CartProductListState();
}

class _CartProductListState extends State<CartProductList> {
  DbHelper db=DbHelper();
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<CartProvider>(context);
    dynamic height=MediaQuery.of(context).size.height*1;
    dynamic width=MediaQuery.of(context).size.width*1;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
        centerTitle: true,
        elevation: 0,
        actions: [
          Center(
            child: GestureDetector(
              onTap: (){
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
              child:FutureBuilder(
                  future: cart.getData(),
                  builder: (context,AsyncSnapshot<List<CartModel>> snapshot){
                if(snapshot.hasData){
                  if(snapshot.data!.isEmpty){
                    return Center(
                      child: Text('CART IS EMPTY',style: Theme.of(context).textTheme.headline3,),
                    );
                  }
                  else{
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
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
                                    child: Image.network(snapshot.data![index].productImage.toString(),
                                      fit: BoxFit.fitHeight,),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(snapshot.data![index].productName.toString(),style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600
                                            ),),
                                            GestureDetector(
                                                onTap: (){
                                                  db.delete(snapshot.data![index].id!);
                                                  cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                                  cart.removeCounter();
                                                },
                                                child: Icon(Icons.delete)),
                                          ],
                                        ),
                                        SizedBox(height: height*0.01,),
                                        Text(snapshot.data![index].unitTag.toString()+'  '+r'$'+snapshot.data![index].productPrice.toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500
                                          ),),
                                        Row(
                                          children: [
                                            Spacer(),
                                            GestureDetector(
                                              onTap: (){

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
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      GestureDetector(
                                                          onTap: (){
                                                            int quantity=snapshot.data![index].quantity!;
                                                            int price=snapshot.data![index].initialPrice!;
                                                            quantity--;
                                                            int? newPrice=quantity*price;
                                                            if(quantity>0){
                                                              db.updateQuantity(CartModel(
                                                                id: snapshot.data![index].id,
                                                                productId: snapshot.data![index].productId,
                                                                productName: snapshot.data![index].productName,
                                                                productPrice: newPrice,
                                                                quantity: quantity,
                                                                initialPrice:snapshot.data![index].initialPrice,
                                                                unitTag: snapshot.data![index].unitTag,
                                                                productImage:snapshot.data![index].productImage,
                                                              ),

                                                              ).then((value) {
                                                                newPrice=0;
                                                                quantity=0;
                                                                cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice.toString(),));
                                                              }).onError((error, stackTrace) {
                                                                print(error.toString());
                                                              });
                                                            }
                                                          },
                                                          child: Icon(Icons.remove,color: Colors.white,)),
                                                      SizedBox(width: width*0.05,),
                                                      Text(snapshot.data![index].quantity.toString(),
                                                        style: TextStyle(
                                                            color: Colors.white
                                                        ),),
                                                      SizedBox(width: width*0.05,),
                                                      GestureDetector(
                                                          onTap: (){
                                                            int quantity=snapshot.data![index].quantity!;
                                                            int price=snapshot.data![index].initialPrice!;
                                                            quantity++;
                                                            int? newPrice=quantity*price;
                                                            db.updateQuantity(CartModel(
                                                              id: snapshot.data![index].id,
                                                              productId: snapshot.data![index].productId,
                                                              productName: snapshot.data![index].productName,
                                                              productPrice: newPrice,
                                                              quantity: quantity,
                                                              initialPrice:snapshot.data![index].initialPrice,
                                                              unitTag: snapshot.data![index].unitTag,
                                                              productImage:snapshot.data![index].productImage,
                                                            ),

                                                            ).then((value) {
                                                              newPrice=0;
                                                              quantity=0;
                                                              cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice.toString(),));
                                                            }).onError((error, stackTrace) {
                                                              print(error.toString());
                                                            });
                                                          },
                                                          child: Icon(Icons.add,color: Colors.white,)),
                                                    ],
                                                  ),
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
                        });
                  }
                }
                else{
                  return Text('');
                }
              })
          ),
          Consumer<CartProvider>(builder: (context,value,child){
            return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2)=='0.00'?false:true,
                child: Column(
                  children: [
                    ReusableWidget(title: 'Sub Total', value: r'$ '+value.getTotalPrice().toString()),
                    ReusableWidget(title: 'Discount', value: r'$ '+"${value.getTotalPrice() * 15.0 / 100.0}"),
                    ReusableWidget(title: 'Net Total', value: r'$ '+"${value.getTotalPrice() - (value.getTotalPrice() * 15.0 / 100.0)}"),
                  ],
                ));
          })
        ],
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String value,title;
  ReusableWidget({required this.title,required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(title,style: Theme.of(context).textTheme.subtitle1),
          Text(value,style: Theme.of(context).textTheme.subtitle1,),
        ],
      ),
    );
  }
}
