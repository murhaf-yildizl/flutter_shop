import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/routes.dart';
import 'package:shop/project/mvc/1.model/onboarding/screenModel.dart';
import 'package:shop/project/utilities/helperfile.dart';
import 'package:shop/project/utilities/widget_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoarding extends StatefulWidget {

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  late PageController pageController;
  List<ScreenModel> screens=[];
  int selected_page=0;
  late double height,width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   screens=[
      ScreenModel("assets/images/image1.jpg","new season","Queen is a responsive dress website template that is designed for the websites connected with the fashion industry. Its main advantage is the drag-and-drop"),
      ScreenModel("assets/images/image2.jpg","surprise!!!","Believe it or not, the website creator is intuitive. You will find seven categories of handy widgets (e.g., social, media, blogging, gallery widgets, etc."),
      ScreenModel("assets/images/image3.jpg","soon!!", "Even a complete novice will understand the mechanism of building a fashion website with MotoCMS!")
    ];

    pageController=PageController(initialPage: 0);
  }
  @override
  Widget build(BuildContext context) {

    deviceDemensions(context);

    return Scaffold(
      //resizeToAvoidBottomInset: true,
      body: Container(

        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
               height:Get.height*.6 ,
              width: Get.width,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: PageView.builder(
                    controller:pageController ,
                    onPageChanged:(index){
                      setState(() {
                        selected_page=index;
                      });
                    } ,
                    itemBuilder: (context,index){
                        return drawContent(index);
                    },
                itemCount:screens.length ,

                ),
              ),
            ),
            SizedBox(height: 30,),
            PageIndicator(num:screens.length,page:selected_page),
            Spacer(),
            selected_page==screens.length-1?
            ElevatedButton(
              style: Theme.of(context).elevatedButtonTheme.style,
              onPressed: (){
                   Get.offAllNamed(AppRoute.home);
              },
              child:TextUtility("start", title_text_size,Colors.white,4,FontWeight.normal) ,
            ):Container(),

          ],
        ),

      ),
    );
  }

  Widget drawContent(int index) {
    return ListView(

       children: [
        Image.asset(screens[index].image,fit: BoxFit.fill,height:Get.height/3 ,width: Get.width,),
        SizedBox(height: 30,),
        CustomText(text:screens[index].title,color:Colors.grey.shade800,alingment: TextAlign.center,fontsize:20,),
        SizedBox(height:10,),
        CustomText(text:screens[index].content,color:Colors.grey.shade600,alingment: TextAlign.center,fontsize: 18,),


      ],
    );
  }


}
