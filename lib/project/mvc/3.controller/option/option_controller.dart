
import '../../1.model/option/option.dart';

class OptionController
{
  static List<Option>options=[];


  static List<Option>map_to_List(List<dynamic> map)
  {

    options=[];

    if(map==null  )
      return [];
    // var list=Map<String,dynamic>.from(map);
    // list.forEach((key, value) {
     // var ll=List<dynamic>.from(value);
      map.forEach((element) {
        options.add(Option.fromJson(element));

      });

    //});


     return options;

  }
}