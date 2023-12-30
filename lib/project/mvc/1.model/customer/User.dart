
class User
{
  late String first_name,last_name,email,api_token;
  late int user_id;

  User(this.first_name, this.last_name, this.email,[this.api_token="",this.user_id=0]);

  User.fromJson(Map<String,dynamic>map){

   this.user_id=map['user_id'];
   this.first_name=map['first_name'];
   this.last_name=map['last_name'];
   this.email=map['email'];
   this.api_token=map['api_token'];

  }
  User.Reviewer_fromJson(Map<String,dynamic>map){

    this.first_name=map['first_name'];
    this.last_name=map['last_name'];
    this.email=map['email'];
    this.user_id=map['user_id'];

  }
 String fullName() {
    return this.first_name+" "+this.last_name;
 }
}