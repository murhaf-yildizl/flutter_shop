import 'package:flutter/material.dart';
import 'package:shop/project/utilities/helperfile.dart';

ThemeData englishTheme=ThemeData(
backgroundColor:Colors.white ,
primaryColor: Colors.indigo,
scaffoldBackgroundColor:Colors.white,
primaryIconTheme: IconThemeData(
color:Colors.white,
size: icon_size,

),
floatingActionButtonTheme:FloatingActionButtonThemeData(
backgroundColor: Colors.indigo,
foregroundColor: Colors.white
) ,
textTheme: TextTheme(

titleMedium: TextStyle(
fontFamily:  'AbyssinicaSIL-Regular',
fontSize: 18,
letterSpacing:1.5,
height:1.5,
fontWeight: FontWeight.bold
),
titleSmall: TextStyle(
fontFamily:  'Cairo-Black',
fontSize: 16,
color: Colors.black,
letterSpacing: 1,


),
titleLarge: TextStyle(
fontFamily: 'AbyssinicaSIL-Regular',
fontSize: 16,
letterSpacing: 2,
fontWeight: FontWeight.bold

),



),


errorColor:error_color,
appBarTheme:AppBarTheme(
centerTitle:true,
elevation: 0,
toolbarHeight: 90,
backgroundColor: Colors.white,
titleTextStyle:TextStyle(

color:Colors.white,
fontFamily: 'AbyssinicaSIL-Regular',
fontWeight: FontWeight.bold,
letterSpacing:1.5,
fontSize:18,


),
),
tabBarTheme:TabBarTheme(

//indicatorSize: TabBarIndicatorSize.label,
labelPadding: EdgeInsets.all(16),

labelColor:Colors.red,
unselectedLabelColor: Colors.white,
unselectedLabelStyle:TextStyle(
fontSize:16,
fontFamily: 'AbyssinicaSIL-Regular',
letterSpacing: 2
) ,
labelStyle: TextStyle(
letterSpacing: 2,
fontSize:tab_bar_label_size,
fontFamily: 'AbyssinicaSIL-Regular',
)
),
elevatedButtonTheme: ElevatedButtonThemeData(

style:  ElevatedButton.styleFrom(
minimumSize:Size(double.infinity,55) ,


textStyle:TextStyle(

letterSpacing: 2,
fontSize:20,
fontFamily: 'AbyssinicaSIL-Regular',
),

shape:RoundedRectangleBorder(
borderRadius: BorderRadius.circular(50)
),
primary: Colors.indigo.shade800,



)
),

);
ThemeData arabicTheme=ThemeData(
  backgroundColor:Colors.white ,
  primaryColor: Colors.indigo,
  scaffoldBackgroundColor:Colors.white,
  primaryIconTheme: IconThemeData(
    color:Colors.white,
    size: icon_size,

  ),
  floatingActionButtonTheme:FloatingActionButtonThemeData(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white
  ) ,
  textTheme: TextTheme(

    titleMedium: TextStyle(
        fontFamily:  'Cairo-Black',
        fontSize: 18,
        letterSpacing:1.5,
        height:1.5,
        fontWeight: FontWeight.bold
    ),
    titleSmall: TextStyle(
      fontFamily:  'Cairo-Black',
      fontSize: 16,
      color: Colors.black,
      letterSpacing: 1,


    ),
    titleLarge: TextStyle(
        fontFamily: 'Cairo-Black',
        fontSize: 16,
        letterSpacing: 2,
        fontWeight: FontWeight.bold

    ),



  ),


  errorColor:error_color,
  appBarTheme:AppBarTheme(
    centerTitle:true,
    elevation: 0,
    toolbarHeight: 90,
    backgroundColor: Colors.white,
    titleTextStyle:TextStyle(

      color:Colors.white,
      fontFamily: 'Cairo-Black',
      fontWeight: FontWeight.bold,
      letterSpacing:1.5,
      fontSize:18,


    ),
  ),
  tabBarTheme:TabBarTheme(

//indicatorSize: TabBarIndicatorSize.label,
      labelPadding: EdgeInsets.all(16),

      labelColor:Colors.red,
      unselectedLabelColor: Colors.white,
      unselectedLabelStyle:TextStyle(
          fontSize:16,
          fontFamily: 'Cairo-Black',
          letterSpacing: 2
      ) ,
      labelStyle: TextStyle(
        letterSpacing: 2,
        fontSize:tab_bar_label_size,
        fontFamily: 'Cairo-Black',
      )
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(

      style:  ElevatedButton.styleFrom(
        minimumSize:Size(double.infinity,55) ,


        textStyle:TextStyle(

          letterSpacing: 2,
          fontSize:20,
          fontFamily: 'Cairo-Black',
        ),

        shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        primary: Colors.indigo.shade800,



      )
  ),

);