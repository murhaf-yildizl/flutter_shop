import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/exceptions/exception_messages.dart';


const String base_url="https://shop.murhaf.net/";
const main_api_url=base_url+"api/";
const auth_register=main_api_url+"auth/register";
const auth_login=main_api_url+"auth/login";
const auth_checkEmail=main_api_url+"auth/checkEmail";
const auth_resetPassword=main_api_url+"auth/resetPassword";
const storage_path=base_url+"myshop/storage/images/";
//const cookie="__test=5aa8b54f52ecaa55eb3704f0b9826758";


Future <dynamic> getData(String suffex,String url_type) async
{
  Map<String, String>header={};
  String? token;


  if(url_type=="authenticated")
    {
      SharedPreferences pref=await SharedPreferences.getInstance();
      token=pref.getString('api_token');


       header = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
  //       'cookie':cookie,

      };


    }


  else header={
    'Accept':'application/json',
    //'cookie':cookie,

    };

  String url=main_api_url+suffex;

  print(url+" -----===== ");

  try {
    var response;

     response = await http.get(Uri.parse(url), headers: header);

     switch (response.statusCode) {
      case 200:
      case 201:
        {

          final result = jsonDecode(response.body.toString());

             if(result.length>0)
            return result['data'];
         return [];
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


