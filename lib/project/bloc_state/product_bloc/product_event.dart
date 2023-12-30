part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {
  int category_id;

  ProductEvent(this.category_id);
}


class InitialProductsEvent extends ProductEvent{

  InitialProductsEvent() : super(-1);
}

class GetProductsEvent extends ProductEvent{

  GetProductsEvent(int category_id) : super(category_id);
}

class CategoryImagesEvent extends ProductEvent{
  CategoryImagesEvent(int category_id) : super(category_id);

}

