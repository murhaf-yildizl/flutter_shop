
import '../../../utilities/exceptions/exception_messages.dart';

class Country_State{
  late int state_id;
  late String state_name;

  Country_State(this.state_id, this.state_name);

  Country_State.fromJson(Map<String,dynamic>map)
  {
    if(map['state_id']==null || map['state_name']==null)
      throw ExceptionMessage("state id or name is null").toString();

    this.state_id=map['state_id'];
    this.state_name=map['state_name'];
  }
}
