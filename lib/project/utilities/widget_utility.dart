import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shop/project/mvc/2.view/home_page/homepage.dart';
import 'package:shop/routes.dart';
import 'package:shop/project/utilities/helperfile.dart';
import '../api/api.dart';
import '../bloc_state/cart_bloc/cart_bloc.dart';
import '../mvc/1.model/product/Product.dart';
import '../mvc/1.model/review/review.dart';


class DrawImage extends StatelessWidget {
    String? url;
    double? width,height;
   DrawImage( {Key? key,this.url,this.width=0,this.height=0}) : super(key: key);

  @override
  Widget build(BuildContext context)  {

       if(url!=null)
         return FutureBuilder(
     future: downloadImage(url!),
     builder: (BuildContext context,AsyncSnapshot<dynamic>snapshot) {
       if(snapshot.connectionState==ConnectionState.waiting)
         return Center(child: CircularProgressIndicator());
      else if ((snapshot.connectionState == ConnectionState.done ||
           snapshot.connectionState == ConnectionState.active) &&
           !snapshot.hasError)
      {
         if (snapshot.hasData) {
            return snapshot.data;
         }

      }

       return Container();
      });

      else return Container();
  }

  Future<dynamic> downloadImage(String? url)async {
    Map<String,String>header = {
      'Accept': 'application/json',
       //'cookie':cookie,

    };
    try {

          return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            clipBehavior: Clip.hardEdge,
            child: await Image.network(
            storage_path + url!, fit: BoxFit.cover, headers: header,width:this.width,height: this.height,
            errorBuilder:(BuildContext context,Object exception,StackTrace? trace){
                  return Image.asset("assets/images/emptyimage.jpg", fit: BoxFit.cover,width: 200,height: 225,);
            } ,

            ),
          );
    }
    catch (e){
       throw Exception(e);
    }
  }
}

class DrawRating extends StatelessWidget {
       late Product product;

    DrawRating({Key? key,required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Review> reviews = product.reviews;
    int sum = 0;

    if (reviews != null) if (reviews.length > 0) {
      reviews.forEach((rev) {
        sum += rev.stars;
      });
      int stars = (sum / reviews.length).floor();
      String avg = (sum / reviews.length).toStringAsFixed(2);

      return getStars(stars, avg, reviews.length, context,product);
    } else
      return getStars(0, '', 0, context,product);

    return Text('');

  }


 Widget getStars(int stars, String avg, int total, BuildContext context, Product product) {
         List<Widget> starList = [
           TextUtility('$avg',16,Colors.indigo,1,FontWeight.bold)
         ];
         int i = 0;

         while (i < 5) {
           if (i < stars)
             starList.add(Icon(
               Icons.star,
               color: Colors.amberAccent,size: 15,
             ));
           else
             starList.add(Icon(
               Icons.star_border,
               color: Colors.amberAccent,size: 15,
             ));

           i++;
         }
         total > 0
             ? starList.add(TextUtility("[$total]",16,Colors.indigo,1,FontWeight.normal))
             : starList.add(TextUtility("(no reviews)", 16,
             Colors.black.withOpacity(0.5), 1, FontWeight.bold));

         //starList.add(SizedBox(width:5));
         if(total>0)
           return Row(mainAxisAlignment: MainAxisAlignment.start, children: starList);
         else return Text('');
       }

}

class PageIndicator extends StatelessWidget {
  late int num,page;
    PageIndicator({Key? key,required this.num,required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
     list = List.generate(
        num,
            (index) => Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: AnimatedContainer(
            duration:Duration(milliseconds: 500) ,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: index == page ? Colors.red : Colors.grey.shade300,
            ),
            height: index==page?4:10,
            width:index==page? 30:10,
          ),
        ));
    return Center(
      child: Container(
        width: 200,
        height: 25,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2
              )
            ]
        ),

