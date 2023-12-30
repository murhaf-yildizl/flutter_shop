import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shop/project/mvc/1.model/category/category.dart';
import 'package:shop/project/mvc/3.controller/category/category_controller.dart';

import '../../mvc/1.model/product/Product.dart';


part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  List<Category> categories=[];
  CategoryControlller _productReposiory=CategoryControlller();

  CategoryBloc() : super(CateoryLoadingState([])) {
    on<CategoryEvent>((event, emit) async {
     
      if(event is GetCategoryEvent)
        {
           if(categories.length==0)
          {
            emit(CateoryLoadingState([]));
            await _productReposiory.getCategories().then((value){
              if(value.length<1)
                emit(CategoryErrorState("no categories!!"));
           else {
                  categories=value;
                 emit(GetCategoriesState(value));
              }

            });

          }



        }

      // TODO: implement event handler
    });
  }
}
