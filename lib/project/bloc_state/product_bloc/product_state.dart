part of 'product_bloc.dart';

@immutable
abstract class ProductState {
  List<Product>products=[];
  List<Product>randomList=[];

  ProductState(this.products,this.randomList);

 }

class ProductsLoadingState extends ProductState{
  ProductsLoadingState() : super( [],[]);

}


class ProductsLoadedState extends ProductState{
  ProductsLoadedState(List<Product> products) : super(products,[]);

}

class CategoryImagesState extends ProductState{
  CategoryImagesState(List<Product> randomList) : super([],randomList);

}

class ErrorState extends ProductState{
  String message;

  ErrorState(this.message) : super([],[]);
}

