import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:lottie/lottie.dart';
import 'package:shop/project/mvc/1.model/category/Category_Tree.dart';
import 'package:shop/project/mvc/1.model/option/option.dart';
import 'package:shop/project/mvc/3.controller/category/category_controller.dart';
import 'package:shop/project/mvc/2.view/product/show_single_product.dart';
import 'package:shop/routes.dart';
import 'package:shop/project/utilities/widget_utility.dart';

import '../../../bloc_state/category_bloc/category_bloc.dart';
import '../../../bloc_state/product_bloc/product_bloc.dart';
import '../../../bloc_state/user_bloc/user_bloc.dart';
import '../../../localization/change_language.dart';
import '../../../utilities/helperfile.dart';
import '../../1.model/category/category.dart';
import '../../1.model/product/Product.dart';
import '../product/show_single_product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState  extends State<HomePage> {
   List<Product>products = [];
  List<Category>categories = [];
  late ProductBloc _productBloc;
  late CategoryBloc _categoryBloc;
  ValueNotifier<int> pageIndexNotifier = ValueNotifier(0);
  final ScrollController _scrollController = ScrollController();
  List<Product>randomlist = [];
  ValueNotifier<int>cat_ind=ValueNotifier(0);
  ValueNotifier<bool> categoriesLoaded=ValueNotifier(false);
   ValueNotifier<String> tree=ValueNotifier('');

   bool isLoading = false;
   int category_index = 0;
   bool first=true;
    static late double scroller_max;
   List<CategoryTree> categoryTree=[];
   CategoryControlller _productReposiory=CategoryControlller();
   List<CategoryTree>selected_category=[];
   String? path="";
   String? language;

  HomePage() async {
      //_productStream.productSink;
     //_productStream.productSink.add([]);
       first=true;
    _scrollController.addListener(setController);
   }

  void setController() {
         double position;

    if(_productBloc==null) {
      return;
    }

    _scrollController.addListener(() async {

      scroller_max=_scrollController.position.maxScrollExtent;

      if(scroller_max>0) {
        position=scroller_max;
      } else {
        return;
      }

     if (_productBloc.finish || isLoading) {
        return;
      }

      if (_scrollController.position.atEdge)
        // ignore: curly_braces_in_flow_control_structures
        if (_scrollController.position.pixels != 0) {
           _productBloc.add(GetProductsEvent(categories[category_index].id!));
          // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
           isLoading = true;
                Future.delayed(Duration(seconds: 1)).then((value) async {
                 // _scrollController.animateTo(  , duration: Duration(seconds: 3), curve: Curves.easeInOut);
                  print("position=  ${position}");

                  _scrollController.jumpTo(position/2+500);


                });



        }

  });
  }

  @override
  Widget build(BuildContext context) {

    deviceDemensions(context);

    language=Get.locale?.languageCode;
   _productBloc=BlocProvider.of<ProductBloc>(context);
    _categoryBloc=BlocProvider.of<CategoryBloc>(context);

    return Scaffold(

      backgroundColor: Colors.grey.shade100,
      drawer:ValueListenableBuilder(
            valueListenable: categoriesLoaded,
            builder: (context,value,_){
              if(categoryTree.length>0) {
                return Directionality(
                    textDirection: language=="ar"?TextDirection.rtl:TextDirection.ltr,
                    child: Drawer(
                         child: drawer()));
              }
             return Text('');
            },
      ),

      body:WillPopScope(
        onWillPop:(){
          return showAlertDialog("do you want to exit the application");
          },

        child: createPage(),
      ),

    );
}


   Widget drawContent(BuildContext context)
   {
     return  Container(
         padding: const EdgeInsets.all(10),
         decoration: const BoxDecoration(
             color:  Color(0xFFEDECF2),
             borderRadius: BorderRadius.only(
                 topLeft:Radius.circular(40),
                 topRight:Radius.circular(40)
             )
         ),
         child: GridView.builder(
           shrinkWrap: true,
           physics: const NeverScrollableScrollPhysics(),
           itemCount:products.length ,
           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount:2,

             childAspectRatio:0.38,
             //mainAxisSpacing:1,
             //crossAxisSpacing: 1
           ) ,
           itemBuilder:(context,position){

             return drawGridView(position);

           } ,


         )
     );



   }

