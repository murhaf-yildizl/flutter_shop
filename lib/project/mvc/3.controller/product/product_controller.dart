import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop/project/mvc/1.model/category/category.dart';
import '../../../api/api.dart';
import '../../../utilities/exceptions/exception_messages.dart';
import '../../1.model/product/Product.dart';

class ProductController{
  List<Product>products=[];
  List<Category>categories=[];

  Future<dynamic>? getProducts(int category_id,int page)async
 {

  final result=await getDataApi("getcategories/$category_id?page=$page");

  return result;

 }



  Future <dynamic> getDataApi(String suffex) async
  {
    Map<String, String>header={};

    header={
      'Accept':'application/json',
      //'cookie':cookie,
    };

    String url=main_api_url+suffex;
    print(url+" -----===== ");

    try {
      var response = await http.get(Uri.parse(url), headers: header);

       switch (response.statusCode) {
        case 200:
        case 201:
          {

            final result = jsonDecode(response.body.toString());

            return result;
          }

        case 404:
          {
            throw ExceptionMessage("url not found!").toString();
          }
        case 301:
        case 302:
        case 303:
        case 500:
          throw Exception('server error!!').toString();
      }
    }catch(e){
      print(e.toString());
      throw Exception('server error!!').toString();

    }

    return [];


  }
}