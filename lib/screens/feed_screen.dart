import 'package:flutter/material.dart';

import 'package:scholarship_flutter_application/provider/user_provider.dart';

import 'package:scholarship_flutter_application/screens/add_post_screen.dart';
import 'package:scholarship_flutter_application/utils/colors.dart';

import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:scholarship_flutter_application/screens/profile_screen.dart';
import 'package:scholarship_flutter_application/screens/search_screen.dart';

import 'package:scholarship_flutter_application/widgets/post_card.dart';

import 'package:firebase_auth/firebase_auth.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    adddata();
  }

  void adddata() async {
    UserProvider _userprovider = Provider.of(context, listen: false);
    await _userprovider.refreshuser();
  }

  @override
  Widget build(BuildContext context) {
    var role;
    void getRole() async {
      var usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      role = usersnap['role'];
      print(role);
    }

    getRole();

    return Scaffold(
      appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          leading: const Icon(
            Icons.search_rounded,
            color: Colors.white60,
            size: 28,
          ),
          title: TextFormField(
            cursorColor: const Color.fromARGB(255, 141, 137, 137),
            decoration: const InputDecoration(
                hintText: 'Search',
                focusColor: Colors.grey,
                hoverColor: Colors.grey),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SearchScreen())),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                            uid: FirebaseAuth.instance.currentUser!.uid)));
                print(FirebaseAuth.instance.currentUser!.uid);
              },
              icon: const Icon(Icons.person),
            ),
            (role!="Sponsor")?IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddPostScreen())),
              icon: const Icon(Icons.add_circle_outline),
            ):Text(""),

          ]),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => Container(
                    child: PostCard(
                      snap: snapshot.data!.docs[index].data(),
                    ),
                  ));
        },
      ),
    );
  }
}
