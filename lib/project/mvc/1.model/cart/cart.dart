import '../cartItem/cartitem.dart';

class Cart
{
 late int cartId;
 late double total;
 late String date;
 late int userId;
 late int checked;
 late int items_count;
 List<CartItem>itemsList=[];

  Cart(this.cartId, this.total, this.userId, this.checked,this.items_count);

  Cart.fromJson(Map<String,dynamic>map){
    this.cartId=map['cart_id'];
    this.total=double.parse(map['total'].toString());
    this.userId=map['user_id'];
    this.checked=map['checked'];
    this.itemsList=CartItem.map_toList(map['cart_items']);
    this.items_count=map['items_count'];

  }
}