

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CreateShipment extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("create shipment",style: Theme.of(context).textTheme.titleMedium,),
            InkWell(

              onTap: (){print("HHHHHh");},
              child:Lottie.asset("assets/lottie/continue.json",fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }
}
