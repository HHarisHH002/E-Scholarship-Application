import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scholarship_flutter_application/screens/profile_screen.dart';
import 'package:scholarship_flutter_application/utils/colors.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchcontroller = TextEditingController();
  bool isshowusers = false;
  @override
  void dispose() {
    super.dispose();
    _searchcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          leading: const Icon(
            Icons.search_rounded,
            color: Colors.white60,
            size: 28,
          ),
          title: TextFormField(
            controller: _searchcontroller,
            cursorColor: Colors.grey,
            decoration: const InputDecoration(
                hintText: 'Search',
                focusColor: Colors.grey,
                hoverColor: Colors.grey),
            onFieldSubmitted: (String _) {
              setState(() {
                isshowusers = true;
              });
            },
          ),
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .where('username', isGreaterThanOrEqualTo: _searchcontroller.text)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: (snapshot.data! as dynamic).docs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                            uid: (snapshot.data! as dynamic).docs[index]
                                ['uid']),
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            (snapshot.data! as dynamic).docs[index]
                                ['photourl']),
                      ),
                      title: Text(
                          (snapshot.data! as dynamic).docs[index]['username']),
                    ),
                  );
                });
          },
        ));
  }
}