        child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: list)),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
     String? title;
     String?  page;

     CustomAppBar({ Key? key,this.title, this.page}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 100),
      child: ClipPath(
        clipper: CurvedAppBar(),
        child: Container(
          color: Colors.deepPurple.withOpacity(0.8),
          child:   AppBar(

            toolbarHeight: 90,
            iconTheme:   IconThemeData(
                color: Colors.white,
                size: 40
            ),
            backgroundColor: Colors.teal,
            centerTitle: true,
            title: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  page=="cart" || page=="product"?
                  IconButton(
                  onPressed:(){
                    Get.offUntil(MaterialPageRoute(builder:(context)=>HomePage()), (route) => false);
                  },
                  icon:Icon(Icons.home,size:35,color:Colors.white)
                  ):Text(''),
                  Text(title??'', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white,fontFamily:'AbyssinicaSIL-Regular' ),),
                  Spacer(),

                  BlocProvider(
                    create:(context)=>CartBloc()..add(GetCartEvent()),
                    child: BlocBuilder<CartBloc, CartState>(
                        builder: (context, state) {
                          if (state is CartIsLoadingState)
                            return Text('');
                          else if (state is GetCartState)
                            return IconButton(
                                onPressed: () {
                                  if(page=="cart")
                                    return;
                                 else Get.offAllNamed(AppRoute.showCart);
                                },
                                icon: badge.Badge(
                                    showBadge: state.cart!.items_count == 0 ? false : true,
                                    badgeColor: Colors.red,

                                    borderRadius:BorderRadius.circular(1) ,
                                    position: badge.BadgePosition.topEnd(top: -10,end: -10),
                                    badgeContent: Text(state.cart!.items_count.toString(),style: TextStyle(fontSize: 12,color: Colors.white),),
                                    child:FaIcon(FontAwesomeIcons.cartPlus, size: 40,color: Colors.white,)));

                          return Text('');
                        }
                    ),
                  ),

                ],
              ),
            ),

          ),
        ),
      ),


    );

  }







  Future<List<int>> fetchImageBytes(String imageUrl) async {
    print("url== ${imageUrl}");
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }


}


class CurvedAppBar extends CustomClipper<Path>{
  @override
  getClip(Size size) {
    Path path=Path();

    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width/4,size.height-40,size.width/2,size.height-20);
    path.quadraticBezierTo(size.width*3/4,size.height,size.width,size.height-20);
    path.lineTo(size.width,0);

    return path;
    // TODO: implement getClip
    throw UnimplementedError();
  }


  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
    // TODO: implement shouldReclip
    throw UnimplementedError();
  }



}


class CustomTextFormFeild extends StatelessWidget {
String? hint,label,type;
late TextEditingController textEditingController;
IconData? iconData;
bool? secure;
int? min,max;

CustomTextFormFeild({Key? key,this.hint,this.label,this.iconData,required this.textEditingController,this.type,this.secure=false ,this.min,this.max}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return  TextFormField(

      controller: textEditingController,
      keyboardType: type=="phone"?TextInputType.numberWithOptions():TextInputType.text,
      decoration:InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical:10,horizontal:30),

          hintText: hint??'',
          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.grey.shade600),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          //isCollapsed: true,
          label: Container(
              margin: EdgeInsets.symmetric(horizontal:10 ),
              child: Text(label??'',style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey.shade600),)),

          suffixIcon: InkWell(
              onTap: (){
                if(type=="password" && textEditingController.text.length>0)
                  {

                    //showPassword_Func();
                    //secure=showPassword;

                  }
              },
              child: Icon(iconData)
          ),
          focusedBorder:outLineBorder(),
          enabledBorder:  outLineBorder(),
          focusedErrorBorder: outLineBorder(),
          errorBorder:outLineBorder()

      ) ,
      obscureText: secure!,
      validator: (value){
        return validation(type!,value??'', min??0, max??0);
      },
    );
  }

OutlineInputBorder  outLineBorder() {
     return OutlineInputBorder(
      borderRadius: BorderRadius.circular(35),
      borderSide: BorderSide(
        color: Colors.green,
        width: 2,
        style: BorderStyle.solid,

      ));
}
}

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CustomTextGrey extends StatelessWidget {
  late String text;
  late TextAlign alingment;
  late double fontsize;

    CustomTextGrey({Key? key,required this.text,required this.alingment,required this.fontsize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey.shade600,fontSize: fontsize),textAlign: alingment);

  }
}

class CustomText extends StatelessWidget {
  late String text;
  late Color color;
  late TextAlign alingment;
  late double fontsize;