Widget? drawRandomImages() {

       if(randomlist.length>0) {
         return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        spreadRadius: 2,
                        color: Colors.grey,

                      )
                    ]
                ),
                height:screen_height!*0.27 ,
                width:double.infinity ,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(6),
                child: PageView.builder(
                  onPageChanged: (index){
                    pageIndexNotifier.value=index;
                  },
                    itemCount: randomlist.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder:(context,index){
                       return  drawImage(randomlist[index], context);
                    }
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: pageIndexNotifier,
                  builder:(BuildContext context,int index,_){
                    return PageIndicator(num:randomlist.length,page: index);
                  }
              ),
            ],
          );
       }

       return Text('');




}


Widget drawImage(Product product, BuildContext context) {
     String? url;

  if (product.images != null)
    if (product.images.length > 0) {
      url = product.images[0].url!;

      //url = url.split('/')[1];
    }

  return   InkWell(
    onTap: () {
       Get.to(ShowProduct(product));
    },
    child:url!=null?DrawImage(url:url,width:200,height:225): Image.asset("assets/images/emptyimage.jpg", fit: BoxFit.cover,width: 200,height: 225,));
}

Widget drawIcon(String? url) {


     return url != null ?
     DrawImage(url:url,width:200,height:225) : Text('');
  }


Widget drawCategories(CategoryTree _categoryTree,int index) {
    Random r=Random();

    return  InkWell(
          onTap: (){
            //_productBloc.products=[];
             path='';
            _productBloc.page=1;
            _productBloc.finish=false;
                 print("++++++++++++ ${_categoryTree.id} ${_categoryTree.name} ++++++++");
            _categoryTree=findChild(_categoryTree.id!)!;
            path=getPath(_categoryTree,_categoryTree.name!)??'';

            if(_categoryTree.children.length>0) {
              setState(() {
                   selected_category=_categoryTree.children;
            });
            }
            _productBloc.add(GetProductsEvent(_categoryTree.id!));
             category_index=index;
             cat_ind.value=index;

           } ,
          child :Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),

                   padding: EdgeInsets.symmetric(horizontal: 14,vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_categoryTree.name!,style: Theme.of(context).textTheme.titleMedium,),
                      SizedBox(width: 5),
                      Container(
                          height: 50,
                          width:50 ,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color:  cat_ind.value==index? Colors.green.shade100:Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    color: Colors.black
                                )
                              ]
                          ),


                          child: Center(child:_categoryTree.icon_url!=null? drawIcon(_categoryTree.icon_url):CircleAvatar(child:TextUtility(_categoryTree.name!.substring(0,2),18,Colors.white,1,FontWeight.bold),backgroundColor:Color.fromARGB(255, r.nextInt(255), r.nextInt(255), r.nextInt(255)))
                          ))
                    ],
                  ),
          ),
        );






}






  int getColors(List<Option> options) {
    int sum=0;
    List<String> colors=[];

    for(int i=0;i<options.length;i++) {
      if(options[i].color!=null && !colors.contains(options[i].color))
        {
          colors.add(options[i].color??'');
          sum++;
        }
    }
    return sum;

  }


   @override
   void dispose() {
    if(mounted)
      _scrollController.dispose();


   }

  List<CategoryTree> getchildren(Category category) {
    List<CategoryTree> catTree=[];

           categories.forEach((cat) {
                 if(cat.parent_id==category.id) {
                   catTree.add(CategoryTree([], category, cat.id!, cat.name!, cat.image_url??null, cat.icon_url??null,category.parent_id??null));
                 }
           });

           return catTree;
  }

  CategoryTree? getparent(int parent_id) {

      CategoryTree? ct;

    if(parent_id!=null)
       {
         categories.forEach((cat) {
           if(cat.id==parent_id) {
             ct=CategoryTree([],null,cat.id!,cat.name!,cat.image_url??null,cat.icon_url??null,parent_id);
           }
         });
       }
    return ct;


   }

