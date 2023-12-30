import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shop/project/api/review_api.dart';
import 'package:shop/project/bloc_state/user_bloc/user_bloc.dart';
import 'package:shop/project/mvc/1.model/customer/User.dart';
import 'package:shop/project/mvc/1.model/product/Product.dart';
import 'package:shop/project/mvc/1.model/review/review.dart';
import 'package:shop/project/utilities/helperfile.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/project/utilities/widget_utility.dart';
import '../authentication/loginPage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:expandable_sliver_list/expandable_sliver_list.dart';


class ShowReviews extends StatefulWidget {
  Product product;
  ShowReviews(this.product);

  @override
  _ShowReviewsState createState() => _ShowReviewsState();
}

class _ShowReviewsState extends State<ShowReviews> {
  List<Review>reviewsList=[];
  int userId=0;
  late User currentUser;
  bool submitted=false;
  late ValueNotifier count;
   ReviewApi reviewApi=ReviewApi();
  ExpandableSliverListController<Review> _controller =
  ExpandableSliverListController<Review>();

@override
  void initState() {
    // TODO: implement initState

     count=ValueNotifier<int>(widget.product.reviews.length);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: TextUtility("Show Reviews", 20,Colors.white,2, FontWeight.bold),
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder(
        future: reviewApi.getReviews("getreview/${widget.product.product_id}","") ,
        builder: (BuildContext context,AsyncSnapshot <List<Review>> snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError)
              return Center(child: Text(snapshot.error.toString()));
            else if (snapshot.data!.length > 0) {
                reviewsList=snapshot.data!;
                _controller.setItems(reviewsList);
               count.value=reviewsList.length;


            }
          }
          return drawRating();
        }
        )


    );


  }


  Widget drawRating()
  {
       currentUser =BlocProvider.of<UserBloc>(context).user;
       userId=currentUser.user_id;
       isSubmited();

           return SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: [

                  ValueListenableBuilder(
                            valueListenable: count,
                         builder: (context, state,_) {
                          return Padding(
                            padding: const EdgeInsets.only(top:10),
                            child: TextUtility("Total Reviews: ("+count.value.toString()+")", 20, Colors.black, 1,FontWeight.bold),
                          );
                        },
                      ) ,

                  !submitted? Container(
                    width: 150,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: StadiumBorder(),
                        backgroundColor: Colors.indigo,

                      ),

                      onPressed: ( )async
                      {
                        //userBloc.add(GetUserEvent());

                        if(userId==0)
                        {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) {
                            return LoginPage();
                          })).then((value) => this);
                        }
                        else showdialog();

                      },
                      child: TextUtility("Add rating",16,Colors.white,2,FontWeight.bold),

                    ),



                  ):Container(),
                  SizedBox(height: 10,),
                  drawLine(),
                  CustomScrollView(
                    physics: ScrollPhysics(),
                  shrinkWrap: true,
                    slivers: [
                      ExpandableSliverList<Review>(

                        controller: _controller,
                        initialItems: reviewsList,
                        builder: (context,rev,index){
                          return  reviewCard(rev,index);
                        },
                      ),
                    ],
                  )
                ],
              ),


        );

  }

  Widget reviewCard(Review review,int index) {

  Widget card=Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
             Row(
              children: [
                TextUtility(review.reviewer.fullName().toString(),16,Colors.black,1,FontWeight.bold),
                SizedBox(width:5 ),
                Row(
                  children:getStars(review.stars),

                ),


              ],
            ),
            SizedBox(height:10 ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: TextUtility(review.text.trim(),16,Colors.black,1,FontWeight.normal)),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      onPressed: (){

                      },
                      icon: Icon(FontAwesomeIcons.heart)
                  ),
                )
              ],
            ),
            SizedBox(height:20 ),
            Align(
                alignment: Alignment.bottomRight,
                child: TextUtility(review.date,18,Colors.black,1,FontWeight.bold))
          ],
        ),
      ),
    );

   if(review.reviewer.user_id==currentUser.user_id)
        return Slidable(
      actionPane: SlidableDrawerActionPane(),

      actionExtentRatio: 0.50,
      child: card,
      actions: [

      ],
      secondaryActions: [
        IconSlideAction(

          closeOnTap:true ,
          foregroundColor:Colors.deepPurple ,
          onTap: ()async {
             try{
               await reviewApi.deleteReview(review.id);

               setState(()  {
                   submitted=false;
               });
                // widget.product.reviews.remove(review);
                  //reviewsList.remove(review);
;            }
            catch(e){show_error_dialog_box(e.toString(), context);};
           },

          icon:Icons.delete,

          caption: 'حذف',

        ),
        IconSlideAction(
          icon: Icons.edit,
          caption: "تعديل",

          color: Colors.grey.shade200,
          foregroundColor: Colors.deepPurple,
          onTap:(){
            print(widget.product.product_id);

          } ,

        ),
      ],
    );

  else  return card;
  }


  List<Widget>  getStars(int stars) {

    List<Widget> starList=[];
    int i=0;

    while(i<5)
    {
      if(i<stars)
        starList.add(Icon(Icons.star,color: Colors.amberAccent,));
      else starList.add(Icon(Icons.star_border,color: Colors.amberAccent,));


      i++;
    }
    return starList;
  }


  Widget  drawLine() {

    return Container(
       color: Colors.grey.shade300,
      height: 3,
      width:MediaQuery.of(context).size.width*0.7,
    );
  }


  showdialog(){
    final _dialog = RatingDialog(
      initialRating: 1.0,
      // your app's name?
      title: Text(''),

      // encourage your user to leave a high rating?
      message: Text(''),
      // your app's logo?
      submitButtonText: 'Submit',
      commentHint: 'Comment...',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response)   async {
           if(response.comment.length==0)
             return;
        currentUser=BlocProvider.of<UserBloc>(context).user;

        await reviewApi.addToReviews(widget.product.product_id, response.rating.floor(), response.comment);
        _controller.setItems(reviewsList);
        //Review r=Review(0, response.rating.floor(),response.comment, currentUser,convertDate(DateTime.now().toString()));
        //widget.product.reviews.add(r);
         //reviewsList.insert(0,r);


     //   reviewsList.insert(0,r );
       // _controller.setItems(reviewsList);
         //count.value=reviewsList.length;
        alertdialog (context,"submited");

        // TODO: add your own logic

      },
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: true, // set to false if you want to force a rating
      builder: (context) => _dialog,
    );

  }

  Future<void>isSubmited()async
  {
       reviewsList.forEach((rev) {

         if(userId==rev.reviewer.user_id)
           {
             submitted=true;
                return;
           }

    });
  }
}
