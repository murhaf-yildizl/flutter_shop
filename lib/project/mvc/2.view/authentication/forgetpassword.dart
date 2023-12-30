import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../3.controller/authentication/authentication.dart';
import 'package:shop/routes.dart';
import 'package:shop/project/utilities/helperfile.dart';
import 'package:shop/project/utilities/widget_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgetPassword extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<ForgetPassword> {

  final formkey=GlobalKey<FormState>();
  TextEditingController emailController=TextEditingController();
  bool loading=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar:AppBar(
        backgroundColor: Colors.white,
        title:Text("Forget Password",style:Theme.of(context).textTheme.titleMedium!.copyWith(color:Colors.grey.shade600 )),
        leading: IconButton(
            onPressed:(){
              Navigator.pop(context);
            },
            icon:Icon(Icons.arrow_back_ios_sharp,color: Colors.indigo,)
        ),

      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: ListView(
          children: [
            CustomText(text:"reset your password with regested email",color: Colors.black,alingment: TextAlign.center,fontsize: 16,),
            SizedBox(height: 30,),

            Form(
              key: formkey,
              child: Column(

                children: [
                  CustomTextFormFeild(hint:"Enter your email",label: 'Email',iconData: Icons.email_outlined,textEditingController: emailController,type: "email",min:5,max:100),

                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                if(loading)
                  return;

                if(formkey.currentState!.validate())
                {
                  setState(() {
                    loading=true;
                  });
                  checkEmail();
                }
              },
              child:loading?Center(child: CircularProgressIndicator()):
              Text("Send"),
              style:Theme.of(context).elevatedButtonTheme.style ,
            ),

          ],

        ),
      ),
    );
  }


  checkEmail()async
  {
    String email=emailController.text.trim();
    Authentication authentication=Authentication();


    try {
      await authentication.checkEmail(email).then((result) {

         if (result != null)
        {
         Get.toNamed(AppRoute.emailverify);

        }
      });
    }catch(e){


      show_error_dialog_box(e.toString(), context);


    }

    setState(() {
      loading=false;
    });
  }
}

