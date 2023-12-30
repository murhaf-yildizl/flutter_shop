import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shop/project/api/api.dart';
import 'package:shop/project/mvc/1.model/cartItem/cartitem.dart';
import 'package:shop/project/mvc/2.view/home_page/homepage.dart';
import 'package:shop/project/mvc/2.view/payment/create_payment.dart';
import 'package:shop/project/mvc/1.model/product/Product.dart';
import 'package:shop/project/mvc/2.view/product/show_single_product.dart';
import 'package:shop/project/utilities/widget_utility.dart';
import 'package:shop/project/utilities/helperfile.dart';
import '../../../bloc_state/cart_bloc/cart_bloc.dart';
import '../../1.model/option/option.dart';
import '../../1.model/cart/cart.dart';


class ShowCart extends StatefulWidget {

  @override
  _ShowCartState createState() => _ShowCartState();

}

class _ShowCartState extends State<ShowCart> {
    Cart? cart;
    CartBloc? cartBloc;
  ScrollController _scrollController=ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    cartBloc=BlocProvider.of<CartBloc>(context);
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    return BlocBuilder<CartBloc,CartState>(
        builder:(context,state) {
           return Scaffold(
            body: drawBody(state),
            bottomNavigationBar: drawBottomBar(state),
          );
        }
        );

    }

  Widget drawCard(CartItem item,int index) {
    Product product=item.product;
    double price=product.price;
    bool discount=false;
    Option option=item.options;

    if(product.discount>0)
    {
      price=price-(product.discount*price);
      discount=true;
    }

      String? url;

    if(option!=null && option.imagesList!=null)
      if(option.imagesList.length>0)
        url=option.imagesList[0].url!;

      else if(option==null && item.product.images.length>0)
        url=item.product.images[0].url!;

      if(url!=null)
        url=storage_path+url;

    return  Card(
      elevation: 20,
      margin: EdgeInsets.only(bottom: 10),
      child: Container(
        padding: EdgeInsets.all(10 ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            url!=null?

            InkWell(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                  return ShowProduct(product);
                }));
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  height:150,
                  width:100 ,
                  child: Image.network(url,fit: BoxFit.cover,)),
            )
                :
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ShowProduct(product);
                }));
              },
              child: Container(
                width:100 ,
                child: Image.asset("assets/images/emptyimage.jpg",fit: BoxFit.contain,
                ) ,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                //color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      width: 160,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: RichText(
                              textScaleFactor: 1.0,
                              // textAlign: TextAlign.justify,
                              textDirection: TextDirection.ltr,
                              overflow: TextOverflow.ellipsis,
                              textWidthBasis: TextWidthBasis.longestLine,
                              maxLines: 3,

                              //textScaleFactor:1,
                              text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(text: item.product.name, style: Theme.of(context).textTheme.titleMedium,),
                                    TextSpan(text: '..',style: TextStyle(color: Colors.white)),
                                    TextSpan(text: item.product.description,style: Theme.of(context).textTheme.titleSmall),


                                  ]
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    option.size!=null && option.size!=''?TextUtility('size: ${option.size}',16,Colors.black,1,FontWeight.normal):Text(''),
                  ],
                ),
              ),
            ),
            Container(
              //color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: (){
                        cartBloc!.add(DeleteItemEvent(item.id));

                      },
                      icon: Icon(Icons.delete,color: Colors.red ,)
                  ),
                  Text(product.price.toString()+ "  \$",style:TextStyle(fontSize:16,color:discount?Colors.black.withOpacity(0.4):Colors.black,fontWeight: FontWeight.bold,decoration: discount?TextDecoration.lineThrough:null,decorationColor: Colors.black.withOpacity(0.4) ,decorationThickness:1.5 ),),
                  SizedBox(height: 5,),

                  item.qnty==1 && !discount?Text(""):
                  Text(("${(price*item.qnty).toStringAsFixed(2)} \$"),style:TextStyle(fontSize:18,color:Colors.black,fontWeight: FontWeight.bold, )),
                  SizedBox(height: 20,),
                  createButton(item)



                ],
              ),
            )


          ],),
      ),
    );



  }



  Widget createButton(CartItem item)
  {
    int q=0;

    return  Container(
      width:100 ,
      height:35 ,
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
          boxShadow:
          [
            BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                blurRadius: 8,
                spreadRadius: 2
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: () {

                if(item.qnty>1)
                {
                  cartBloc!.add(RemoveFromCartEvent(item.id));

                  _scrollController.animateTo(0,duration: Duration(seconds: 1),curve: Curves.easeInOut);


                }
              },
              child: Icon(
                Icons.remove,
                color:item.qnty>1? Colors.orange:Colors.grey.shade400,
                size: 20,
              )),
          Container(
            margin: EdgeInsets.all(1),
            width:30 ,
            height:30 ,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.orange.withOpacity(0.2)),
            child: Center(
                child:TextUtility(item.qnty.floor().toString(),16,Colors.orange.shade900,1,FontWeight.normal)
            ),
          ),

          InkWell(
            onTap: () {

              if(item.options==null)
                q=item.product.qnty;
              else q=item.options.qnt!;
              if(item.qnty<q) {
                cartBloc!.add(
                    AddToCartEvent(item.product.product_id, 1, item.options));
                _scrollController.animateTo(0,duration: Duration(seconds: 1),curve: Curves.easeInOut);

              }


            },
            child: Icon(
              Icons.add,
              color: item.qnty<item.options.qnt!? Colors.orange:Colors.grey.shade400,
              size: 20,
            ),

          ),
        ],
      ),
    );
  }

  Widget drawBody(CartState state) {

       if (state is CartIsLoadingState)
        return Center(child: Lottie.asset(
          "assets/lottie/loading2.json", width: 150, height: 150));

    else if (state is CartErrorState)
      return Center(child: Text(state.error));

    else if (state is GetCartState) {
      cart = state.cart!;
      if(cart!=null) {
        return SingleChildScrollView(
            reverse: false,
            controller: _scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomAppBar(title: "", page: "cart"),
                state.cart!.items_count == 0 ?
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: IconButton(
                          onPressed:(){
                            Get.to(HomePage());
                          },
                          icon: Icon(Icons.arrow_back_ios,size: 30,color: Colors.red,)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/images/emptycart.png',width: screen_width*0.50,height: screen_height*0.50, fit: BoxFit.contain,),
                    ),
                  ],
                )
                    : ListView.builder(
                  // reverse: true,
                  //controller: _scrollController,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    CartItem item = this.cart!.itemsList[index];
                    return drawCard(item, index);
                  },
                  itemCount: this.cart!.itemsList.length,
                ),
              ],
            )
        );
      }

      return Center(child: CircularProgressIndicator());
    }

    return Text('');
  }

Widget  drawBottomBar(CartState state) {
    if(state is GetCartState)
      if(state.cart!=null && state.cart!.items_count>0)
        return Offstage(
    offstage: false,
    child: Container(
      color: Colors.grey.shade100,
      height:70 ,
      margin: EdgeInsets.all(20),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextUtility('Total',20,Colors.indigo,3,FontWeight.bold),
              TextUtility(cart!.total.toStringAsFixed(2) +' \$',20,Colors.black,3,FontWeight.bold),

            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width*0.50,
            height:button_height ,
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), // Set the desired border radius
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.teal), // Set the desired background color
              ),

              onPressed: ()async{
                Navigator.push(context, MaterialPageRoute(builder:(context){
                  return CreatePayment();
                }));
              },
              child:TextUtility("Apply your cart", 18,Colors.white,2,FontWeight.bold) ,
            ),
          ),


        ],
      ) ,

    ),
  );

  return Text('');

}





}
