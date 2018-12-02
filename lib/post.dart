import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String title, content, creator_name, creator_uid, creator_pic, group, category;
  final String created, modified;
  final List<dynamic> imgurl;
  final int price, postid;

//  final bool ss, s, a, b, c, d, direct, freeship, ship;

  final DocumentReference reference;

  Post.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['content'] != null),
        assert(map['imgurl'] != null),
        assert(map['creator_name'] != null),
        assert(map['creator_pic'] != null),
        assert(map['creator_uid'] != null),
        assert(map['group'] != null),
        assert(map['category'] != null),
        assert(map['created'] != null),
        assert(map['modified'] != null),
        assert(map['price'] != null),
        assert(map['postid'] != null),


        title = map['title'],
        content = map['content'],
        imgurl = map['imgurl'],
        creator_name = map['creator_name'],
        creator_pic = map['creator_pic'],
        creator_uid = map['creator_uid'],
        group = map['group'],
        category = map['category'],
        created = map['created'],
        modified = map['modified'],
        price = map['price'],
        postid = map['postid'];

  Post.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

}