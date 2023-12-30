import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../../1.model/customer/User.dart';
import '../../3.controller/authentication/authentication.dart';
import 'package:shop/project/utilities/helperfile.dart';
import 'package:shop/project/utilities/widget_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page/homepage.dart';

class ResetPassword extends StatefulWidget {

  @override
  _ResetPsswordState createState() => _ResetPsswordState();
}

class _ResetPsswordState extends State<ResetPassword> {

  final formkey=GlobalKey<FormState>();
  TextEditingController passwordController=TextEditingController();
  TextEditingController confirmPasswordController=TextEditingController();
  bool loading=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar:AppBar(
        backgroundColor: Colors.white,
        title:Text("Reset password",style:Theme.of(context).textTheme.titleMedium!.copyWith(color:Colors.grey.shade600 )),

      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: ListView(
          children: [
            CustomTextGrey(text:"enter a new password for your account.",alingment: TextAlign.center,fontsize: 16,),
            SizedBox(height: 30,),

            Form(
              key: formkey,
              child: Column(

                children: [
                  CustomTextFormFeild(hint:"Enter a new password",label: 'Password',iconData: Icons.lock,textEditingController: passwordController,type: "password", secure: true,min:8,max:16),
                  SizedBox(height: 25,),
                  CustomTextFormFeild(hint:"confirm your password",label: 'confirm',iconData: Icons.lock,textEditingController: confirmPasswordController,type: "password", secure: true,min:8,max:16),


                ],
              ),
            ),
        SizedBox(height: 40),
            ElevatedButton(
              onPressed: (){

                 if(loading)
                  return;
                else  if(formkey.currentState!.validate() )
                {
                  if(passwordController.text.trim().compareTo(confirmPasswordController.text.trim())!=0)
                    show_error_dialog_box("enterd password is not mathed!", context);

                 else  setState(() {
                    loading=true;
                  });
                  user_login();
                }
              },
              child:loading?Center(child: CircularProgressIndicator()):
              Text("save"),
              style:Theme.of(context).elevatedButtonTheme.style ,
            ),

          ],

        ),
      ),
    );
  }

  user_login()async
  {
    String password=passwordController.text.trim();
    String confirmPassword=confirmPasswordController.text.trim();
    Authentication authentication=Authentication();


    try {
      await authentication.resetPassword( password,confirmPassword).then((result) {
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

