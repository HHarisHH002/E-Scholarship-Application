import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postid;
  final datepublished;
  final String posturl;
  final String profimage;
  final likes;

  const Post(
      {required this.description,
      required this.uid,
      required this.username,
      required this.postid,
      required this.datepublished,
      required this.posturl,
      required this.profimage,
      required this.likes});
  Map<String, dynamic> toJson() => {
        'description': description,
        'uid': uid,
        'username': username,
        'postid': postid,
        'datepublished': datepublished,
        'posturl': posturl,
        'profimage': profimage,
        'likes': likes
      };
  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
        description: snapshot['description'],
        uid: snapshot['uid'],
        username: snapshot['username'],
        postid: snapshot['postid'],
        datepublished: snapshot['datepublished'],
        posturl: snapshot['posturl'],
        profimage: snapshot['profimage'],
        likes: snapshot['likes']);
  }
}
