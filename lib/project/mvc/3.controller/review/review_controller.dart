
import '../../1.model/review/review.dart';

class ReviewController{

  static List<Review>reviews=[];

  static List<Review>map_to_List(List<dynamic>map)
  {
    reviews=[];
    if(map!=null)
      if(map.isEmpty)
      return [];
    map.forEach((element) {
      reviews.add(Review.fromJson(element));
    });
    return reviews;

  }
}