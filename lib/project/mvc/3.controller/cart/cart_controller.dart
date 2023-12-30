import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shop/project/mvc/1.model/option/option.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/project/mvc/2.view/cart/show_cart.dart';
import '../../../api/api.dart';
import '../../../utilities/exceptions/exception_messages.dart';
import '../../1.model/cart/cart.dart';

abstract class CartController {

  getCart();
  Future<dynamic> addToCart(int product_id,double qnty,Option options);
  Future<dynamic> removeFromCart(int  item_id);
  Future<dynamic> deleteProductCart(int item_id);
}

class CartRepo extends CartController{
    Cart? cart;


  @override
  Future<Cart?>? getCart() async{

    final result=await getData("getcart","authenticated");
      if(result!=null)
      // ignore: curly_braces_in_flow_control_structures
      if(result.length>0)
      {
         cart=Cart.fromJson(result);
       }

      return cart??null;
  }


  Future<dynamic> addToCart(int product_id,double qnty,Option options) async
  {

     SharedPreferences pref=await SharedPreferences.getInstance();
     String token=pref.getString('api_token')!;

    Map<String, String>header = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      //'cookie':cookie
    };

    var op_map;

     if(options!=null)
       {
         op_map=jsonEncode(Option.toJson(options));
        }

     Map<String, dynamic>body = {
      'product_id':product_id.toString() ,
      'qnty': qnty.toString(),
      'options':op_map
    };

    String url = main_api_url+"getcart";
    print(url);

    http.Response response = await http.post(
        Uri.tryParse(url.trim())!, headers: header, body: body);
     switch (response.statusCode) {

      case 200:
      case 201:
        {

          print("############ OKK ");
           Get.to(ShowCart());
          //print("Cart= "+result.toString());
          break;
          ///return result['data'];
        }

      case 404:
        throw ExceptionMessage("not found!").toString();
        break;
      default:
        {
          var result = jsonDecode(response.body);
          throw ExceptionMessage(result['message']).toString();
        }
    }


  }

  Future<dynamic> deleteProductCart(int item_id) async
  {
    SharedPreferences pref=await SharedPreferences.getInstance();
    String token=pref.getString('api_token')!;



    Map<String, String>header = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      //'cookie':cookie
    };


    String url = main_api_url+"getcart/"+item_id.toString();

    http.Response response = await http.delete(Uri.parse(url), headers: header);

    print(response.statusCode.toString());
    print(url+" ${response.body.length}");
    switch (response.statusCode) {

      case 200:
      case 201:
        {

          print("item deleted..." );

          break;
          //return result['data'];
        }

      case 404:
        throw ExceptionMessage("not found!").toString();
        break;
      default:
        {
          var result = jsonDecode(response.body);
          throw ExceptionMessage(result['message']).toString();
        }
    }


  }


  Future<dynamic> removeFromCart(int item_id) async
  {
    SharedPreferences pref=await SharedPreferences.getInstance();
    String token=pref.getString('api_token')!;

      Map<String, String>header = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      //'cookie':cookie

      };


    String url = main_api_url+"decreaseQNT/"+item_id.toString();
    print(url);

    http.Response response = await http.get(Uri.parse(url), headers: header);

    print(response.statusCode.toString());
    switch (response.statusCode) {

      case 200:
      case 201:
        {
          print("decreased");
           break;
          //return result['data'];
        }

      case 404:
        throw ExceptionMessage("not found!").toString();
        break;
      default:
        {
          var result = jsonDecode(response.body);
          throw ExceptionMessage(result['message']).toString();
        }
    }


  }
}

