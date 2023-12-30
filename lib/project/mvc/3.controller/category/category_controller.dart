import '../../../api/api.dart';
import '../../1.model/product/Product.dart';
import '../../1.model/category/category.dart';

class CategoryControlller{
  List<Product>products=[];
  List<Category>categories=[];
  List<Product>random_products=[];

  Future<List<Category>> getCategories()async
  {

       if(categories.length>0)
             return categories;

    List<dynamic> result=await getData("getcategories",'general');
     categories=[];
    if(result!=null)
      if(result.length>0)
      {

        result.forEach((element)
        {
          categories.add(Category.fromJson(element));
        });
        return categories;
      }

    return [];
  }


  Future<List<Product>> getProducts(int category_id)async
  {

    List<dynamic> result=await getData("getcategories/$category_id",'general');

    if(result!=null)
      if(result.length>0)
      {

        result.forEach((element)
        {
          products.add(Product.fromJson(element));
        });
        return products;
      }

    return [];
  }


  Future<List<Product>> getRandomProducts()async
  {
    if(random_products.length>0)
      return random_products;

    List<dynamic> result=await getData("getrandomproducts",'general');

    random_products=[];

    if(result!=null)
      if(result.length>0)
      {

        result.forEach((element)
        {
          random_products.add(Product.fromJson(element));
        });

        return random_products;
      }

    return [];
  }
}