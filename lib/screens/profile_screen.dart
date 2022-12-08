import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scholarship_flutter_application/resources/auth_methods.dart';
import 'package:scholarship_flutter_application/resources/firestore_methods.dart';
import 'package:scholarship_flutter_application/screens/login_screen.dart';
import 'package:scholarship_flutter_application/utils/colors.dart';
import 'package:scholarship_flutter_application/utils/utils.dart';
import 'package:scholarship_flutter_application/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userdata = {};
  int postlength = 0;
  int followers = 0;
  int following = 0;
  bool isfollowing = false;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      setState(() {
        isloading = true;
      });
      var usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postsnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postlength = postsnap.docs.length;
      followers = usersnap.data()!['followers'].length;
      following = usersnap.data()!['following'].length;
      userdata = usersnap.data()!;
      isfollowing = usersnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showsnackbar(e.toString(), context);
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userdata['username']),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(userdata['photourl']),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildstatColumn(postlength, 'Scholarship'),
                                    buildstatColumn(followers, 'Followers'),
                                    buildrateColumn('2/5', 'Rating')
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? Followbutton(
                                            backgroundcolor:
                                                mobileBackgroundColor,
                                            bordercolor: Colors.grey,
                                            function: () async {
                                              await auth_methods().signout();
                                              Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Loginscreen()));
                                            },
                                            text: 'Sign Out',
                                            textcolor: primaryColor)
                                        : isfollowing
                                            ? Followbutton(
                                                backgroundcolor: Colors.white,
                                                bordercolor: Colors.grey,
                                                function: () async {
                                                  await FirestoreMethods()
                                                      .followuser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userdata['uid']);
                                                  setState(() {
                                                    isfollowing = false;
                                                    followers--;
                                                  });
                                                },
                                                text: 'Unfollow',
                                                textcolor: Colors.black)
                                            : Followbutton(
                                                backgroundcolor: Colors.blue,
                                                bordercolor: Colors.blue,
                                                function: () async {
                                                  await FirestoreMethods()
                                                      .followuser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userdata['uid']);
                                                  setState(() {
                                                    isfollowing = true;
                                                    followers++;
                                                  });
                                                },
                                                text: 'Follow',
                                                textcolor: Colors.white)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          userdata['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 3),
                        child: Text(userdata['bio']),
                      )
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return GridView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 1.5,
                                    childAspectRatio: 1),
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap =
                                  (snapshot.data! as dynamic).docs[index];
                              return Container(
                                child: Image(
                                  image: NetworkImage((snap['posturl'])),
                                  fit: BoxFit.cover,
                                ),
                              );
                            });
                      }
                    })
              ],
            ),
          );
  }

  Column buildstatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        )
      ],
    );
  }

  Column buildrateColumn(String num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}
