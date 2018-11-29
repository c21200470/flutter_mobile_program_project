import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String title;
  final int price;
  final String content;
  final String creator;
  final String created;
  final String modified;
  final String imgurl;
  final String group;
  final int postid;

  final bool book, clothes, free, furniture, house, other, utility;
  final String profilepic, uid, username;
//  final bool ss, s, a, b, c, d, direct, freeship, ship;

  final DocumentReference reference;

  Post.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['price'] != null),
        assert(map['content'] != null),
        assert(map['imgurl'] != null),
        assert(map['creator'] != null),
        assert(map['created'] != null),
        assert(map['modified'] != null),
        assert(map['postid'] != null),
        assert(map['group'] != null),
        title = map['name'],
        price = map['price'],
        content = map['description'],
        imgurl = map['imgurl'],
        creator = map['creator'],
        created = map['created'],
        modified = map['modified'],
        postid = map['postid'],
        group = map ['group'];


  Post.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

}