import 'package:shop/project/mvc/1.model/product/Product.dart';

import '../option/option.dart';

class CartItem{

  late int id;
  late Product product;
  late double qnty;
  late Option options;

CartItem(this.product, this.qnty,this.id,this.options);

CartItem.fromJson(Map<String,dynamic>map)
{

  this.id=map['item_id'];
  this.product=Product.fromJson(map['products']);
  this.qnty=double.parse(map['qnty'].toString());

  if(map['options']!=null)
  this.options=Option.fromJson(map['options']);
}

 static List<CartItem> map_toList(var map)
{
  List<CartItem>list=[];

  map.forEach((element) {
     list.add(CartItem.fromJson(element));
  });

  return list;
}
}