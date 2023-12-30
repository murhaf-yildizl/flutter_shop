

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shop/project/mvc/2.view/shipment/create_shipment.dart';

class CreatePayment extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        color: Colors.red,
        child: Center(child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Payment page",style: Theme.of(context).textTheme.titleMedium,),
            InkWell(

              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder:(context){
                  return CreateShipment();
                }));
              },



              child:Lottie.asset("assets/lottie/continue.json",fit: BoxFit.contain),
            ),
          ],
        ) ,),
      ) ,
    );
  }
}
