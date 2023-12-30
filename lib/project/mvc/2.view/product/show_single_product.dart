import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shop/main.dart';
import 'package:shop/project/bloc_state/cart_bloc/cart_bloc.dart';
import 'package:shop/project/mvc/1.model/option/option.dart';
import 'package:shop/project/mvc/2.view/authentication/loginPage.dart';
import 'package:shop/project/mvc/2.view/cart/show_cart.dart';
import 'package:shop/project/mvc/2.view/review/show_reviews.dart';
import '../../1.model/product/Product.dart';
import '../../../utilities/get_color_from_hexa.dart';
import '../../../utilities/helperfile.dart';
import '../../../utilities/widget_utility.dart';

class ShowProduct extends StatefulWidget {
  Product product;

  ShowProduct(this.product);

  @override
  _ShowProductState createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  late Product product;
  late PageController _pageController;
  bool discoount = false;
  bool liked = false;
  bool pressed = false;
  ValueNotifier<int> pageIndexNotifier = ValueNotifier(0);
  late List<Option> options;
  late Option selected_option;
  late CartBloc provider;
  String? selectedColor;
  String? selectedSize;
  List<String> colorsList = [];
  List<String> sizesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.product = widget.product;
    options = product.options;
    selected_option = Option("", "", product.qnty, product.images);

    if (options.length > 0)
      {
        selected_option = options[0];

        if(selected_option.color!=null)
          selectedColor=selected_option.color;

        if(selected_option.size!=null)
          selectedSize=selected_option.size;
      }

    _pageController = PageController(initialPage: 0, viewportFraction: 0.75);
     provider = BlocProvider.of<CartBloc>(context);

