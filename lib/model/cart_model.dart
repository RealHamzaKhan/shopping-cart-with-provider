class CartModel{
  late final int? id;
  final String? productId;
  final String? productName;
  final int? productPrice;
  final int? quantity;
  final int? initialPrice;
  final String? unitTag;
  final String? productImage;
  CartModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.initialPrice,
    required this.unitTag,
    required this.productImage,

});
  CartModel.fromMap(Map<dynamic,dynamic> res)
  : id=res['id'],
  productId=res['productId'],
  productName=res['productName'],
        productPrice=res['productPrice'],
        quantity=res['quantity'],
        initialPrice=res['initialPrice'],
        unitTag=res['unitTag'],
        productImage=res['productImage'];
  Map<String,Object?> toMap(){
    return {
      'id' :id,
      'productId':productId,
      'productName':productName,
      'productPrice':productPrice,
      'quantity':quantity,
      'initialPrice':initialPrice,
      'unitTag':unitTag,
      'productImage':productImage
    };
  }
}