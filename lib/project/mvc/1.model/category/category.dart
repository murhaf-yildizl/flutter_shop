
 class Category{
   int? id,parent_id;
   String? name,image_url,icon_url;

  Category(this.id, this.name,this.image_url,this.icon_url,this.parent_id);

 Category.fromJson(Map<String,dynamic>map)
 {
   this.id=map['cat_id'];
   this.name=map['name'];
   this.image_url=map['image_url'];
   this.icon_url=map['icon_url'];
   this.parent_id=map['parent_id'];
 }
}