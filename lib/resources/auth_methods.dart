import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scholarship_flutter_application/models/user.dart' as models;
import 'package:scholarship_flutter_application/resources/storage_methods.dart';

class auth_methods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<models.UserDetails> getuserdetails() async {
    User currentuser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentuser.uid).get();
    return models.UserDetails.fromSnap(snap);
  }

  Future<String> signup({
    required String email,
    required String password,
    required String username,
    required String bio,
    required String role,
    required Uint8List file,
  }) async {
    String res = 'Some error has occured';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          role.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        String photourl = await Storagemethods()
            .uploadimagetostorage('profilepics', file, false);

        models.UserDetails user = models.UserDetails(
          username: username,
          uid: cred.user!.uid,
          email: email,
          password: password,
          bio: bio,
          role: role,
          photourl: photourl,
          followers: [],
          following: [],
        );

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = 'Success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginuser(
      {required String email, required String password}) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'Success';
      } else {
        res = 'Please enter all the feilds';
      }
    } catch (err) {
      res.toString();
    }
    return res;
  }

  Future<void> signout() async {
    await _auth.signOut();
  }
}
