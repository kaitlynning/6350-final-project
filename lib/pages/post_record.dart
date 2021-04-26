import 'package:cloud_firestore/cloud_firestore.dart';

class PostDetail {
  String title;
  String price;
  String description;
  List<String> pathList;
  bool liked;

  PostDetail(
      String title, String price, String description, List<String> pathList) {
    this.title = title;
    this.price = price;
    this.description = description;
    this.pathList = pathList;
    this.liked = false;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map["title"] = this.title;
    map["price"] = this.price;
    map["description"] = this.description;
    for (String s in pathList) {
      print("pathList item: ${s}");
    }

    map["photos"] = this.pathList;
    map["liked"] = this.liked;
    return map;
  }
}

class Record {
  final String title;
  final String price;
  final String description;
  final List<String> photos;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['price'] != null),
        assert(map['description'] != null),
        assert(map['images'] != null),
        title = map['title'],
        price = map['price'].toString(),
        description = map['description'],
        photos = map['images'].cast<String>();

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$title:$price:$description>";
}
