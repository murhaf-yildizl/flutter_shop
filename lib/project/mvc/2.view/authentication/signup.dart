import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import '../../../../routes.dart';
import '../../3.controller/authentication/authentication.dart';
import 'package:shop/project/utilities/widget_utility.dart';

class SignUp extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<SignUp> {

  final formkey=GlobalKey<FormState>();
  TextEditingController firstNameController=TextEditingController();
  TextEditingController lastNameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  bool loading=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar:AppBar(
        backgroundColor: Colors.white,
        title:Text("SignUp",style:Theme.of(context).textTheme.titleMedium!.copyWith(color:Colors.grey.shade600 )),
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
            Form(
              key: formkey,
              child: Column(

                children: [
                  SizedBox(height: 25,),
                  CustomTextFormFeild(hint:"Enter your first name",label: 'first name',iconData: Icons.person_outline,textEditingController: firstNameController,type: "username",min:3,max:16),
                  SizedBox(height: 25,),
                  CustomTextFormFeild(hint:"Enter your last name",label: 'last name',iconData: Icons.person_outlined,textEditingController: lastNameController,type: "lastname",min:3,max:16 ),
                  SizedBox(height: 25,),
                  CustomTextFormFeild(hint:"Enter your email",label: 'Email',iconData: Icons.email_outlined,textEditingController: emailController,type: "email",min:5,max:100 ),
                  SizedBox(height: 25,),
                  CustomTextFormFeild(hint:"Enter your password",label: 'Password',iconData: Icons.lock,textEditingController: passwordController,type: "password", secure: true,min:8,max:16),


                ],
              ),
            ),
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
                  user_signUp();
                }
              },
              child:loading?Center(child: CircularProgressIndicator()):
              Text("SignUp"),
              style:Theme.of(context).elevatedButtonTheme.style ,
            ),

          ],

        ),
      ),
    );
  }

  user_signUp()async
  {
    String firstName=firstNameController.text.trim();
    String lastName=lastNameController.text.trim();
    String email=emailController.text.trim();
    String password=passwordController.text.trim();
    Authentication authentication=Authentication();


    try {
      await authentication.register(firstName,lastName,email, password).then((result) {
          if (result != null)
        {
          Get.toNamed(AppRoute.emailverify);

        }

      });
    }
    catch(e){



    }

    setState(() {
      loading=false;
    });
  }

 }

