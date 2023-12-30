import 'package:shop/project/mvc/1.model/category/category.dart';

class CategoryTree extends Category{
  List<CategoryTree>children=[];
  Category? parent;

  CategoryTree(this.children,this.parent,int id, String name, String? image_url, String? icon_url,int? parent_id) : super(id, name, image_url, icon_url,parent_id);

}