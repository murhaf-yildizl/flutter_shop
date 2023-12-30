import 'dart:convert';
import 'package:shop/project/mvc/1.model/category/category.dart';
import 'package:shop/project/mvc/3.controller/image/image_controller.dart';
import 'package:shop/project/mvc/3.controller/option/option_controller.dart';
import 'package:shop/project/mvc/3.controller/tag/tag_controller.dart';
import 'package:shop/project/mvc/1.model/unit/unit.dart';
import '../../../utilities/exceptions/exception_messages.dart';
import '../../3.controller/review/review_controller.dart';
import '../image/image.dart';
import '../option/option.dart';
import '../review/review.dart';
import '../tag/tag.dart';

class Product{

  late int product_id,qnty;
  late String name,description;
  late double price,discount;
  late Unit unit;
  List<Category> categories=[];
  List<ProductImage> images=[];
  List<Option> options=[];
  List<Tag>tags=[];
  List<Review>reviews=[];

  Product(this.product_id,this.name,this.description,this.price,
          this.qnty,this.discount,this.unit,this.images,this.options,
          this.tags,this.reviews);

  Product.fromJson(Map<dynamic,dynamic>map)
  {

    this.product_id=map['product_id'];
    this.name=map['product_name'];
    this.description=map['product_description'];
    this.price=double.tryParse(map['product_price'].toString())!;
    this.discount=double.tryParse(map['product_discount'].toString())!;
    this.qnty=int.tryParse(map['product_qnty'].toString())!;
    this.unit=Unit.fromJson(map['unit']);

    if(map['categories']!=null)
       this.categories=List.generate(map['categories'].length, (index) =>
          Category.fromJson(map['categories'][index]) );

    this.images=ImageController.map_to_List(map['images']);
    this.tags=TagController.map_to_List(map['tags']);
    this.reviews=ReviewController.map_to_List(map['reviews']);

    if(map['options']!=null)
      if(map['options'].length>0)
    {
      var opt=jsonEncode(map['options']);
      this.options =OptionController.map_to_List(jsonDecode(opt));

          }


  }



}