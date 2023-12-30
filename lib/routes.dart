import 'package:get/get.dart';
import 'package:shop/project/localization/change_language.dart';
import 'package:shop/project/mvc/2.view/authentication/check_email_interface.dart';
import 'package:shop/project/mvc/2.view/authentication/email_verification.dart';
import 'package:shop/project/mvc/2.view/authentication/forgetpassword.dart';
import 'package:shop/project/mvc/2.view/authentication/loginPage.dart';
import 'package:shop/project/mvc/2.view/authentication/reset_password.dart';
import 'package:shop/project/mvc/2.view/authentication/signup.dart';
import 'package:shop/project/mvc/2.view/home_page/homepage.dart';
import 'package:shop/project/mvc/2.view/onboarding/onboarding.dart';
import 'project/mvc/2.view/cart/show_cart.dart';


List<GetPage<dynamic>>routes=[
  GetPage(name:AppRoute.home,page:()=>HomePage()),
  GetPage(name:AppRoute.signIn,page:()=>LoginPage()),
  GetPage(name:AppRoute.signUp,page:()=>SignUp()),
  GetPage(name:AppRoute.forgetpassword,page:()=>ForgetPassword()),
  GetPage(name:AppRoute.resetpassword,page:()=>ResetPassword()),
  GetPage(name:AppRoute.emailverify,page:()=>EmailVerification()),
  GetPage(name:AppRoute.checkemail,page:()=>CheckEmail()),
  GetPage(name:AppRoute.showCart,page:()=>ShowCart()),
  GetPage(name:AppRoute.languagesetting,page:()=>ChangeLanguage()),
  GetPage(name:AppRoute.onboarding,page:()=>OnBoarding()),


];

class AppRoute{

  static const String signIn="/signIn";
  static const String signUp="/signUp";
  static const String signOut="/signOut";
  static const String home="/home";
  static const String showCart="/showCart";
  static const String forgetpassword="/forgetpassword";
  static const String resetpassword="/resetpassword";
  static const String emailverify="/emailverify";
  static const String checkemail="/checkemail";
  static const String languagesetting="/languagesetting";
  static const String onboarding="/onboarding";


}
