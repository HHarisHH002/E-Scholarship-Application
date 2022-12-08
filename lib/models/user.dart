import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  final String email;
  final String password;
  final String uid;
  final String photourl;
  final String username;
  final String bio;
  final String role;
  final List followers;
  final List following;

  const UserDetails(
      {required this.email,
      required this.password,
      required this.uid,
      required this.username,
      required this.bio,
      required this.role,
      required this.photourl,
      required this.followers,
      required this.following});
  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'username': username,
        'uid': uid,
        'bio': bio,
        'role': role,
        'photourl': photourl,
        'followers': followers,
        'following': following
      };
  static UserDetails fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserDetails(
        email: snapshot['email'],
        password: snapshot['password'],
        username: snapshot['username'],
        uid: snapshot['uid'],
        bio: snapshot['bio'],
        role: snapshot['role'],
        photourl: snapshot['photourl'],
        followers: snapshot['followers'],
        following: snapshot['following']);
  }
}
