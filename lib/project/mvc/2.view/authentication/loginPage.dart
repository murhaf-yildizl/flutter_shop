import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shop/project/utilities/widget_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../routes.dart';
import '../../1.model/customer/User.dart';
import '../../3.controller/authentication/authentication.dart';
import '../home_page/homepage.dart';
class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final formkey=GlobalKey<FormState>();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  bool loading=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar:AppBar(
        backgroundColor: Colors.white,
        title:Text("SignIn",style:Theme.of(context).textTheme.titleMedium!.copyWith(color:Colors.grey.shade600 )),
         leading: IconButton(
             onPressed:(){
                     Get.offAllNamed(AppRoute.home);
               },
             icon:Icon(Icons.arrow_back_ios_sharp,color: Colors.indigo,)
         ),

      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: ListView(
         children: [
          Lottie.asset("assets/lottie/logo.json",width: 150,height: 150),
           CustomText(text:"Welcome Back",color: Colors.black,alingment: TextAlign.center,fontsize: 16,),
           CustomTextGrey(text:"sigin in to continu to your account , or signup for a new one.",alingment: TextAlign.center,fontsize: 16,),
            SizedBox(height: 30,),

            Form(
            key: formkey,
            child: Column(

              children: [
                CustomTextFormFeild(hint:"Enter your email",label: 'Email',iconData: Icons.email_outlined,textEditingController: emailController,type: "email",min:5,max:100),
                SizedBox(height: 25,),
                CustomTextFormFeild(hint:"Enter your password",label: 'Password',iconData: Icons.lock,textEditingController: passwordController,type: "password", secure: true,min:8,max:16),


              ],
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap:(){
               Get.toNamed(AppRoute.forgetpassword);
            } , 
              child:CustomTextGrey(text:"forget password",alingment: TextAlign.right,fontsize: 16,)),
           SizedBox(height: 20),
           ElevatedButton(
            onPressed: (){
              if(loading)
                return;
              else  if(formkey.currentState!.validate())
                {
                  setState(() {
                    loading=true;
                   });
                  user_login();
                }
          },
          child:loading?Center(child: CircularProgressIndicator()):
          Text("LOGIN"),
            style:Theme.of(context).elevatedButtonTheme.style ,
          ),
            SizedBox(height: 20),
            Row(
                 mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: CustomTextGrey(text:"don't you have an account?",alingment: TextAlign.center,fontsize: 14)),
                 InkWell(
                    onTap:(){
                           Get.toNamed(AppRoute.signUp);
                    } ,
                    child: Text("Sigin Up",style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize:16,fontWeight: FontWeight.bold ),))
              ],
            ),
           SizedBox(height: 20),

         ],

        ),
      ),
    );
  }

user_login()async
{
  String email=emailController.text.trim();
  String password=passwordController.text.trim();
  Authentication authentication=Authentication();


try {
  await authentication.login(email, password).then((result) {
    if (result != null)
    {
      save_user(result);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomePage();
      }));
    }
  });
}catch(e){


   show_error_dialog_box(e.toString(), context);


}

  setState(() {
    loading=false;
  });
}

  void save_user(User user)async {

    SharedPreferences pref=await SharedPreferences.getInstance();
    pref.setInt("user_id", user.user_id);
    pref.setString("api_token", user.api_token);

  }
}

