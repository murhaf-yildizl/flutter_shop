
import '../../../utilities/exceptions/exception_messages.dart';
import '../customer/User.dart';

class Review{

  late int id,stars;
  late String text;
  late User reviewer;
  late String date;

  Review(this.id, this.stars, this.text, this.reviewer,this.date);

  Review.fromJson(Map<String,dynamic>map){

         this.id=map['review_id'];
         this.stars=map['stars'];
         this.text=map['comment'];
         this.reviewer=User.Reviewer_fromJson(map['reviewer']);
         this.date=map['date'];
  }
}