import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import '../../3.controller/authentication/authentication.dart';
import 'package:shop/routes.dart';
import 'package:shop/project/utilities/widget_utility.dart';

class EmailVerification extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<EmailVerification> {

  final formkey=GlobalKey<FormState>();
  TextEditingController verifyController=TextEditingController();
  bool loading=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar:AppBar(
        backgroundColor: Colors.white,
        title:Text("Email verification",style:Theme.of(context).textTheme.titleMedium!.copyWith(color:Colors.grey.shade600 )),
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
            CustomText(text:"please check your email and enter the sent verifaication code here...",color: Colors.black,alingment: TextAlign.center,fontsize: 16,),
            SizedBox(height: 30,),
            VerifyWidget()


          ],

        ),
      ),
    );
  }


  checkEmail()async
  {
    String email=verifyController.text.trim();
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