  CustomText({Key? key,required this.text,required this.color,required this.alingment,required this.fontsize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,style: Theme.of(context).textTheme.titleMedium!.copyWith(color: color,fontSize: fontsize),textAlign: alingment,overflow: TextOverflow.ellipsis,maxLines: 3,);

  }
}


  Future<bool> showAlertDialog(String message)
  {
    Get.defaultDialog(
        title: "alert",
        middleText: message,
        //middleTextStyle: Get.theme.textTheme.titleMedium,
        actions: [
          ElevatedButton(
            onPressed: (){
              exit(0);
            },
            child:Text('Ok') ,
            style: Get.theme.elevatedButtonTheme.style,
          ),
          ElevatedButton(
            onPressed: (){
              Get.back();
            },
            child:Text('cancel') ,
            style: Get.theme.elevatedButtonTheme.style,
          )
        ]


    );
    return Future.value(true);
  }

  alertdialog(BuildContext context,String text)
  {

    AwesomeDialog(
      context: context,
      customHeader:Icon(Icons.check_circle,color: Colors.green,size:60) ,

      dialogType: DialogType.SUCCES,
      borderSide: BorderSide(color: Colors.green, width: 2),
      buttonsBorderRadius: BorderRadius.all(Radius.circular(1)),
      headerAnimationLoop: true,
      autoHide:Duration(seconds: 2) ,
      animType: AnimType.SCALE,
      body:Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: TextUtility(text,18,Colors.red,1,FontWeight.bold),
        ),
      ) ,
      //desc: 'USER_NOT_FOUND',
      //showCloseIcon: true,
    ).show();

  }


  void show_error_dialog_box(String txt,BuildContext context)
  {
    AwesomeDialog(
      context: context,
      customHeader:Icon(Icons.error_outline_sharp,color: Colors.red,size:60) ,
      dialogType: DialogType.ERROR,
      borderSide: BorderSide(color: Colors.green, width: 2),
      buttonsBorderRadius: BorderRadius.all(Radius.circular(1)),
      headerAnimationLoop: true,
      autoHide:Duration(seconds: 2) ,
      animType: AnimType.SCALE,
      title: 'Error',
      body:Center(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextUtility(txt,18,Colors.red,2,FontWeight.normal)
        ),
      ) ,
//desc: 'USER_NOT_FOUND',
//showCloseIcon: true,
// btnCancelOnPress: () {},
// btnOkOnPress: () {},


    ).show();
  }

class VerifyWidget extends StatelessWidget {
  const VerifyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OtpTextField(
      borderRadius: BorderRadius.circular(30),
      fieldWidth: 50,
      numberOfFields: 5,
      borderColor: Color(0xFF512DA8),
      //set to true to show as box or false to show as dash
      showFieldAsBox: true,
      //runs when a code is typed in
      onCodeChanged: (String code) {

      },
      //runs when every textfield is filled
      onSubmit: (String verificationCode){
         if(verificationCode=="12345")
         {
               if (Get.previousRoute == AppRoute.signUp)
                  Get.offNamed(AppRoute.checkemail);

         else   if (Get.previousRoute == AppRoute.forgetpassword)
                   Get.offNamed(AppRoute.resetpassword);
         }
        else  show_error_dialog_box("verification code is not valid",context);

      }, // end onSubmit
    );
  }
}

  Widget TextUtility(String text,double size,Color color,double letter_spacing,FontWeight weight)
  {
    return Text(text,style: TextStyle(fontSize: size,color: color,fontWeight: weight,letterSpacing: letter_spacing,height:1.5,fontFamily:fontFamily ),maxLines: 2,textAlign: TextAlign.start,textDirection: TextDirection.ltr,overflow: TextOverflow.ellipsis,);
  }


  class Loading extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
      return   Container(
          color: Colors.white,
          child: Center(child: CircularProgressIndicator()));
    }
  }


  class ShowErrorWidget extends StatelessWidget {
      late String error;

      ShowErrorWidget(this.error);

  @override
    Widget build(BuildContext context) {
      return Container(color:Colors.white,child: Center(child: Text(error,style:TextStyle(color:Theme.of(context).errorColor,fontSize: 20))));
    }
  }
