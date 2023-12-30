part of 'category_bloc.dart';

@immutable
abstract class CategoryState {
  List<Category> categories=[];

  CategoryState(this.categories);
}

class  GetCategoriesState extends CategoryState{
  GetCategoriesState(List<Category> categories) : super(categories);
}
class  CateoryLoadingState extends CategoryState{
  CateoryLoadingState(List<Category> categories) : super(categories);
}
class  CategoryErrorState extends CategoryState{
       String message;

       CategoryErrorState(this.message):super([]);
}

class GetRandomProductsState extends CategoryState{
  List<Product>products=[];
  GetRandomProductsState(this.products) : super([]);
}
