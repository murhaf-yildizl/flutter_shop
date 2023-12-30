import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../mvc/1.model/review/review.dart';
import '../utilities/exceptions/exception_messages.dart';
import 'api.dart';

class ReviewApi{


  Future <List<Review>> getReviews(String suffex,String url_type) async
  {
    Map<String, String>header={};

    if(url_type=="authenticated")
    {
      SharedPreferences pref=await SharedPreferences.getInstance();
      String token=pref.getString('api_token')!;


      header = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };


    }


    else header={
      'Accept':'application/json',
    };

    String url=main_api_url+suffex;
    print(url+" -----===== ");

    try {
      var response = await http.get(Uri.parse(url), headers: header);

      switch (response.statusCode) {
        case 200:
        case 201:
          {

           return getRevList(response.body);

          }

        case 404:
          {
            throw ExceptionMessage("url not found!").toString();
          }
        case 301:
        case 302:
        case 303:
          throw Exception('server error!!').toString();
      }
    }catch(e){
      //  throw Exception('server error!!').toString();

    }

    return [];


  }

  Future<List<Review>> addToReviews(int product_id,int stars,String comment) async
  {
    SharedPreferences pref=await SharedPreferences.getInstance();
    String token=pref.getString('api_token')!;

    Map<String, String>header = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    Map<String, dynamic>body = {
      'product_id':product_id.toString() ,
      'stars': stars.toString(),
      'comment':comment.toString()
    };

    String url = main_api_url+"getreview";
    //print(url);

    http.Response response = await http.post(
        Uri.parse(url), headers: header, body: body);

     switch (response.statusCode) {

      case 200:
      case 201:
        {
         return getRevList(response.body);
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


  Future<dynamic> deleteReview(int rev_id) async
  {
    SharedPreferences pref=await SharedPreferences.getInstance();
    String token=pref.getString('api_token')!;

    Map<String, String>header = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };


    String url = main_api_url+"getreview/"+rev_id.toString();
    print(url);

    http.Response response = await http.delete(Uri.parse(url), headers: header);

     switch (response.statusCode) {

      case 200:
      case 201:
        {
         // final res=jsonDecode(response.body);
          //return res['data'];
                 break;
//          return getRevList(response.body);
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
          return [];

  }

  List<Review> getRevList(final body) {
    List<Review>reviews=[];

    final result = jsonDecode(body);

    List<dynamic> map=result['data'];

    map.forEach((element) {
       reviews.add(Review.fromJson(element));
    });
    return  reviews;
  }


}
