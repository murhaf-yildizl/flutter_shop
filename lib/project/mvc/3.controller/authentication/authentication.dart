import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../api/api.dart';
import '../../../utilities/exceptions/exception_messages.dart';
import '../../1.model/customer/User.dart';

class Authentication {

  Future<dynamic> register(String first_name, String last_name, String email,
      String password) async
  {
    String url = auth_register;
        print("%%%%%%%%%%%%%% $url");
    Map<String, String>header = {
      'Accept': 'application/json'
    };
    Map<String, dynamic>body = {
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'password': password
    };

    try {
      http.Response response = await http.post(
          Uri.parse(url), headers: header, body: body);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200||response.statusCode == 201) {
        var result = jsonDecode(response.body);
        //print(result);
        return User.fromJson(result['data']);
      }
    }
    catch  (e) {

              throw Exception(e.toString());
          //ExceptionMessage(e.toString()) ;



    }

  }


  Future<dynamic> login(String email, String password) async
  {
    Map<String, String>header = {
      'Accept': 'application/json',
    };

    Map<String, dynamic>body = {
      'email': email,
      'password': password
    };

    String url = auth_login;
    print(url);

    http.Response response = await http.post(
        Uri.parse(url), headers: header, body: body);

    //print("TTTTTTTTTT  " + response.statusCode.toString());
    switch (response.statusCode) {
      case 200:
      case 201:
        {
          var result = jsonDecode(response.body);
          print(result);
          return User.fromJson(result['data']);
        }

      case 404:
        throw ExceptionMessage("not found!").toString();
      case 401:
        {
          var result = jsonDecode(response.body);
          throw ExceptionMessage(result['message']).toString();
        }
      default :
        throw ExceptionMessage('data  error!').toString();
    }
  }


  Future<dynamic> checkEmail(String email) async
  {
    Map<String, String>header = {
      'Accept': 'application/json',
    };

    Map<String, dynamic>body = {
      'email': email,
    };

    String url = auth_checkEmail;
    //print(url);

    http.Response response = await http.post(
        Uri.parse(url), headers: header, body: body);
    //print("TTTTTTTTTT  " + response.statusCode.toString());
    switch (response.statusCode) {
      case 200:
      case 201:
        {
          var result = jsonDecode(response.body);
          return User.fromJson(result['data']);
        }

      case 404:
        throw ExceptionMessage("not found!").toString();
      case 401:
        {
          var result = jsonDecode(response.body);
          throw ExceptionMessage(result['message']).toString();
        }
      default :
        throw ExceptionMessage('this email is not found!').toString();
    }
  }


  Future<dynamic> resetPassword(String password, String confirmPassword) async
  {
    Map<String, String>header = {
      'Accept': 'application/json',
    };

    Map<String, dynamic>body = {
      'password': password,
      'confirmpassword': confirmPassword,
    };

    String url = auth_resetPassword;
    //print(url);

    http.Response response = await http.post(
        Uri.parse(url), headers: header, body: body);

    //print("TTTTTTTTTT  " + response.statusCode.toString());
    switch (response.statusCode) {
      case 200:
      case 201:
        {
          var result = jsonDecode(response.body);
          return User.fromJson(result['data']);
        }

      case 404:
        throw ExceptionMessage("not found!").toString();
      case 401:
        {
          var result = jsonDecode(response.body);
          throw ExceptionMessage(result['message']).toString();
        }
      default :
        throw ExceptionMessage('data  error!').toString();
    }
  }

}