import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop/project/mvc/1.model/category/category.dart';
import 'package:shop/project/utilities/widget_utility.dart';
import '../../../api/api.dart';
import '../../3.controller/authentication/authentication.dart';

class ShowCategories extends StatefulWidget {


  @override
  _ShowCategoriesState createState() => _ShowCategoriesState();
}

class _ShowCategoriesState extends State<ShowCategories> {
  List<Category>categories=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    String txt="";
    Authentication auth=Authentication();
    return Scaffold(
      appBar: AppBar(
        actions: [

        ],
      ),
      body:Container(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              FutureBuilder(
                future:getData("getcategories",'general') ,
                builder:(BuildContext context,AsyncSnapshot  snapshot)
                {
                  categories=[];

                  switch(snapshot.connectionState)
                  {
                    case ConnectionState.waiting:{return Loading();}
                    case ConnectionState.none : {return ShowErrorWidget("error");}
                    case ConnectionState.done||ConnectionState.active:{
                      if(snapshot.hasError)
                        return ShowErrorWidget(snapshot.error.toString());
                     else if(!snapshot.hasData)
                          return ShowErrorWidget("no data found");
                     else
                        {
                          snapshot.data.forEach((map) {
                            categories.add(Category.fromJson(map));
                          });
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),

                            itemBuilder:(context,position){
                              return drawCard(position);

                            }
                            ,
                            itemCount:categories.length ,
                          );
                         }
                      }

                  }
                  return Container();

                }  ,
              ),
            ],
          ),
        ),
      ),

    );
  }


  Widget drawCard(int index)   {

   late String url;

    if(categories[index].image_url!=null)
    {
      url=categories[index].image_url!;
      url=url.split('/')[1];

    }

     if(index%2==0)
       return InkWell(
      onTap:(){
       } ,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(child: Text(categories[index].name!,style: TextStyle(fontSize: 16,backgroundColor: Colors.white,color:Colors.red),)),
            SizedBox(width:8 ),
            Card(child:
            url!=null?
          /*  Expanded(

               child:FutureBuilder(
                  future:downloadImage(url),
                  builder:(BuildContext context,AsyncSnapshot snapshot)
                  {
                    if(snapshot.connectionState==ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator());
                    else if(snapshot.connectionState==ConnectionState.done && !snapshot.hasError)
                      if(snapshot.hasData && snapshot.data.length>0)
                        return SizedBox(
                            width: 250,
                            height: 250,
                            child: Image.network(snapshot.data.toString()));



                      else return Image.asset('assets/images/empty.jpg');

                    return Container();
                  }
              ),

             )
                :Container()
            ),
            Divider(thickness: 5,),
          ],
        ),
      ),
    );
   else  return InkWell(
      onTap:(){
      } ,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [

            Card(child:
            url!=null?
            Expanded(
                child:FutureBuilder(
                  future:downloadImage(url),
                  builder:(BuildContext context,AsyncSnapshot snapshot)
                  {
                    if(snapshot.connectionState==ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator());
                    else if(snapshot.connectionState==ConnectionState.done && !snapshot.hasError)
                      if(snapshot.hasData && snapshot.data.length>0)
                        return SizedBox(
                            width: 250,
                            height: 250,
                            child: Image.network(snapshot.data.toString()));



                      else return Image.asset('assets/images/empty.jpg');

                    return Container();
                  }
              )

             )*/

           Expanded(
              child: SizedBox(
                  width: 250,
                  height: 250,
                  child: Image.network(url)),
            )   :Container()
            ),
            SizedBox(width:8 ),
            Expanded(child: Text(categories[index].name!,style: TextStyle(fontSize:16,backgroundColor: Colors.white,color:Colors.red),)),
            Divider(thickness: 5,),
          ],
        ),
      ),
    );

     return Container();


  }



}
