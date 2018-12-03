import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name, uid, profile_pic, email, group;
  final List<dynamic> favorite, post;

  final DocumentReference reference;

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['uid'] != null),
        assert(map['profile_pic'] != null),
        assert(map['email'] != null),
        assert(map['group'] != null),

        name = map['name'],
        uid = map['uid'],
        profile_pic = map['profile_pic'],
        email = map['email'],
        favorite = List.from(map['favorite']),
        group = map['group'],
        post = List.from(map['post']);

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}