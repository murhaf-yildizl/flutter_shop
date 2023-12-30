import '../cart/cart.dart';
import '../customer/User.dart';

class Order {
  late int order_id;
  late String date;
  late User user;
  late Cart cart;

  Order(this.order_id, this.date, this.user, this.cart);

  Order.fromJson(Map<String,dynamic>map){
    this.order_id=map['order_id'];
    this.date=map['date'];
    this.user=User.fromJson(map['user']);
    this.cart=Cart.fromJson(map['cart']);
  }

  static Map<String,dynamic> toJson(Order order)
  {
    return {
       'user_id':order.user.user_id,
        'cart_id':order.cart.cartId
    };

  }

}