    if (product.discount > 0) discoount = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        // appBar: _widgetUtility.appBar("Show Product"),
        body: SingleChildScrollView(
            child: Column(children: [
          CustomAppBar(title: "product"),
          drawContents()
        ])),
        bottomNavigationBar: drawButton());
  }


  Widget drawContents() {
    return Container(
      padding: EdgeInsets.all(10),
      //color: Colors.grey.shade100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      child: SingleChildScrollView(
        child: Column(
          children: [
            drawImageSlider(),
            drawIndicator(),
            drawFooter()
          ],
        ),
      ),
    );
  }

  Widget drawImageSlider() {
    double discount = product.discount;
    double price = product.price;
    double discountedprice = 0;

    if (discount > 0) discountedprice = price - price * discount;

    return Stack(
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
              ]),
          height: screen_height * 0.37,
          width: screen_width,
          margin:  EdgeInsets.all(10),
          padding: EdgeInsets.all(6),
          child:   drawPageView(),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: discount > 0
              ? Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: Colors.indigo,
                  ),
                  child: Text(
                    " - $discount %",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                )
              : const Text(''),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 3,
                        color: Colors.black.withOpacity(0.6))
                  ]),
              child: const Center(
                  child: FaIcon(
                FontAwesomeIcons.heart,
                size: 30,
              )
              )
          ),
        ),
      ],
    );
  }

  Widget drawTitle() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
          color: Colors.grey.shade100, borderRadius: BorderRadius.circular(25)),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           drawReviews(),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              TextUtility("orders: +5k | likes: +1k ", 16, Colors.indigo, 1,
                  FontWeight.normal)
            ],
          ),
        ],
      ),
    );
  }

  void _showSizeConfirmation() {

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, _setState) {
            return Container(
               width:  double.infinity,
               height: Get.height*0.80,
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              height: 150,
                              width: 150,
                              child: DrawImage(url: selected_option.imagesList.length > 0
                                  ? selected_option.imagesList[0].url!:'',
                                  width: 150,
                                  height:150)),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 75,
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
                                              TextSpan(text:product.name, style: Theme.of(context).textTheme.titleMedium,),
                                              TextSpan(text: '..',style: TextStyle(color: Colors.white)),
                                              TextSpan(text:product.description,style: Theme.of(context).textTheme.titleSmall),


                                            ]
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              selectedColor != null
                                  ? Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  children: [
                                    TextUtility("color: ", 16,
                                        Colors.black, 1, FontWeight.bold),
                                    Container(
                                      height: 15,
                                      width: 15,
                                      decoration: BoxDecoration(
                                          color: HexColor(selectedColor!),
                                          border: Border.all(
                                              color: Colors.black,
                                              width: 2)),
                                    )
                                  ],
                                ),
                              )
                                  : Text(''),
                               Text(
                                product.price.toString() + "  \$",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: discoount
                                        ? Colors.black.withOpacity(0.4)
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    decoration: discoount
                                        ? TextDecoration.lineThrough
                                        : null,
                                    decorationColor:
                                    Colors.black.withOpacity(0.4),
                                    decorationThickness: 2.5),
                              ),
                              const SizedBox(height: 10),
                              discoount ?
                              TextUtility("${(product.price -(product.price *product.discount)).toStringAsFixed(3)} \$",
                                  14, Colors.black,1.5, FontWeight.bold) : Container()
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text("select size:"),
                    SizedBox(height: 10,),
                    Wrap(
                      spacing: 8.0,
                      children: sizesList.map((size) {
                        return GestureDetector(
                          onTap: () {
                            _setState(() {
                              selectedSize = size;
                            });
                          },
                          child: Chip(
                            label: Text(size),
                            backgroundColor:
                                selectedSize == size ? Colors.green : Colors.grey,
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          height: 80,
                          width: screen_width! * 0.70,
                          child: OutlinedButton(
                            onPressed: () async {
                              if (options.length > 0) {
                                if (selectedColor == null || selected_option.size != null &&
                                   (selectedSize == null || selectedSize == ''))
                                  return;
                              }

                              addTocart();
                            },
                            style: OutlinedButton.styleFrom(
                                shape: StadiumBorder(),
                                backgroundColor: Colors.teal),
                            child: !pressed
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextUtility("Add To Cart", 18,
                                    Colors.white, 2, FontWeight.bold),
                                const SizedBox(
                                  width: 30,
                                ),
                                const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.white,
                                  size: 40,
                                )
                              ],
                            )
                                : Center(child: CircularProgressIndicator()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget drawButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: EdgeInsets.only(top: 16, bottom: 10),
            height: 90,
            width: screen_width! * 0.90,
            child: OutlinedButton(
              onPressed: () async {
                if (pressed) return;

                int? userId = pref.getInt("user_id");

                if (userId == null) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }));
                } else {
                  ///if(options!=null && options.length>0 )
                  _showSizeConfirmation();
                  // else addTocart();
                }
              },
              style: OutlinedButton.styleFrom(
                  shape: StadiumBorder(), backgroundColor: Colors.teal),
              child: !pressed
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextUtility("Add To Cart", 18, Colors.white, 2,
                            FontWeight.bold),
                        const SizedBox(
                          width: 30,
                        ),
                        const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                          size: 40,
                        )
                      ],
                    )
                  : const Center(child: CircularProgressIndicator()),
            )),
      ],
    );
  }

  Widget drawIndicator() {

    if (selected_option.imagesList.length > 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ValueListenableBuilder(
            valueListenable: pageIndexNotifier,
            builder: (BuildContext context, int index, _) {
              int num = 1;
              if (options.length > 0 && selected_option.imagesList.length > 0)
                num = selected_option.imagesList.length;

              return PageIndicator(num: num, page: index);
            }),
      );
    }

    return const Text('');
  }

  Widget drawFooter() {
    return Card(
      color: Colors.white,
      //margin: EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            drawTitle(),
            SizedBox(height: 20),
            drawLine(),
            SizedBox(height: 20),
            options.isNotEmpty ? drawOptions() : Text(''),
            SizedBox(height: 20,),
            drawDescription(),
            const SizedBox(
              height: 30,
            ),
            drawLine(),
          ],
        ),
      ),
    );
  }

  Widget drawPageView() {
    return PageView.builder(
        onPageChanged: (index) {
          pageIndexNotifier.value = index;
        },
        itemCount: options.length > 0 && selected_option.imagesList.length > 0?
        selected_option.imagesList.length: 1,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          String? url;
          if (product.images.isNotEmpty) {
            if (selected_option == null ||
                selected_option.imagesList.isEmpty) {
              url = "empty";
            } else {
              url = selected_option.imagesList[index].url!;
              //  print("GGGGGG ${url}");
            }
          }
          return DrawImage(
            url: url,
            width: screen_width!,
            height: screen_height! * 0.37,
          );
        });
  }

  Widget drawReviews() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return ShowReviews(product);
                  }));
            },
            child: product.reviews.isNotEmpty
                ? DrawRating(product: product)
                : addRating()),
        const Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${product.price}  \$",
              style: TextStyle(
                  fontSize: 18,
                  color: discoount
                      ? Colors.black.withOpacity(0.4)
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                  decoration:
                  discoount ? TextDecoration.lineThrough : null,
                  decorationColor: Colors.black.withOpacity(0.4),
                  decorationThickness: 2.5),
            ),
            discoount? TextUtility(
                "${(product.price - (product.price * product.discount)).toStringAsFixed(2)} \$",18, Colors.black,1.5, FontWeight.bold)
                : Container()
          ],
        ),
      ],
    );
  }

  Widget addRating() {
    return Row(
      children: [
        Row(
            children: List.generate(
                5,
                    (index) => Icon(
                  Icons.star_border_sharp,
                  color: Colors.amberAccent,
                ))),
        SizedBox(
          width: 3,
        ),
        TextUtility("Rate now", 16, Colors.indigo, 1, FontWeight.bold)
      ],
    );
  }

  Widget drawOptions() {
    List<Widget> colors = [];
    List<Widget> sizes = [];
     colorsList=[];
     sizesList=[];

     if(options.length>0) {
      options.forEach((op) {
      if(op.color!=null && !colorsList.contains(op.color))
        {
          colors.add(
              InkWell(
                  onTap: (){
                    setState(() {
                      selectedColor=op.color;
                      selected_option=op;
                    });
                  },
                  child: drawBox(null,HexColor(op.color!))));

          colorsList.add(op.color!);
        }

      if(op.size!=null && !sizesList.contains(op.size) && op.color==selectedColor)
      {
        sizes.add(
            InkWell(
                onTap: (){
                  setState(() {
                    selectedSize=op.size;
                  });
                },
                child: drawBox(op.size!,null)));
        sizesList.add(op.size!);
      }

    });
    }

    return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        colors.isNotEmpty?drawColors(colors):const Text(''),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: drawLine(),
        ),
        sizes.isNotEmpty?drawSizes(sizes):const Text(""),

    ]);
   }

  Widget drawDescription() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextUtility(
              "product  description:", 18, Colors.indigo, 1, FontWeight.bold),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                product.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "We're the sheet metal fiber laser cutting machine manufacturer in China, CE&ISO certified. With top quality, affordable price, and no one cares more about after sales than we do. Customized Machine.",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
  Widget drawLine() {
    return Container(
      color: Colors.green.withOpacity(0.5),
      height: 2,
      width: MediaQuery.of(context).size.width * 0.5,
    );
  }

  Widget drawBox(String? text,Color? color)
  {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: color??Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: (selectedSize!=null && selectedSize==text) || (selectedColor!=null && HexColor(selectedColor!)==color)?Colors.green:Colors.black,
              spreadRadius: 4
            )
          ]
        ),
        child: Center(child: Text(text??"")),
      ),
    );
  }

  Widget drawColors(List<Widget>colors) {
    return Column(

      children: [
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text("select Color:"),
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children:colors)),
      ],
    );
  }

 Widget drawSizes(List<Widget>sizes) {
    return Column(

      children: [
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text("select size:"),
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: sizes)),
      ],
    );
 }


  void addTocart() {
    CartBloc cartbloc = BlocProvider.of<CartBloc>(context);
    cartbloc.add(AddToCartEvent(product.product_id, 1, selected_option));

  }
}
