
import '../../../utilities/exceptions/exception_messages.dart';

class Country{
  late int country_id;
  late String country_name;

  Country(this.country_id, this.country_name);

  Country.fromJson(Map<String,dynamic>map)
  {
    if(map['country_id']==null || map['country_name']==null)
      throw ExceptionMessage("country id or name is null").toString();

    this.country_id=map['country_id'];
    this.country_name=map['country_name'];
  }
}
