import '../order/order.dart';

class Payment {
  late int payment_id;
  late double ammount;
  late String date;
  late int  user_id;
  late Order order;

  Payment(this.payment_id, this.ammount, this.date, this.user_id, this.order);

  Payment.fromJson(Map<String,dynamic>map)
  {
    this.payment_id=map['payment_id'];
    this.ammount=map['ammount'];
    this.date=map['date'];
    this.order=Order.fromJson(map['order']);
  }

  static Map<String,dynamic> toJson(Payment payment)
  {
    return {
      'ammount':payment.ammount,
      'date':payment.date,
      'user_id':payment.user_id,
      'order_id':payment.order.order_id
    };
  }

}