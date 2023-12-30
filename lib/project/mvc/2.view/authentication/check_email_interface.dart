import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/routes.dart';
import 'package:shop/project/utilities/widget_utility.dart';

class CheckEmail extends StatelessWidget {
  const CheckEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50,horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.check_circle,size: 100,color: Colors.green,),
             SizedBox(height: 10),
             CustomText(text: "your account has been created successfuly", color: Colors.grey.shade600, alingment: TextAlign.center, fontsize: 16),
            SizedBox(height: 10,),
            Spacer(),
            ElevatedButton(
                onPressed: (){
                   Get.offAllNamed(AppRoute.signIn);
                },
                child:Text('contine'),
              style:Theme.of(context).elevatedButtonTheme.style ,




            )
            ],
        ),
      ),
    );
  }
}
