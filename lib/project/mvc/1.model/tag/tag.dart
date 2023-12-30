
import '../../../utilities/exceptions/exception_messages.dart';

class Tag{
  late int id;
  late String name;

  Tag(this.id, this.name);

  Tag.fromJson(Map<String,dynamic>map)
  {
    this.id=map['tag_id'];
    this.name=map['tag_name'];
  }
}