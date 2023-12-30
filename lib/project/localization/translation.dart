//import 'package:get/get.dart';

import 'package:get/get_navigation/src/root/internacionalization.dart';
import 'package:get/get.dart';

class MyTranslate extends Translations{
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en':{
      '1':'choose language:',
      '2':'Home Page',
      '3':'english',
      '4':'arabic',
      '5':"save",
      '6':"settings",
      '7':"LogIn",
      '8':"LogOut",
      '9':"categories",
      '10':"language setting"

    },

    'ar':
    {
      '1':"اختر اللغة",
      '2':"الصفحة الرئيسية",
      '3':'الإنجليزية',
      "4":"العربية",
      '5':"حفظ",
      '6':"الإعدادات",
      '7':"تسجيل الدخول",
      '8':"تسجيل الخروج",
      '9':"المنتجات",
      '10':"إعدادات اللغة"
    }
  };

}