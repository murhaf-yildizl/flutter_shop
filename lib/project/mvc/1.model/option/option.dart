import 'dart:convert';
import '../image/image.dart';

class Option{
     String? color,size;
     int? qnt;
  List<ProductImage>imagesList=[];

  Option(this.color, this.size,this.qnt,this.imagesList);
  
  Option.fromJson(Map<String,dynamic>map){

    List<dynamic> images=[];

    ///print("map[images]= ${map['images']}");
    imagesList=[];
    this.color=map['color'];
    this.size=map['size'];
    this.qnt=int.tryParse(map['Quantity'].toString())??0 ;

     if(map['images']!="NULL")
       map['images'].forEach((image) {
        imagesList.add(ProductImage.fromJson(image));

      });

   }


   static Map<String,dynamic> toJson(Option op){
     print(">>>> <<<< ${op.color} ${op.size} ${op.qnt} ${op.imagesList.length}" );

     return {

        'color':op.color,
        'size':op.size,
        'Quantity':op.qnt.toString(),
        'images':ProductImage.toJson(op.imagesList)
       };
    }
}