
class ProductImage {
    int? image_id;
    String? url, title;

  ProductImage(this.image_id, this.url, this.title);

  ProductImage.fromJson(Map<String, dynamic> map) {
    this.image_id = map['id'];
    this.url = map['url'];
  }

  static List<Map<String, dynamic>> toJson(List<ProductImage> images) {
    List<Map<String, dynamic>> map = [];

    images.forEach((img) {
      if(img.url==null)
        img.url='';
      if(img.title==null)
        img.title='';

      map.add({'url': img.url, 'title': img.title});
    });

    return map;
  }
}
