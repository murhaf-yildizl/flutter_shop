part of 'cart_bloc.dart';

@immutable
 abstract class CartEvent {
          }

class GetCartEvent extends CartEvent{

}

class AddToCartEvent extends CartEvent{
  int product_id;
  double qnty=1;
  Option options;

  AddToCartEvent(this.product_id,this.qnty,this.options);
}
class RemoveFromCartEvent extends CartEvent{
       int item_id;

       RemoveFromCartEvent(this.item_id);
}
class DeleteItemEvent extends CartEvent{
  int product_id;

  DeleteItemEvent(this.product_id);
}
