
import 'package:shop/project/mvc/1.model/image/image.dart';

class ImageController{
 static List<ProductImage>images=[];

  static List<ProductImage>map_to_List(List<dynamic>map)
  {
    //print("images=-------------------------"+map.toString());
    images=[];
    if(map.isEmpty)
      return [];
    map.forEach((element) {

      images.add(ProductImage.fromJson(element));
    });
     return images;

}
}