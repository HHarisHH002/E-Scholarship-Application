import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scholarship_flutter_application/models/post.dart';
import 'package:scholarship_flutter_application/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profimage) async {
    String res = 'Some error occured';
    try {
      String photourl =
          await Storagemethods().uploadimagetostorage('posts', file, true);
      String postid = const Uuid().v1();

      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          postid: postid,
          datepublished: DateTime.now(),
          posturl: photourl,
          profimage: profimage,
          likes: []);
      _firestore.collection('posts').doc(postid).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likepost(String postid, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postid).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postid).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> postcomment(String postid, String text, String uid, String name,
      String profilepic) async {
    try {
      if (text.isNotEmpty) {
        String commentid = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postid)
            .collection('comments')
            .doc(commentid)
            .set({
          'profilepic': profilepic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentid': commentid,
          'datepublished': DateTime.now(),
        });
      } else {
        print('Text is Empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletepost(String postid) async {
    try {
      await _firestore.collection('posts').doc(postid).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followuser(String uid, String followuid) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(followuid)) {
        await _firestore.collection('users').doc(followuid).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followuid])
        });
      } else {
        await _firestore.collection('users').doc(followuid).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followuid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
