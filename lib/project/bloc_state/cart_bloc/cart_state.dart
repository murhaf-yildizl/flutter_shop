part of 'cart_bloc.dart';

@immutable
abstract class CartState {}

class GetCartState extends CartState{
       Cart? cart;

      GetCartState(this.cart);
}

class AddToCartState extends CartState{}
class RemoveFromCartState extends CartState{

}
class DeleteCartState extends CartState{}

class CartErrorState extends CartState{
  String error;

  CartErrorState(this.error);
}


class CartIsLoadingState extends CartState{

}