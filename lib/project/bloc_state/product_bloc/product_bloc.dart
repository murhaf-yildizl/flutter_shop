import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shop/project/mvc/3.controller/product/product_controller.dart';

import '../../mvc/1.model/product/Product.dart';

part 'product_event.dart';
part 'product_state.dart';


class ProductBloc extends Bloc<ProductEvent, ProductState> {
   List <Product>products=[];
   List <Product>randomList=[];

   ProductController _productReposiory=ProductController();
   int page=1;
    bool finish=false;

    ProductBloc() : super(ProductsLoadingState()) {
    on<ProductEvent>((event, emit) async {
      // TODO: implement event handler

      if(event is GetProductsEvent && !finish  && event.category_id>=0)
      {
        if(page==1)
         {
            products=[];
         }

         emit(ProductsLoadingState());
         final result=await _productReposiory.getProducts(event.category_id,page);
         final _currentPage = result['meta']['current_page'];
         final _lastPage = result['meta']['last_page'];

         if(_currentPage==_lastPage)
             finish=true;

         if(result!=null)
          {
            page++;
            final data=result['data'].toList();
            data.forEach((element){
              products.add(Product.fromJson(element));
            }) ;
         }


         if(result==null)
          emit(ErrorState("server Error!!"));
        else if(products.length==0)
          emit(ErrorState("no products!"));
        else if(products.length>0)
          emit(ProductsLoadedState(products));
      }

   if(event is CategoryImagesEvent)
     {
       randomList=getRandomList();
       emit(CategoryImagesState(randomList));
     }

    });
  }

   List<Product> getRandomList() {
     List<int> indexes=[];
     List<Product> randlist=[];

     for(int i=0;i<products.length;i++)
     {

       if(randlist.length>4)
         break;
       int index=Random().nextInt(products.length);
       if(products[index].images.length>0)
         if(!indexes.contains(index) && products[index].images[0].url!=null)
         {
           randlist.add(products[index]);
           indexes.add(index);

         }
     }

     return randlist;

   }

}
