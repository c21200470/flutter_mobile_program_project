import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String title;
  final int price;
  final String content;
  final String creator;
  final String created;
  final String modified;
  final String category;
  final String favorite;
  final String url;
  final DocumentReference reference;

  Post.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['price'] != null),
        assert(map['content'] != null),
        assert(map['url'] != null),
        assert(map['creator'] != null),
        assert(map['created'] != null),
        assert(map['modified'] != null),
        assert(map['favorite'] != null),
        assert(map['category'] != null),
        title = map['name'],
        price = map['price'],
        content = map['description'],
        url = map['url'],
        creator = map['creator'],
        created = map['created'],
        modified = map['modified'],
        category = map['category'],
        favorite = map['favorite'];


  Post.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

}