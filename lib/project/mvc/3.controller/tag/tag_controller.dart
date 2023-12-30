import 'package:shop/project/mvc/1.model/tag/tag.dart';

class TagController{
  static List<Tag>tags=[];

  static List<Tag>map_to_List(List<dynamic>map)
  {
    tags=[];
    if(map.isEmpty)
      return [];
    map.forEach((element) {
      tags.add(Tag.fromJson(element));
    });
    return tags;

  }
}