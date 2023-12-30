import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:lottie/lottie.dart';
import 'package:shop/project/bloc_state/cart_bloc/cart_bloc.dart';
import 'package:shop/project/bloc_state/category_bloc/category_bloc.dart';
import 'package:shop/project/bloc_state/product_bloc/product_bloc.dart';
import 'package:shop/project/bloc_state/user_bloc/user_bloc.dart';
import 'package:shop/project/localization/change_language.dart';
import 'package:shop/project/localization/language_getx.dart';
import 'package:shop/project/localization/translation.dart';
import 'package:shop/project/mvc/2.view/home_page/homepage.dart';
import 'package:shop/project/mvc/3.controller/category/category_controller.dart';
import 'package:shop/project/mvc/3.controller/product/product_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:shop/project/utilities/helperfile.dart';
import 'routes.dart';

late SharedPreferences pref;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    pref=await SharedPreferences.getInstance();
    bool? seen=pref.getBool("seen");

      runApp(
          DevicePreview(
              enabled: !kReleaseMode,
              builder: (context) => MyApp((seen==null||seen==false?ChangeLanguage():HomePage()))
          )
      );



}

class MyApp extends StatelessWidget {

  late Widget home;
  MyApp(this.home);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    LanguageController languageController=Get.put(LanguageController());
    deviceDemensions(context);

    return    MultiBlocProvider(
      providers: [
        BlocProvider(create:(context)=>CartBloc()..add(GetCartEvent())),
        BlocProvider(create:(context)=>ProductBloc()..add(GetProductsEvent(-1))),
        BlocProvider(create: (context)=>CategoryBloc()..add(GetCategoryEvent())),
        BlocProvider(create: (context)=>UserBloc()..add(GetUserEvent())),

      ],
      child: GetMaterialApp(
       // useInheritedMediaQuery: true,
        locale: languageController.language,
       // builder: DevicePreview.appBuilder,
        translations:MyTranslate(),
        debugShowCheckedModeBanner: false,
         getPages: routes,
         theme:languageController.appTheme,
        home: Container(
              height: 300,
              width:200 ,
          padding: const EdgeInsets.all(10),
          color: Colors.white,
          child:FutureBuilder(
            future: LoadData(),
            builder: (BuildContext context,AsyncSnapshot snapshot) {
                  if(snapshot.connectionState==ConnectionState.waiting)
                    return splashScreen();
                 else if(snapshot.connectionState==ConnectionState.done)
                       return home;
              return Text('');

            }

          )

        ),
      )
    );





  }

 Widget splashScreen(){
    return Center(child: Lottie.asset("assets/lottie/logo.json",width: 200,height: 300));
  }

Future LoadData()async{
    CategoryControlller rep=CategoryControlller();
    ProductController productReposiory=ProductController();

   await  rep.getRandomProducts();
   await  rep.getCategories();
}
}
