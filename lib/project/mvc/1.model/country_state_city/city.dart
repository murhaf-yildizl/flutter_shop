
import '../../../utilities/exceptions/exception_messages.dart';

class City{
 late int city_id;
 late String city_name;

 City(this.city_id, this.city_name);

 City.fromJson(Map<String,dynamic>map)
 {
   if(map['city_id']==null || map['city_name']==null)
     throw ExceptionMessage("city id or name is null").toString();
   this.city_id=map['city_id'];
   this.city_name=map['city_name'];
 }
}
