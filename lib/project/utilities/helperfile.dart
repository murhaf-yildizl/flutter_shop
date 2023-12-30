import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

double title_text_size=18;
double content_text_size=16;
double button_height=50;
Color title_text_color=Colors.red;
Color content_text_color=Colors.black;
Color error_color=Colors.red;
Color icon_color=Colors.red;
double icon_size=30;
Color tab_bar_label_color=Colors.green;
double tab_bar_label_size=20;
String fontFamily="AbyssinicaSIL-Regular";
FontWeight? weight;
late double screen_height,screen_width;


deviceDemensions(BuildContext context) {
  double deviceWidth = MediaQuery.of(context).size.shortestSide;

    screen_height=MediaQuery.of(context).size.height;
    screen_width= MediaQuery.of(context).size.width;

      if (deviceWidth > 900)
          {
            title_text_size = 28;
            content_text_size=26;
            button_height=75;
          }
          //return ScreenSize.ExtraLarge;
 else if (deviceWidth > 600)
         {
           title_text_size = 28;
           content_text_size=24;
           button_height=70;
         } //return ScreenSize.Large;
 else if (deviceWidth > 320)
        {
          title_text_size = 20;
          content_text_size=16;
          button_height=60;
        } //return ScreenSize.Normal;
 else
   {
       title_text_size = 18;
       content_text_size=14;
       button_height=40;
       }




}



String convertDate(String date) {
 if( date==null)
 return "";
 Duration timeAgo = DateTime.now().difference(DateTime.parse(date));
 DateTime difference = DateTime.now().subtract(timeAgo);
 return timeago.format(difference);
 }



String? validation(String type,String data,int min,int max)
{
  if(data.length==0 )
    return " $type can't be empty";

  else  switch(type)
  {
    case "username":
      {
        if(!GetUtils.isUsername(data))
          return "username is not valid!";

        if(min>0 && max>0)
          return checkLength(data,type,min,max);
        break;
      }
    case "lastname":
      {
        if(!GetUtils.isUsername(data))
          return "lastname is not valid!";

        if(min>0 && max>0)
          return checkLength(data,type,min,max);
        break;
      }

    case "email":
      {
        if(!GetUtils.isEmail(data))
          return "email is not valid!";

        if(min>0 && max>0)
          return checkLength(data,type,min,max);
        break;
      }

    case "phone":
      {
        if(!GetUtils.isPhoneNumber(data))
          return "phone number is not valid!";

        if(min>0 && max>0)
          return checkLength(data,type,min,max);
        break;
      }

    case "number":
      {
        if(!GetUtils.isNumericOnly(data))
          return "number is not valid!";

        if(min>0 && max>0)
          return checkLength(data,type,min,max);
        break;
      }

    case "password":
      {
        if(min>0 && max>0)
          return checkLength(data,type,min,max);
        break;
      }
  }

}

String? checkLength(String data,String type, int min, int max) {

  if(data.length<min)
    return "$type must be $min character at least";

  if(data.length>max)
    return "$type can't be longer than $max character";

}