drawer()
{
  List<CategoryTree>mainCat=[];
  categoryTree.forEach((element) {
    if(element.parent_id==null) {
      mainCat.add(element);
    }
  });
   return Directionality(
     textDirection: language=="ar"?TextDirection.rtl:TextDirection.ltr,
     child: ListView.builder(
     itemCount: mainCat.length+1,
     itemBuilder:(context,index){
               if(index==0) {
                 return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Image.asset("assets/images/onboarding2.jpg",fit: BoxFit.cover,width:double.infinity ,height: 150,),
                    SizedBox (height:10),
                    const Divider(
                      thickness: 1,
                      color: Colors.green,
                    ),
                     SizedBox(height: 5,),
                     ListTile(
                        leading:IconButton(
                            onPressed:(){
                               Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return ChangeLanguage();
                              }));
                            },
                            icon:const Icon(Icons.settings,color: Colors.deepOrangeAccent,)
                        ),
                        title:Text('6'.tr,style: Theme.of(context).textTheme.titleSmall),
                      ),
                     ListTile(
                        leading:IconButton(
                           onPressed:(){
                             Navigator.pop(context);
                             Get.toNamed(AppRoute.signIn);
                           },
                           icon:Icon(Icons.login,color: Colors.deepOrangeAccent)
                       ),
                       title:Text("7".tr,style: Theme.of(context).textTheme.titleSmall) ,
                     ),
                     ListTile(
                        leading:IconButton(
                            onPressed: () async {
                              first=true;
                              _productBloc.finish=false;
                              _productBloc.page=1;
                              _productBloc.add(GetProductsEvent(-1));
                              _categoryBloc.add(GetCategoryEvent());
                               Navigator.pushReplacementNamed(context, AppRoute.home).then((value) {
                                 setState(() {

                                 });
                               });
                              //Navigator.pop(context);

                            },
                            icon:Icon(Icons.home,color: Colors.deepOrangeAccent)
                        ),
                        title:Text('2'.tr,style: Theme.of(context).textTheme.titleSmall,) ,
                      ),

                    Divider(
                       thickness:1,
                       color: Colors.green
                      ),
                    SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextUtility('9'.tr,20,Colors.deepPurple,1,FontWeight.bold),
                      ),

                    ],
                   );
               } else {
                 return drawMainList(mainCat[index-1]);
               }

     },
 ),
   );
}

   
Widget drawMainList(CategoryTree _categoryTree)
{
    if(_categoryTree.children.length>0) {
      return Directionality(
       textDirection: language=="ar"?TextDirection.rtl:TextDirection.ltr,

       child: ExpansionTile(

          onExpansionChanged: (e){
           path='';
           _productBloc.page=1;
           _productBloc.finish=false;
           cat_ind.value=categoryTree.indexOf(_categoryTree);
           path=getPath(findChild(_categoryTree.id!)!,_categoryTree.name!);

           setState(() {
              selected_category=_categoryTree.children;
             });
           _productBloc.add(GetProductsEvent(_categoryTree.id!));

           // Navigator.pop(context);
          },
         leading: Container(
             width: 35,
             height: 35,
             child: drawIcon(_categoryTree.icon_url??null)),
         title: Text(_categoryTree.name!,style: Theme.of(context).textTheme.titleMedium,),

         children: [
           for(int i=0;i<_categoryTree.children.length;i++)
             drawMainList(findChild(_categoryTree.children[i].id!)!)

          ],
       ),
     );
    } else {
      return Directionality(
      textDirection: language=="ar"?TextDirection.rtl:TextDirection.ltr,

      child: ListTile(
         leading: Container(
            width: 35,
            height: 35,
            child: drawIcon(_categoryTree.icon_url??null)),

        title: Text(_categoryTree.name!,style: _categoryTree.parent_id==null?Theme.of(context).textTheme.titleMedium:null),
        onTap: (){
          path='';
          path=getPath(findChild(_categoryTree.id!)!,_categoryTree.name!)??'';
          _productBloc.page=1;
          _productBloc.finish=false;
          _productBloc.add(GetProductsEvent(_categoryTree.id!));

          //Navigator.pop(context);
          },
     ),
  );
    }
}

  CategoryTree? findChild(int id) {
    for(int i=0;i<categoryTree.length;i++) {
      if(categoryTree[i].id==id) {
        return categoryTree[i];
      }
    }

  }

   String? getPath(CategoryTree _categoryTree,String name) {
      CategoryTree ct;

      print("&&&&&&&&&&&&   ${_categoryTree.id} ${_categoryTree.name} ${name} &&&&&&&&");
         if(_categoryTree.parent_id==null)
           {
             tree.value=path!+name;

              path="";
             return path;
           }
         ct=findChild(_categoryTree.parent_id!)!;
          path=ct.name!+">"+path!;
          getPath(ct,name);

  }

 Widget createPage() {
    return SingleChildScrollView(
        controller: _scrollController,
        physics: ScrollPhysics(),
        child:Column(
          children: [
            CustomAppBar(title:"Online Shopping"),
            drawSearchBar(),
            drawRandomItems(),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 17),
                child: ValueListenableBuilder(
                    valueListenable:tree,
                    builder:(context,val,_){
                      return TextUtility(val.toString(),16,Colors.black,1,FontWeight.normal);
                    }
                ),
              ),
            ),
            BlocBuilder<CategoryBloc,CategoryState>(
              builder: (context,state){
                if(state is GetCategoriesState) {
                  categories=state.categories;
                }
                if(categories.isNotEmpty)
                  // ignore: curly_braces_in_flow_control_structures
                  if (first) {
                    first = false;
                    _productBloc.add(GetProductsEvent(0));
                    categories.forEach((cat) {
                      categoryTree.add(CategoryTree(
                          getchildren(cat),
                          cat.parent_id!=null?getparent(cat.parent_id!) as Category:null,
                          cat.id!,
                          cat.name!,
                          cat.image_url,
                          cat.icon_url,
                          cat.parent_id));
                    });
                    categoriesLoaded.value = true;
                  }
                return Padding(
                  padding: const EdgeInsets.only(top: 12,bottom: 12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ValueListenableBuilder(
                      valueListenable: cat_ind,
                      builder:(context,index,w){
                        return Container(
                          //color: Colors.green.shade400,
                          child: selected_category.length==0?
                          Row(
                            children: [
                              for(int i = 0; i < categoryTree.length; i++)
                                if(categoryTree[i].parent_id==null)
                                  drawCategories(categoryTree[i],i),
                            ],):
                          Row(
                            children: [
                              for(int i = 0; i < selected_category.length; i++)
                                drawCategories(selected_category[i],i),
                            ],),
                        );
                      } ,
                    ),
                  ),

                );

                return Text('');
              },
            ),
            BlocBuilder<ProductBloc,ProductState>(
                builder: (context,state){
                  if(state is ProductsLoadingState) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Center(child: Center(child: Lottie.asset("assets/lottie/loading2.json",width: 100,height: 100))),
                    );
                  }
                  if(state is ProductsLoadedState)
                  {
                    isLoading=false;
                    products=state.products;
                    if(products.length>0) {
                      return drawContent( context);
                    }
                    return Text('');

                  }
                  else   if(state is ErrorState)
                    // ignore: curly_braces_in_flow_control_structures
                    return Center(child: Text(state.message));

                  return Text('');


                }
            ),
            BlocBuilder<UserBloc,UserState>(
              builder: (context,state){
                if(state is GetUserState && state.user!=null) {
                  print(state.user!.fullName());
                }
                return const Text('');
              },
            ),

          ],
        )


    );
 }

 Widget drawSearchBar() {
    return             UnconstrainedBox(
      child: Container(
        width:320 ,
        height: 45,
        margin: const EdgeInsets.symmetric(vertical:8,horizontal: 7 ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.5),
                spreadRadius: 4,
                blurRadius:12,


              )
            ]
        ),

        child: Row(
          children: [
            Container(
              width:200 ,
              margin: EdgeInsets.only(left:20),
              child: TextFormField(

                decoration:const InputDecoration(
                    border: InputBorder.none,
                    hintText: "search...",
                    hintStyle:TextStyle(
                        fontWeight: FontWeight.bold,letterSpacing: 1
                    )
                ),

              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right:20),
              child: IconButton
                (
                  onPressed: (){

                  },
                  icon:Icon(Icons.search)
              ),
            )
          ],
        ),
      ),
    );

 }

 Widget drawRandomItems() {
    return             FutureBuilder(
        future:_productReposiory.getRandomProducts(),
        builder:(BuildContext context,AsyncSnapshot<List<Product>> snapshot){
          if(snapshot.connectionState==ConnectionState.waiting) {
            return Center(child: Image.asset("assets/images/emptyimage.jpg",width: 100,height: 100));
          } else if(snapshot.hasError)
            // ignore: curly_braces_in_flow_control_structures
            return Center(child: Text(snapshot.error.toString()),);
          else if(snapshot.connectionState==ConnectionState.done)
            // ignore: curly_braces_in_flow_control_structures
            if(snapshot.hasData)
            {
              randomlist=snapshot.data!.toList();
              return drawRandomImages()!;
            }
          return Text('');
        }
    );

 }

  Widget drawGridView(int position) {
    double discount=products[position].discount;
    double price=products[position].price;
    double discountedprice=0;
    int colors=getColors(products[position].options);

    if(discount>0) {
      discountedprice=price-price*discount;
    }

    return  Container(

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,

        ),
        // padding: EdgeInsets.all(6),
        margin: EdgeInsets.symmetric(horizontal: 4,vertical: 10),
        child:Column(
          children: [

            Stack(
              children: [

                drawImage(products[position], context),
                Positioned(
                  top:12,
                  left:14 ,
                  child: discount>0?    Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: Colors.indigo,

                    ),
                    child:   Text("- ${discount} %", style: const TextStyle(color: Colors
                        .white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),),
                  ):Text(''),
                ),
                Positioned(
                  top:12,
                  right:14,
                  child:  Container(
                      height:45,
                      width:45 ,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color:Colors.white,
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 3,
                                color: Colors.black.withOpacity(0.6)
                            )
                          ]
                      ),


                      child: Center(child:FaIcon(FontAwesomeIcons.heart,size: 30,))),
                ),
                colors>1?Positioned(
                  bottom:10,
                  right: 12,
                  child:  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 10,
                              spreadRadius: 2
                          )
                        ]
                    ),
                    height: 30,
                    width: 60,
                    child: Stack(
                      children: [
                        Positioned(
                            top:8,
                            left: 19,
                            child: Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.orangeAccent,
                                  boxShadow: const[
                                    BoxShadow(
                                        spreadRadius: 2,
                                        color: Colors.white,
                                        blurRadius: 5
                                    )
                                  ]
                              ),
                            )
                        ),
                        Positioned(
                            top:8,
                            left: 10,
                            child: Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueAccent,
                                  boxShadow:const [
                                    BoxShadow(
                                        spreadRadius: 2,
                                        color: Colors.white,
                                        blurRadius: 5
                                    )
                                  ]
                              ),
                            )
                        ),

                        Positioned(
                            top: 1,
                            right:10 ,
                            child: Text(colors.toString(),style: Theme.of(context).textTheme.titleMedium,))
                      ],
                    ),
                  ),
                ):Text(''),


              ],
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6) ,
              child:DrawRating(product:products[position]),
            ),
            //  SizedBox(height: 10,),
            Expanded(
              child: Container(
                height:120 ,

                width:double.infinity ,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 5),
                child:Stack(
                  //fit: StackFit.expand,
                  children: [
                    Positioned(
                      top:0,
                      left: 2,
                      right: 2,
                      child: Container(
                        height: 100,
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RichText(
                                //textScaleFactor: 1.0,
                                //textAlign: TextAlign.justify,
                                //textDirection: TextDirection.ltr,
                                overflow: TextOverflow.ellipsis,
                                //textWidthBasis: TextWidthBasis.parent,
                                maxLines: 3,

                                //textScaleFactor:1,
                                text: TextSpan(
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(text: products[position].name, style: Theme.of(context).textTheme.titleMedium,),
                                      TextSpan(text: '..',style: TextStyle(color: Colors.white)),
                                      TextSpan(text: products[position].description,style: Theme.of(context).textTheme.titleSmall),


                                    ]
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    discountedprice>0?
                    Stack(
                      //fit: StackFit.expand,
                      children: [
                        Positioned(
                          bottom: 15,
                          left: 4,
                          child: Column(
                              children: [
                                Text("\$ ${price} ", style: TextStyle(color:Colors.black.withOpacity(0.5),fontSize: 16,decoration: TextDecoration.lineThrough),),
                                const SizedBox(height:6 ),
                                Text(" \$ $discountedprice", style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                              ]),
                        ),
                        const Positioned(
                          bottom: 15,
                          right:4,
                          child: Icon(Icons.add_shopping_cart, size: 35,
                            color: Colors.green,),
                        )
                      ],
                    ):
                    Stack(
                      //    fit: StackFit.expand,
                        children: [
                          Positioned(
                            bottom: 15,
                            left: 4,
                            child: Text("\$ ${price}", style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),),
                          ),
                          Positioned(
                            bottom: 15,
                            right: 4,
                            child: IconButton(
                                onPressed: (){
                                  print("LLLL ${_scrollController.position.maxScrollExtent}");
                                  // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

                                },
                                icon:const Icon(Icons.add_shopping_cart, size: 35,
                                  color: Colors.green,)),
                          )
                        ])
                  ],
                ),
              ),
            ),

          ],
        )

    );
  }


  
   
 


 }
