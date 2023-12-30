import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shop/project/mvc/3.controller/cart/cart_controller.dart';
import 'package:shop/project/mvc/1.model/option/option.dart';
import '../../mvc/1.model/cart/cart.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
 Cart? cart;
    CartController cartRepository=CartRepo();

  CartBloc() : super(GetCartState(null)) {

    if(cart==null)
      emit(CartIsLoadingState());

    on<CartEvent>((event, emit)async {

      emit(CartIsLoadingState());

      if( event is GetCartEvent)
        {

           cart= await cartRepository.getCart();
           if(cart !=null)
           {
           print("count==========>>>>>>>>>  "+cart!.items_count.toString());
            emit(GetCartState(cart));
           }
        //  else emit(CartErrorState("no data")) ;
        }

 else if( event is AddToCartEvent)
      {

        await cartRepository.addToCart(event.product_id,event.qnty,event.options);
         add(GetCartEvent());
      }
 else if( event is RemoveFromCartEvent)
      {
      await  cartRepository.removeFromCart(event.item_id);

        add(GetCartEvent());

      }
 else if( event is DeleteItemEvent)
      {

        emit(CartIsLoadingState());

        await cartRepository.deleteProductCart(event.product_id).then((value) {});

        add(GetCartEvent());
      }

     });
  }
}
