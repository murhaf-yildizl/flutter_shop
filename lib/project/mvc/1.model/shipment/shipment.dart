import '../customer/User.dart';
import '../order/order.dart';

class Shipment{
  late int shipment_id;
  late User  user;
  late Order order;
  late int payment_id;
  late String status;
  late String date;

  Shipment(this.shipment_id, this.user, this.order, this.payment_id,
      this.status, this.date);

  Shipment.fromJson(Map<String,dynamic>map){
    this.shipment_id=map['shipment_id'];
    this.user=User.fromJson(map['user']);
    this.order=Order.fromJson(map['order']);
    this.status=map['status'];
    this.date=map['date'];


  }

  static Map<String,dynamic>toJson(Shipment shipment)
  {
    return {
      'user_id':shipment.user.user_id,
      'order_id':shipment.order.order_id,
      'payment_id':shipment.payment_id,
    };
  }
}