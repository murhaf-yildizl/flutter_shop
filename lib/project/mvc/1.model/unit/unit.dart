
class Unit{
  late int unit_id;
  late String unit_name,unit_code;

  Unit(this.unit_id, this.unit_name, this.unit_code);

  Unit.fromJson(Map<String,dynamic>map)
  {

    this.unit_id=map['unit_id'];
    this.unit_name=map['unit_name'];
    this.unit_code=map['unit_code'];

  }
}